//
//  StudentEvaluationVC.m
//  Critik
//
//  Created by Dalton Decker on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentEvaluationVC.h"

@interface StudentEvaluationVC ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation StudentEvaluationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    //sets the Introduction module as the first selected module
    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    self.currentModule = [self.SpeechModules objectAtIndex:indexPath.row];
    [self.ModuleTable selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    //Set title based on speech and student
    self.navigationItem.title = [NSString stringWithFormat:@"Evaluate: %@ - %@ %@",self.currentSpeech,self.currentStudent.firstName,self.currentStudent.lastName];
    
    //Sets the QuickGrade and PreDefinedComments Tables as non selectable
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity;
    
    NSError* error;

    //Retireve modules from coredata if array is null.
    if(self.SpeechModules == nil)
    {
        entity = [NSEntityDescription entityForName:@"Module" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        self.SpeechModules = [NSArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        
        //
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        self.SpeechModules = [NSMutableArray arrayWithArray:[self.SpeechModules sortedArrayUsingDescriptors:descriptors]];
    }
    
    if(self.currentStudent == nil)
    {
        self.currentStudent = [[Student alloc]init];
    }
    if(self.currentModule == nil)
    {
        entity = [NSEntityDescription entityForName:@"Module" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"moduleName = %@",@"Introduction"]];
        NSArray * modules = [NSArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        
        self.currentModule = [modules objectAtIndex:0];
    }
    self.modulePoints.text = [NSString stringWithFormat:@"/ %@",self.currentModule.points];
    
    if(self.QuickGrades == nil)
    {
        NSMutableArray * allQuickGrades = [self.currentModule.quickGrade allObjects];
        
        for( int i = 0; i < [allQuickGrades count]; i ++)
        {
            QuickGrade * temp = [allQuickGrades objectAtIndex:i];
            if(temp.isActive == false)
            {
                [allQuickGrades removeObjectAtIndex:i];
            }
        }
        self.QuickGrades = [NSArray arrayWithArray: allQuickGrades];
        
        [self splitQuickGradesArray];
        
    }
    if(self.PreDefComments == nil)
    {
        NSMutableArray * allPreDefComments = [self.currentModule.preDefinedComments allObjects];
        
        for( int i = 0; i < [allPreDefComments count]; i ++)
        {
            PreDefinedComments * temp = [allPreDefComments objectAtIndex:i];
            if(temp.isActive == false)
            {
                [allPreDefComments removeObjectAtIndex:i];
            }
        }
        self.PreDefComments = [NSArray arrayWithArray: allPreDefComments];
        
    }
    
    //reload tablviews after filling table's content arrays
    [self.PreDefinedCommentsTable reloadData];
    [self.leftQuickGradeTable reloadData];
    [self.rightQuickGradeTable reloadData];
    [self.ModuleTable reloadData];
    
    //set continue button as hidden unless Conclusion module is selected
    self.continueButton.titleLabel.text = @"Continue";
    self.continueButton.backgroundColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
    self.continueButton.hidden = YES;
}

-(void) splitQuickGradesArray
{
    NSRange someRange;
    
    someRange.location = 0;
    someRange.length = [self.QuickGrades count] / 2;
    
    self.rightQuickGrades = [self.QuickGrades subarrayWithRange:someRange];
    
    
    someRange.location = someRange.length;
    someRange.length = [self.QuickGrades count] - someRange.length;
    
    self.leftQuickGrades = [self.QuickGrades subarrayWithRange:someRange];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//sets the number of sections in a TableView
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//sets the number of rows in a TableView
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num;
    
    if(tableView.tag == 0)
    {
        num = [self.SpeechModules count];
    }
    
    if (tableView.tag == 1)
    {
        num = [self.leftQuickGrades count];
    }
    
    if(tableView.tag == 2)
    {
        num = [self.rightQuickGrades count];
    }
    
    if(tableView.tag == 3)
    {
        num = [self.PreDefComments count];
    }
    
    return num;
}

//creates the cells with the appropriate information displayed in them. Name, Founding Year, Population, and Area.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    //Module table
    if(tableView.tag == 0)
    {
        UIView * selectedBackgroundView = [[UIView alloc]init];
        [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0]]; // set color here
        cell.selectedBackgroundView = selectedBackgroundView;
        cell.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        Module * temp = [self.SpeechModules objectAtIndex: indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.moduleName];
        
    }
    
    //left QuickGrades Table
    if(tableView.tag == 1)
    {
//        //First half of QuickGrades is placed in the left table
//        if(([self.QuickGrades count]/2) > indexPath.row)
//        {
            QuickGrade * temp = [self.leftQuickGrades objectAtIndex:indexPath.row];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"-",@"ok",@"+", nil]];
            segment.tintColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];
            cell.accessoryView = segment;
            cell.textLabel.textColor = [UIColor colorWithRed:38.0/355.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
    }
    
    //Right QuickGrades Table
    if (tableView.tag == 2)
    {
//        //Second half of QuickGrades is placed in the right table
//        if(([self.QuickGrades count]/2) <= indexPath.row)
//        {
            QuickGrade * temp = [self.rightQuickGrades objectAtIndex:indexPath.row];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"-",@"ok",@"+", nil]];
            segment.tintColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];
            cell.accessoryView = segment;
            cell.textLabel.textColor = [UIColor colorWithRed:38.0/355.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
    }
    
    //Predefined comments table
    if(tableView.tag == 3)
    {
        PreDefinedComments * temp = [self.PreDefComments objectAtIndex:indexPath.row];
        UISwitch * commentSwitch = [[UISwitch alloc]init];
        commentSwitch.tintColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
        [commentSwitch setOn:false];
        cell.accessoryView = commentSwitch;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.comment];
        cell.textLabel.textColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

