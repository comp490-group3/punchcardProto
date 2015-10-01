//
//  PunchListController.m
//  PawPunch
//
//  Created by Amir Saifi on 9/22/15.
//  Copyright © 2015 Amir Saifi. All rights reserved.
//

#import "PunchListController.h"
#import "PunchDetailView.h"
#import "AppDelegate.h"
#import "PHBusiness.h"
#import "punchCell.h"
#import <Parse/Parse.h>


@interface PunchListController ()

@property (nonatomic, weak) AppDelegate *delegate;
@property (nonatomic, strong) NSMutableArray *PHPlaces;
@property PHBusiness *selectedPlace;

@end

@implementation PunchListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    _PHPlaces = [self.delegate myPlaces];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor blueColor];
    [self.refreshControl addTarget:self action:@selector(refreshMyPlaces) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshMyPlaces {
    // ============================ HEROKU IMPLEMENTATION =========================== //
    NSString *offersListURL = [NSString stringWithFormat:@"http://punchd.herokuapp.com/offers/"];
    
    NSData *offersListData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:offersListURL]];
    
    NSError *error;
    NSArray *jsonOffersList = [NSJSONSerialization
                               JSONObjectWithData:offersListData
                               options:kNilOptions
                               error:&error];
    _PHPlaces = [[NSMutableArray alloc] initWithCapacity:[jsonOffersList count]];
    NSLog(@"Number of user's offers: %lu", [jsonOffersList count]);
    
    if(error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        for(NSDictionary *offer in jsonOffersList)
        {
            PHBusiness *next = [[PHBusiness alloc]init];
            next.offerID = offer[@"id"];
            next.rewardDescription = offer[@"name"];
            NSDictionary *business = offer[@"business"];
            next.businessID = business[@"id"];
            next.name = business[@"name"];
            next.address = business[@"address"];
            next.punchesEarned = offer[@"punch_total"];
            next.punchesReq = offer[@"punch_total_required"];
            next.canRedeem = [offer[@"can_redeem"] boolValue];
            next.redeemed = [offer[@"redeemed"] boolValue];
            
            NSLog(@"%@", next.name);
            [_PHPlaces addObject:next];
        }
        
    }
    NSLog(@"Done Querying");
    
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _PHPlaces.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    punchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"punchCell" forIndexPath:indexPath];
    _selectedPlace = [_PHPlaces objectAtIndex:indexPath.row];
    
    // Configure the cell...
    cell.businessName.text = _selectedPlace.name;
    cell.address.text = _selectedPlace.address;
   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

/* In a storyboard-based application, you will often want to do a little preparation before navigation */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    PunchDetailView *detailView = [segue destinationViewController];
    NSIndexPath *selectedPath = self.tableView.indexPathForSelectedRow;
    _selectedPlace = [_PHPlaces objectAtIndex:selectedPath.row];
    detailView.selectedPlace = _selectedPlace;
}


@end
