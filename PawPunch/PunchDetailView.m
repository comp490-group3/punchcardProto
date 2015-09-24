//
//  PunchDetailView.m
//  PawPunch
//
//  Created by Amir Saifi on 9/23/15.
//  Copyright © 2015 Amir Saifi. All rights reserved.
//

#import "PunchDetailView.h"

@interface PunchDetailView ()

@end

@implementation PunchDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _nameLabel.text = _selectedPlace.name;
    _addressLabel.text = _selectedPlace.address;
    _rewardDescription.text = _selectedPlace.rewardDescription;
    _earnedPunches.text = [_selectedPlace.punchesEarned stringValue];
    _requiredPunches.text = [_selectedPlace.punchesReq stringValue];
    NSLog(@"almost made it");
    float a = [_selectedPlace.punchesEarned floatValue];
    float b = [_selectedPlace.punchesReq floatValue];
    float c = a/b;
    _punchProgress.progress = c;
    NSLog(@"Made it");
    
    //check punches earned vs. punches required, modify REDEEM action as necessary
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)redeemButton:(id)sender {
    NSLog(@"button was touched");
}
@end
