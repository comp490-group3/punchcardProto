//
//  PunchDetailView.h
//  PawPunch
//
//  Created by Amir Saifi on 9/23/15.
//  Copyright © 2015 Amir Saifi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHBusiness.h"

@interface PunchDetailView : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *rewardDescription;
@property (weak, nonatomic) IBOutlet UILabel *earnedPunches;
@property (weak, nonatomic) IBOutlet UILabel *requiredPunches;
@property (weak, nonatomic) IBOutlet UIProgressView *punchProgress;

- (IBAction)redeemButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *redeemButton;
@property (weak, nonatomic) IBOutlet UITextField *redeemBackground;

@property PHBusiness *selectedPlace;


@end
