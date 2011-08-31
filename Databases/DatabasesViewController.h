//
//  DatabasesViewController.h
//  Databases
//
//  Created by bhuvan khanna on 31/08/11.
//  Copyright 2011 webonise software solutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h" 

@interface DatabasesViewController : UIViewController
{
     sqlite3 *db;
    NSMutableArray *tableData;
    IBOutlet UITextField *name;
    IBOutlet UITableView *tv;
    IBOutlet UITableViewCell *selectedcell;

}
@property(nonatomic,retain)IBOutlet UITextField *name;
@property(nonatomic,retain)IBOutlet UITableView *tv;
@property(nonatomic,retain)IBOutlet UITableViewCell *selectedcell;

-(NSString *) filePath; 
-(IBAction)insertData:(id)sender;
-(IBAction)deleteData:(id)sender;
-(void)showList;


@end
