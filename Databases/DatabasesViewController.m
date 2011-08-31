//
//  DatabasesViewController.m
//  Databases
//
//  Created by bhuvan khanna on 31/08/11.
//  Copyright 2011 webonise software solutions pvt ltd. All rights reserved.
//

#import "DatabasesViewController.h"

@implementation DatabasesViewController
@synthesize name,tv,selectedcell;

-(NSString *) filePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [paths objectAtIndex:0];
    
    return [documentsDir stringByAppendingPathComponent:@"database.sql"];
    
} 
-(void) openDB {
    
    //---create database---
    
    if (sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK )
    {
        NSString *createSql = @"CREATE TABLE user (id varchar(10), name varchar(100))";
        if (sqlite3_exec(db, [createSql cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL) == SQLITE_OK) 
        {
            
        }
        else {
            NSLog(@"error code createtable");
            
        }
        sqlite3_close(db);
    }
    else
    {
         /*   NSString *insertSql = @"INSERT INTO user (id,name) VALUES('004','fff')";
            int testvalue = sqlite3_exec(db, [insertSql cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL, NULL);
            if (testvalue == SQLITE_OK) 
            {
                NSLog(@"insert query ok");
            }
            else {
                NSLog(@"error code %i", testvalue);
            }*/
        
        sqlite3_stmt *statement=nil;
        const char *sql="select * from user";
        if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!= SQLITE_OK)
        {
          //  NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
            
        }
        else
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                
                [tableData addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 1)]];
                
            }
        }
        //release the resources
        sqlite3_finalize(statement);
        
        
      //  sqlite3_close(db);
   
    }
    
    
} 
-(IBAction)insertData:(id)sender
{
    NSString *text;
    NSString *tid;
    if ([name.text length] == 0) {
        UIAlertView *alert02 = [[UIAlertView alloc] initWithTitle:@"Insert Data" message:@"Please Enter name" delegate:nil cancelButtonTitle:@"Insert" otherButtonTitles:nil];
        [alert02 show];
        [alert02 release];
    }
    else
    {
        text=[[NSString alloc] initWithFormat:@"%@",name.text];
        tid=[[NSString alloc] initWithFormat:@"%@",@"004"];
     
        
      //  NSString *insertSql = @"INSERT INTO user (id,name) VALUES('004',%@)";
        int testvalue = sqlite3_exec(db, [[NSString stringWithFormat:@"insert into user (id,name) values ('%@', '%@')", tid, text] UTF8String], NULL, NULL, NULL);
        if (testvalue == SQLITE_OK) 
        {
            UIAlertView *alert02 = [[UIAlertView alloc] initWithTitle:@"Insert Data" message:@"Record inserted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert02 show];
            [alert02 release];
               NSLog(@"Data added %@",text);
            [self showList];
        }
        else {
            UIAlertView *alert02 = [[UIAlertView alloc] initWithTitle:@"Insert Data" message:@"Faild to insert Record" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert02 show];
            [alert02 release];
        }
    }
    [text release];
}

-(IBAction)deleteData:(id)sender
{
    NSString *text=[[NSString alloc] initWithFormat:@"%@",selectedcell.text];
    
    int testvalue = sqlite3_exec(db, [[NSString stringWithFormat:@"delete from user where name='%@'",text] UTF8String], NULL, NULL, NULL);
    if (testvalue == SQLITE_OK) 
    {
        UIAlertView *alert02 = [[UIAlertView alloc] initWithTitle:@"Delete Data" message:@"Record Deleted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert02 show];
        [alert02 release];
        NSLog(@"Data deleted %@",text);
        [self showList];
    }
    else {
        UIAlertView *alert02 = [[UIAlertView alloc] initWithTitle:@"Delete Data" message:@"Faild to delete Record" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert02 show];
        [alert02 release];
    }
    [text release];
}
-(void)showList
{
    sqlite3_stmt *statement=nil;
    const char *sql="select * from user";
    
    tableData = [[NSMutableArray alloc]init];//initialize array

    
    if(sqlite3_prepare_v2(db, sql, -1, &statement, NULL)!= SQLITE_OK)
    {
        //  NSAssert1(0, @"Error preparing statement", sqlite3_errmsg(db));
        
    }
    else
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            
            [tableData addObject:[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 1)]];
            
        }
    }
    //release the resources
    sqlite3_finalize(statement);
    
    [self.tv reloadData];
    

}
//-----------------------------------------------------------------------------
// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 0;
    return [tableData count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.text=[tableData objectAtIndex:indexPath.row];
    
    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

   selectedcell = [tableView cellForRowAtIndexPath:indexPath];
    
   
}
//----------------------------------------------------------------------------

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
     tableData = [[NSMutableArray alloc]init];//initialize array
    
   name.text=@"";
      
    
     [self openDB];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if(theTextField == name) {
        [name resignFirstResponder];
    }
    return YES;
}
- (void)dealloc
{
    
    [super dealloc];
}
@end
