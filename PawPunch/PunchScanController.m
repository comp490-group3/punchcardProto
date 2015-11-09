//
//  SecondViewController.m
//  PawPunch
//
//  Created by Amir Saifi on 9/15/15.
//  Copyright (c) 2015 Amir Saifi. All rights reserved.
//

#import "PunchScanController.h"

@interface PunchScanController () 

@property(nonatomic)BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property NSString *scannedQRstring;
@property NSString *offerID;

-(void)loadBeepSound;
-(BOOL)startReading;
-(void)stopReading;

@end

@implementation PunchScanController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _isReading = NO;
    _captureSession = nil;
    _scannedQRstring = nil;
    responseData = [NSMutableData data];
    [self loadBeepSound];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if(metadataObjects != nil && [metadataObjects count] > 0){
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex: 0];
        
        //If QR Code is Scanned
        if([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode] || [[metadataObj type] isEqualToString:AVMetadataObjectTypeUPCECode]){
            [_labelStatus performSelectorOnMainThread:@selector(setText:) withObject:@"You've punched at..." waitUntilDone:NO];
            
            NSLog(@"%@", [metadataObj stringValue]);
            _scannedQRstring = [metadataObj stringValue];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_startButton performSelectorOnMainThread:@selector(setTitle:) withObject:@"Punch" waitUntilDone:NO];
            _isReading = NO;
            
            [self queryPunchDatabase];
            
            if(_audioPlayer){
                [_audioPlayer play];
            }
        }
    }
}

- (void)queryPunchDatabase {
    
    NSString *qrValidationID;
    NSString *businessPunchID;
    if(_scannedQRstring.length < 7)
    {
        qrValidationID = @"badData";
    } else {
    businessPunchID = [_scannedQRstring substringFromIndex:7];
    qrValidationID = [_scannedQRstring substringToIndex:6];
    NSLog(@"%@", qrValidationID);
    NSLog(@"Scanned QR id: %@", businessPunchID);
    }
    NSString *punchURLstring = [NSString stringWithFormat:@"http://punchd.herokuapp.com/businesses/%@/punch/", businessPunchID];
    NSURL *punchURL = [NSURL URLWithString:punchURLstring];
  
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:punchURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
        NSLog(@"Received punch data???");
        NSError *error;
        NSDictionary *jsonPunch = [NSJSONSerialization
                                   JSONObjectWithData:data
                                   options:kNilOptions
                                   error:&error];
        NSDictionary *jsonBusiness = jsonPunch[@"business"];
        BOOL canRedeem = [jsonPunch[@"can_redeem"] boolValue];
        _offerID = jsonPunch[@"id"];
        
        if(![qrValidationID  isEqual:@"punchd"]){
            
            NSLog(@"punch not from database");
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Huh??"
                                                                  message:@"Sorry Chief, but this doesn't look like a participating Punch'd business" delegate:self
                                                        cancelButtonTitle:@"Oops..." otherButtonTitles:nil, nil];
            [errorAlert show];
        
        } else if(jsonPunch[@"status"])
        {
            NSLog(@"exceeded punches required");
            UIAlertView *redeemAlert = [[UIAlertView alloc] initWithTitle:@"Excuse Us..."
                                                                  message:@"Looks like you've already completed the amount of punches for this offer! Check My Places to see if you've redeemed this offer." delegate:self
                                                        cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
            [redeemAlert show];
            
        }else{
        
            [_businessLabel setText:jsonBusiness[@"name"]];
            [_descriptionTextView setText:jsonPunch[@"name"]];
            [_descriptionTextView setTextColor:[UIColor orangeColor]];
            [_descriptionTextView setTextAlignment:NSTextAlignmentCenter];
            NSString *punchTemp = [NSString stringWithFormat:(@"%@/%@"), jsonPunch[@"punch_total"], jsonPunch[@"punch_total_required"]];
            [_punchTotalLabel setText:punchTemp];
            float punchTotal = [jsonPunch[@"punch_total"] floatValue];
            float punchReq = [jsonPunch[@"punch_total_required"] floatValue];
            float c = punchTotal/punchReq;
            [_punchProgressBar setProgressTintColor:[UIColor orangeColor]];
            [_punchProgressBar setProgress:c animated:YES];
            if(canRedeem)
            {
                [_punchProgressBar setProgressTintColor:[UIColor greenColor]];
                UIAlertView *redeemAlert = [[UIAlertView alloc]initWithTitle:@"Congratulations!"
                                                                     message:[NSString stringWithFormat:(@"You've reached %@ punches at %@! Would you like to redeem your offer now?"), jsonPunch[@"punch_total_required"], _businessLabel.text]
                                                                    delegate:self
                                                           cancelButtonTitle:@"Maybe Later"
                                                           otherButtonTitles:@"Redeem!", nil];
                
                [redeemAlert show];
                
            }
            
        }
        
    }];
    
    NSLog(@"Success: ");
  
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == [alertView cancelButtonIndex]){
        //cancel pressed
        NSLog(@"redeem later");
    }else{
        //redeem now pressed
        //sends GET Request to backend indicating offer is being redeemed
        NSLog(@"attempting to redeem");
        
        NSString *redeemURLstring = [NSString stringWithFormat:@"http://punchd.herokuapp.com/offers/%@/redeem/", _offerID];
        NSURL *redeemURL = [NSURL URLWithString:redeemURLstring];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:redeemURL];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    }
}


// Enables camera on screen to capture QR or UPC-E code -> (UPC-E not yet implemented but is scannable)
- (BOOL)startReading {
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if(!input){
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

// Closes camera capture
- (void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

// Plays sound when a code is scanned
- (void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if(error){
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
    }
}

- (IBAction)startStopReading:(id)sender {
    
    if(!_isReading)
    {
        if([self startReading])
            [_startButton setTitle:@"Punch again!" forState:UIControlStateNormal];
        [_labelStatus setText:@"Scanning for QR Code..."];
        
    }
    else
    {
        [self stopReading];
        [_startButton setTitle:@"Punch" forState:UIControlStateNormal];
    }
    
    _isReading = !_isReading;
}


@end
