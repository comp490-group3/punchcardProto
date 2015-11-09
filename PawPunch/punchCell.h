//
//  punchCell.h
//  PawPunch
//
//  Created by Amir Saifi on 9/22/15.
//  Copyright © 2015 Amir Saifi. All rights reserved.
//

#import <UIKit/UIKit.h>

// Class for custom Cell for List tableView
@interface punchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *businessName;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end