//Sets the QuickGrades tables to scroll together
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView == self.leftQuickGradeTable)
    {
        self.rightQuickGradeTable.contentOffset = scrollView.contentOffset;
        
    } else if(scrollView == self.rightQuickGradeTable)
    {
        self.leftQuickGradeTable.contentOffset = scrollView.contentOffset;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity;
    NSError* error;
    
    //Change quickGrades and PreDefinedComments arrays based on which module is selected.
    if(tableView.tag == 0)
    {
        //fetch a module from core data based on title of current selection in moduleTable
        entity = [NSEntityDescription entityForName:@"Module" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        Module * module = [self.SpeechModules objectAtIndex:indexPath.row ];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"moduleName = %@",module.moduleName]];
        
        //Store module fetched as currentModule
        NSArray *temp = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        self.currentModule = [temp objectAtIndex:0];
        
        //Search through all QuickGrades and PreDefinedComments in an array to selective active
        NSMutableArray * allQuickGrades = [self.currentModule.quickGrade allObjects];
        
        for( int i = 0; i < [allQuickGrades count]; i ++)
        {
            QuickGrade * temp = [allQuickGrades objectAtIndex:i];
            if(temp.isActive == false)
            {
                [allQuickGrades removeObjectAtIndex:i];
            }
        }
        self.QuickGrades = [NSArray arrayWithArray: allQuickGrades];
        
        [self splitQuickGradesArray];
        NSMutableArray * allPreDefComments = [self.currentModule.preDefinedComments allObjects];
        
        for( int i = 0; i < [allPreDefComments count]; i ++)
        {
            PreDefinedComments * temp = [allPreDefComments objectAtIndex:i];
            if(temp.isActive == false)
            {
                [allPreDefComments removeObjectAtIndex:i];
            }
        }
        self.PreDefComments = [NSArray arrayWithArray: allPreDefComments];
        
        [self.rightQuickGradeTable reloadData];
        [self.leftQuickGradeTable reloadData];
        [self.PreDefinedCommentsTable reloadData];
        
        if([self.currentModule.moduleName isEqualToString:@"Conclusion"])
        {
            self.continueButton.hidden = NO;
        }else{
            self.continueButton.hidden = YES;
        }
        
    }
}

- (IBAction)continueToFinalize:(id)sender
{
    StudentPenaltiesVC * penalties = [self.storyboard instantiateViewControllerWithIdentifier:@"Student Penalties"];
    [self.navigationController pushViewController:penalties animated:YES];
}
@end