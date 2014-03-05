//
//  StudentEvaluationVC.m
//  Critik
//
//  Created by Dalton Decker on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentEvaluationVC.h"

@interface StudentEvaluationVC ()

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
    [self.ModuleTable selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Evaluate: %@ - %@ %@",self.currentSpeech,self.currentStudent.firstName,self.currentStudent.lastName];
    
    NSLog(@"Loaded Evaluation page");
    
    if(self.currentStudent == nil)
    {
        self.currentStudent = [[Student alloc]init];
    }
    if(self.SpeechSections == nil)
    {
//        NSArray modules =
//        self.SpeechSections = [self.speech]
        self.SpeechSections = [NSArray arrayWithObjects: @"Introduction",@"Organization",@"Reasoning and Evidence",@"Presentation Aid",@"Voice and Language",@"Physical Delivery",@"Conclusion",nil];
    }
    
    [self.ModuleTable reloadData];
    
//    CGRect frame = CGRectMake(352.0, 32.0, 250.0, 27.0);
//    self.moduleTitle.frame = frame;
//    self.moduleTitle.text = [self.SpeechSections objectAtIndex:0];
//    
//    frame = CGRectMake(176.0, 205.0, 352, 12.0);

//    [self.ScrollView setScrollEnabled:YES];
//    [self.ScrollView setScrollsToTop:YES];
    
	// Do any additional setup after loading the view.
    NSLog(@"%@",self.currentStudent.firstName);
    
    //UISegmentedControl *quickGrade = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"-", @"ok", @"+", nil]];
    
    //CGRect frame = [CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)];
    
    //    self.mySegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"-", @"ok",@"+", nil]];
    //    self.mySegmentedControl.frame = CGRectMake(500, 8, 280, 27);
    //    self.mySegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    //    self.mySegmentedControl.selectedSegmentIndex = 1;
    //    self.mySegmentedControl.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    //    self.mySegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    //
    //   [self.view addSubview:quickGrade];
    
    
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
    return 7;
}

//creates the cells with the appropriate information displayed in them. Name, Founding Year, Population, and Area.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    UIView * selectedBackgroundView = [[UIView alloc]init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0]]; // set color here
    cell.selectedBackgroundView = selectedBackgroundView;
    
    cell.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    NSString *cellTitle = [self.SpeechSections objectAtIndex:indexPath.row];
    cell.textLabel.text = cellTitle;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end