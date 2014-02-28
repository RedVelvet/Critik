//
//  EditPersuasiveVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditPersuasiveVC.h"
#define moduleTableTag 1
#define leftTableTag 2
#define rightTableTag 3

@interface EditPersuasiveVC ()

@end

@implementation EditPersuasiveVC
@synthesize managedObjectContext, modules, quickGrades, preDefinedComments;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Core Data Stuff
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Module" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(moduleName like %@)", @"Persuasive"];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    NSLog(@"Count %d", count);
    modules = [[NSMutableArray alloc]init];
    modules = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
//    quickGrades = [NSMutableArray arrayWithObjects:@"quick grade 0", @"quick grade 1", @"quick grade 2", @"quick grade 3", @"quick grade 4",@"quick grade 5",@"quick grade 6",@"quick grade 7", @"quick grade 8",nil];
    quickGrades = [NSMutableArray arrayWithObjects:@"quick grade 0", @"quick grade 1", @"quick grade 2", @"quick grade 3", @"quick grade 4",@"quick grade 5",@"quick grade 6",@"quick grade 7",nil];
//    quickGrades = [NSMutableArray arrayWithObjects:@"quick grade 0", @"quick grade 1",nil];
//    quickGrades = [NSMutableArray arrayWithObjects:@"quick grade 0", nil];
    
    // persuasive speech hasn't been added yet DEBUG CODE
    if(count == 0)
    {
        Speech *newSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"Speech" inManagedObjectContext:managedObjectContext];
        newSpeech.speechType = @"Persuasive";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Magic to make the two uitableviews scroll as one
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    beingScrolled_ = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(beingScrolled_ == nil && scrollView.tag != moduleTableTag)
        beingScrolled_ = scrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *otherScrollView = (scrollView == self.quickTable1) ? self.quickTable2 : self.quickTable1;
    if(otherScrollView != beingScrolled_ && scrollView.tag != moduleTableTag)
    {
        [otherScrollView setContentOffset:[scrollView contentOffset] animated:NO];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rows;
    if (tableView.tag == moduleTableTag)//module tableview
    {
        rows = 3;
    }
    else
    {
        // If the array has an odd length then integer division will result in 1 to few rows for the right table (quickTable2)
        if ([quickGrades count] % 2 != 0)
            rows = [quickGrades count]/2 + 1;
        else
            rows = [quickGrades count]/2;
    }
    
    NSLog(@"Tag: %d Rows: %d", tableView.tag, rows);
    return rows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (tableView.tag == moduleTableTag) {
        [self.moduleTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"Modules";
    }
    else if (tableView.tag == leftTableTag ) {
        // If the array has an odd length that means that the tables will not be the same size. In that case the
        // left table will use half of the array length minus 1. The exception to this rule is when there is
        // only one element in the array, in that case we will only use the left table.
        if ([quickGrades count] % 2 != 0 && [quickGrades count] != 1) {
            
            if (indexPath.row < [quickGrades count]/2) { // array is odd so use up to n-1 rows
                [self.quickTable1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                cell.textLabel.text = [quickGrades objectAtIndex:indexPath.row];

            }
        }
        else // the array is even or there is only one element in the array so we're clear to use all rows
        {
            [self.quickTable1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.textLabel.text = [quickGrades objectAtIndex:indexPath.row];

        }
        
    }
    else if (tableView.tag == rightTableTag)
    {
        if([quickGrades count] == 1) // when the array only has one object only dequeue a cell
        {
            [self.quickTable2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
        }
        else
        {
            [self.quickTable2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.textLabel.text = [quickGrades objectAtIndex:[quickGrades count]/2 + indexPath.row];
        }
        
        
    }
    
    return cell;
        
}
    

@end
