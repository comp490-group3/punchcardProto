//
//  SecondViewController.h
//  PawPunch
//
//  Created by Amir Saifi on 9/15/15.
//  Copyright (c) 2015 Amir Saifi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>

@interface PunchScanController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, NSURLConnectionDelegate, UIAlertViewDelegate>
{
    NSMutableData *responseData;
}
//QR Reader Properties
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;

@property (weak, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)startStopReading:(id)sender;

//View Description Properties
@property (weak, nonatomic) IBOutlet UILabel *businessLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UILabel *punchTotalLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *punchProgressBar;


@end

