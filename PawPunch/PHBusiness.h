//
//  PHBusiness.h
//  PawPunch
//
//  Created by Amir Saifi on 9/22/15.
//  Copyright © 2015 Amir Saifi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHBusiness : NSObject

@property (strong) NSString *objID;
@property (strong) NSString *name;
@property (strong) NSString *rewardDescription;
@property (strong) NSNumber *punchesReq;
@property (strong) NSNumber *punchesEarned;
@property (strong) NSString *address;
@property BOOL *prevCustomer;


@end
