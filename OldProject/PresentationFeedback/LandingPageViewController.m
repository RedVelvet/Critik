//
//  LandingPageViewController.m
//  PresentationFeedback
//
//  Created by Gautham raaz on 10/27/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import "LandingPageViewController.h"

@interface LandingPageViewController ()

@end

@implementation LandingPageViewController
@synthesize sectionPicker, studentTableView,toolBar,restClient,editLabel,speechTypeLabel;

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
    
    sectionArray = [[NSMutableArray alloc] init];
    section = @"";
    
    UIView *pickerView = (UIPickerView*)[self.view viewWithTag:1000];
    [pickerView setHidden:YES];
    [studentTableView setHidden:YES];
    [toolBar setHidden:YES];
    
    SectionViewController *secVC = [[SectionViewController alloc] init];
    [secVC getSections];
    section = [sectionDic objectForKey:[[[sectionDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:0]];
    
    if (isBack) {
        
        UILabel *titleLabel = (UILabel*)[self.view viewWithTag:100];
        [titleLabel setText:@"Section"];
        [titleLabel setFont:[UIFont fontWithName:@"Noteworthy" size:50]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UIButton *speechTypeButton1 = (UIButton*)[self.view viewWithTag:101];
        [speechTypeButton1 setHidden:YES];
        UIButton *speechTypeButton2 = (UIButton*)[self.view viewWithTag:102];
        [speechTypeButton2 setHidden:YES];
        
        
        [pickerView setHidden:NO];
        [toolBar setHidden:NO];
        
        if([modeType isEqualToString:@"Evaluate Students"])
        {
            [studentTableView setHidden:NO];
            [pickerView setFrame:CGRectMake(181, 273, 335, 260)];
        }
        else{
            [pickerView setFrame:CGRectMake(344, 255, 335, 260)];
        }
    }
    
	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated{
    
    if(!isBack){
        editLabel.text = @"";
        speechTypeLabel.text = @"";
    }
    else{
        editLabel.text = modeType;
        speechTypeLabel.text = speechType;
    }
    
    [self getCompletedStudentList];
    NSLog(@"Landingpage viewDidAppear");
    
    isBackFromLast = NO;
    
    [studentTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction methods

- (IBAction)backButtonPressed:(id)sender {

    UILabel *titleLabel = (UILabel*)[self.view viewWithTag:100];
    UIView *pickerView = (UIPickerView*)[self.view viewWithTag:1000];
    [pickerView setHidden:YES];
    [studentTableView setHidden:YES];
    
    if ([[titleLabel text] isEqualToString:@"Section"]) {
        
        [titleLabel setText:@"Speech Type"];
        [titleLabel setFont:[UIFont fontWithName:@"Noteworthy" size:50.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UIButton *speechTypeButton1 = (UIButton*)[self.view viewWithTag:101];
        [speechTypeButton1 setHidden:NO];
        [speechTypeButton1 setTitle:@"Informative" forState:UIControlStateNormal];
        UIButton *speechTypeButton2 = (UIButton*)[self.view viewWithTag:102];
        [speechTypeButton2 setHidden:NO];
        [speechTypeButton2 setTitle:@"Persuasive" forState:UIControlStateNormal];
        
        speechTypeLabel.text = @"";
        
    }
    else if ([[titleLabel text] isEqualToString:@"Speech Type"])
    {

        [titleLabel setText:@"Presentation Feedback"];
        [titleLabel setFont:[UIFont fontWithName:@"Noteworthy" size:50.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UIButton *editButton = (UIButton*)[self.view viewWithTag:101];
        [editButton setTitle:@"Edit Forms" forState:UIControlStateNormal];
        UIButton *evaluateButton = (UIButton*)[self.view viewWithTag:102];
        [evaluateButton setTitle:@"Evaluate Students" forState:UIControlStateNormal];
        
        [toolBar setHidden:YES];
        editLabel.text = @"";
    }
    else
    {
        
    }
    
}

- (IBAction)editButtonPressed:(id)sender {
    
    UIButton *button = (UIButton*)sender;

    if([button.titleLabel.text isEqualToString:@"Edit Forms"] || [button.titleLabel.text isEqualToString:@"Evaluate Students"])
    {
        modeType = button.titleLabel.text;
        editLabel.text = modeType;
    }
    if([button.titleLabel.text isEqualToString:@"Informative"] || [button.titleLabel.text isEqualToString:@"Persuasive"])
    {
        speechType = button.titleLabel.text;
        speechTypeLabel.text = speechType;
    }
        
    UILabel *titleLabel = (UILabel*)[self.view viewWithTag:100];
    UIView *pickerView = (UIPickerView*)[self.view viewWithTag:1000];
    
    
    if ([[titleLabel text] isEqualToString:@"Presentation Feedback"]) {
        
        [titleLabel setText:@"Speech Type"];
        [titleLabel setFont:[UIFont fontWithName:@"Noteworthy" size:50]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UIButton *editButton = (UIButton*)[self.view viewWithTag:101];
        [editButton setTitle:@"Informative" forState:UIControlStateNormal];
        UIButton *evaluateButton = (UIButton*)[self.view viewWithTag:102];
        [evaluateButton setTitle:@"Persuasive" forState:UIControlStateNormal];
        
        [toolBar setHidden:NO];
    }
    else if ([[titleLabel text] isEqualToString:@"Speech Type"])
    {
        
        [titleLabel setText:@"Section"];
        [titleLabel setFont:[UIFont fontWithName:@"Noteworthy" size:50]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];

        UIButton *speechTypeButton1 = (UIButton*)[self.view viewWithTag:101];
        [speechTypeButton1 setHidden:YES];
        UIButton *speechTypeButton2 = (UIButton*)[self.view viewWithTag:102];
        [speechTypeButton2 setHidden:YES];
        
                
        if([modeType isEqualToString:@"Evaluate Students"])
        {
            [pickerView setHidden:NO];
            [studentTableView setHidden:NO];
            [pickerView setFrame:CGRectMake(181, 273, 335, 260)];
        }
        else{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
    else
    {
       
    }
}

- (IBAction)donePressed:(id)sender {
    
    if([modeType isEqualToString:@"Evaluate Students"])
    {
        [self getstudentList];
        [self getCompletedStudentList];
        [studentTableView reloadData];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)getstudentList
{
    [studentsArray setArray:nil];
    [studentIDArray setArray:nil];
    
    sqlite3 *database;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    sqlite3_stmt *statement;
    
    NSString *stuQuery = [NSString stringWithFormat:@"select StuLastName||' '||StuFirstName,StuID from Student where Section = '%@'",section];
    
	sqlite3_prepare_v2(database, [stuQuery UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        [studentsArray addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)]];
        [studentIDArray addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)]];
    
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);
    
}

-(void)getCompletedStudentList
{
    [completedStudentsArray setArray:nil];
    
    sqlite3 *database;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    sqlite3_stmt *statement;
    
    NSString *stuQuery = [NSString stringWithFormat:@"SELECT StuID FROM StudentSpeech where SpeechType='%@'",speechType];
    
	sqlite3_prepare_v2(database, [stuQuery UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        [completedStudentsArray addObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)]];
        
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);
    
}


#pragma mark - Picker View data source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [sectionDic count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [sectionDic objectForKey:[[[sectionDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:row]];
    
}

#pragma mark - Picker View delegate methods

-(void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    section = [sectionDic objectForKey:[[[sectionDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:row]];
    
    NSLog(@"Row : %d  Component : %d", row, component);
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
    
        return [studentsArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    [studentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if([completedStudentsArray containsObject:[studentIDArray objectAtIndex:indexPath.row]]){
        cell.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:100.0/255.0 blue:30.0/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = [studentsArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    stuName = [studentsArray objectAtIndex:indexPath.row];
    stuID = [studentIDArray objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
