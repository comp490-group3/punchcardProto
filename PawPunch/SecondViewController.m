//
//  SecondViewController.m
//  PawPunch
//
//  Created by Amir Saifi on 9/15/15.
//  Copyright (c) 2015 Amir Saifi. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@property(nonatomic)BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property NSString *scannedQRstring;

@property PFQuery *query;

-(void)loadBeepSound;
-(BOOL)startReading;
-(void)stopReading;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _isReading = NO;
    _captureSession = nil;
    _scannedQRstring = nil;
    [self loadBeepSound];
    _query = [PFQuery queryWithClassName:@"Business"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if(metadataObjects != nil && [metadataObjects count] > 0){
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex: 0];
        if([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]){
            [_labelStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            NSLog(@"%@", [metadataObj stringValue]);
            _scannedQRstring = [metadataObj stringValue];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_startButton performSelectorOnMainThread:@selector(setTitle:) withObject:@"Punch" waitUntilDone:NO];
            _isReading = NO;
            
            [self performSelectorInBackground:@selector(queryPunchDatabase) withObject:nil];
            
            if(_audioPlayer){
                [_audioPlayer play];
            }
        }
    }
}

- (void)queryPunchDatabase {
    _query = [PFQuery queryWithClassName:@"Business"];
    [_query getObjectInBackgroundWithId:_scannedQRstring block:^(PFObject *business, NSError *error){
        [_businessLabel setText:business[@"businessName"]];
        [_descriptionTextView setText:business[@"rewardDescription"]];
        [_descriptionTextView setTextColor:[UIColor orangeColor]];
        [_descriptionTextView setTextAlignment:NSTextAlignmentCenter];
        //Progress Bar populated with mock data
        NSString *punchTemp = [NSString stringWithFormat:(@"%@/%@"), business[@"punchesEarned"], business[@"punchesRequired"]];
        [_punchTotalLabel setText:punchTemp];
        [_punchProgressBar setProgress: .4 animated:YES];
        
    }];
    

}

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
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

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
            [_startButton setTitle:@"Stop" forState:UIControlStateNormal];
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
