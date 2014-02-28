//
//  EditInformativeVC.m
//  Critik
//
//  Created by Dalton Decker on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditInformativeVC.h"

@interface EditInformativeVC ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation EditInformativeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.ScrollView setContentSize:CGSizeMake(320, 808)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuickGrade" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    
    if(self.quickGrades == nil){
        self.quickGrades = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    }
    
    entity = [NSEntityDescription entityForName:@"PreDefinedComments" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    if(self.preDefinedComments == nil){
        self.preDefinedComments = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *CellIdentifier = @"Cell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        DualColumnCell * mycell2 = ((DualColumnCell*)cell);
        if (cell == nil) {
            cell = [[DualColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            [mycell2.column1 addTarget:self action:@selector(column1Selected:) forControlEvents:UIControlEventTouchUpInside];
            [mycell2.column2 addTarget:self action:@selector(column1Selected:) forControlEvents:UIControlEventTouchUpInside];
        }

        // Configure the cell...
    
        QuickGrade * temp = [self.quickGrades objectAtIndex:indexPath.row];

        mycell2.column1_label1.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];;
        mycell2.column1.tag = indexPath.row*2;
//        mycell2.column2_label1.text = ;
//        mycell2.column2.tag = indexPath.row*2 +1;
        return cell;
    
//    if(tableView.tag == 1){
//        static NSString *CellIdentifier = @"Cell";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        DualColumnCell * mycell2 = ((DualColumnCell*)cell);
//        if (cell == nil) {
//            cell = [[DualColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            
//            [mycell2.column1 addTarget:self action:@selector(column1Selected:) forControlEvents:UIControlEventTouchUpInside];
//            [mycell2.column2 addTarget:self action:@selector(column1Selected:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        
//        // Configure the cell...
//        
//        mycell2.column1_label1.text = @"column1_label1";
//        mycell2.column1_label2.text = @"column1_label2";
//        mycell2.column1.tag = indexPath.row*2;
//        mycell2.column2_label1.text = @"column2_label1";
//        mycell2.column2_label2.text = @"column2_label2";
//        mycell2.column2.tag = indexPath.row*2 +1;
//        return cell;
//        
//    }
}

//- (void) column1Selected: (id) sender
//{
//    
//    UIAlertView *alert = [[ UIAlertView alloc]
//                          initWithTitle: @" Alert"
//                          message: [NSString stringWithFormat: @"button %d",((UIButton *) sender).tag]
//                          delegate: nil
//                          cancelButtonTitle: @" OK"
//                          otherButtonTitles: nil];
//    [alert show] ;
//    [alert release];


@end
