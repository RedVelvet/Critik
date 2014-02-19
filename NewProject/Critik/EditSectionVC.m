//
//  EditSectionVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 2/18/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditSectionVC.h"
#import "AddSectionVC.h"

@interface EditSectionVC ()

@end

@implementation EditSectionVC
@synthesize sections;

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
    //Instantiate NSMutableArray
    sections = [[NSMutableArray alloc]initWithObjects:@"Section 1",@"Section 2", @"Section 3", nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return [sections count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //[sectionTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [sections objectAtIndex:indexPath.row];
    
    return cell;
}

// called after 'Save' is tapped on the AddSectionVC
- (IBAction)unwindToTableViewController:(UIStoryboardSegue *)sender
{
    AddSectionVC *addSectionVC = (AddSectionVC *)sender.sourceViewController;
    NSString *sectionName = addSectionVC.sectionTextField.text;
    
    // If NOT blank adn NOT whitespace
    if(![sectionName length] == 0 && ![[sectionName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        
        // Add it to the top of the data source
        [sections insertObject:sectionName atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        //Insert it into the tableview
        [self.sectionTableView beginUpdates];
        [self.sectionTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.sectionTableView endUpdates];
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    stuName = [studentsArray objectAtIndex:indexPath.row];
    //    stuID = [studentIDArray objectAtIndex:indexPath.row];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
