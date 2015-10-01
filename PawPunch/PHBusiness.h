//
//  PHBusiness.h
//  PawPunch
//
//  Created by Amir Saifi on 9/22/15.
//  Copyright © 2015 Amir Saifi. All rights reserved.
//kd

#import <Foundation/Foundation.h>

@interface PHBusiness : NSObject

@property (strong) NSString *offerID;
@property (strong) NSString *rewardDescription;
@property (strong) NSString *businessID;
@property (strong) NSString *name;
@property (strong) NSString *address;
@property (strong) NSNumber *punchesEarned;
@property (strong) NSNumber *punchesReq;
@property BOOL canRedeem;
@property BOOL redeemed;



@end
