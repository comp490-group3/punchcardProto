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
    NSLog(@"%d", _selectedPlace.redeemed);
     
    //check punches earned vs. punches required, modify REDEEM action as necessary
    if(_selectedPlace.canRedeem)
    {
        NSLog(@"Inside If");
        _punchProgress.progressTintColor = [UIColor greenColor];
        _redeemButton.alpha = 1;
        _redeemBackground.alpha = 1;
        _redeemBackground.backgroundColor = [UIColor greenColor];
        [_redeemButton setEnabled:YES];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex == [alertView cancelButtonIndex]){
        //cancel pressed
        NSLog(@"redeem later");
    }else{
        //redeem now pressed
        NSLog(@"attempting to redeem");
        
        NSString *redeemURLstring = [NSString stringWithFormat:@"http://punchd.herokuapp.com/offers/%@/redeem/", _selectedPlace.offerID];
        NSURL *redeemURL = [NSURL URLWithString:redeemURLstring];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:redeemURL];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        [_redeemButton setEnabled:NO];
        _punchProgress.progressTintColor = [UIColor orangeColor];
        _redeemButton.alpha = 0.4;
        _redeemBackground.alpha = 0.35;
        
    }
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
    UIAlertView *redeemAlert = [[UIAlertView alloc]initWithTitle:@"Congratulations!"
                                                         message:[NSString stringWithFormat:(@"You've reached %@ punches at %@! Would you like to redeem your offer now?"), _selectedPlace.punchesReq, _selectedPlace.name]
                                                        delegate:self
                                               cancelButtonTitle:@"Maybe Later"
                                               otherButtonTitles:@"Redeem!", nil];
    
    [redeemAlert show];

}

@end
