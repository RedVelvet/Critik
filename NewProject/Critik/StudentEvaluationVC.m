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
@property int presentationTime;

@end

@implementation StudentEvaluationVC{
    // Keeps track of if the timer is started.
    bool startTimer;
    
    // Gets the exact time when the button is pressed.
    NSTimeInterval time;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    //sets the Introduction module as the first selected module
    self.currentModule = [self.SpeechModules objectAtIndex:0];
    
    //Set the first Modue selected when first opening view
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.ModuleTable selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sets the text of our Label to a default time of 0.
    self.timerLabel.text = @"0:00";
    // We set start to false because we don't want the time to be on until we press the button.
    startTimer = false;
    
    //set AppDelegate and NSManagedObjectContext
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSLog(@" numStudentSpeeches: %d",[self.currentStudent.studentSpeech count]);

    //sets currentSpeech
    self.currentSpeech = self.currentStudentSpeech.speech;
    //Set title based on speech and student
    self.navigationItem.title = @"Hello";
    self.navigationController.title = [NSString stringWithFormat:@"Evaluate: %@ - %@ %@",self.currentSpeech.speechType,self.currentStudent.firstName,self.currentStudent.lastName];
    
    //[self.ModuleTable selectRowAtIndexPath:0 animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    
    //sets speech modules
    self.SpeechModules = [NSMutableArray arrayWithArray:[self.currentSpeech.modules allObjects]];
    //sort speech modules based on order index
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.SpeechModules = [NSMutableArray arrayWithArray:[self.SpeechModules sortedArrayUsingDescriptors:descriptors]];
    
    //Sets first module to the Introduction when opening the evaluation page
    self.currentModule = [self.SpeechModules objectAtIndex:0];
    self.moduleGrade.text = [NSString stringWithFormat:@"%@", self.currentModule.points];
    self.modulePoints.text = [NSString stringWithFormat:@"/ %@",self.currentModule.pointsPossible];
    
    //Initialize Quickgrades
    self.QuickGrades = [[NSMutableArray alloc]init];
    NSMutableArray * allQuickGrades = [[NSMutableArray alloc]init];
    
    [self.QuickGrades removeAllObjects];
    [allQuickGrades removeAllObjects];
    [self.leftQuickGrades removeAllObjects];
    [self.rightQuickGrades removeAllObjects];
    
    allQuickGrades = [NSMutableArray arrayWithArray:[self.currentModule.quickGrade allObjects]];
    //Select only active QuickGrades
    for( int i = 0; i < [allQuickGrades count]; i ++)
    {
        QuickGrade * temp = [allQuickGrades objectAtIndex:i];
        if([temp.isActive boolValue] == true)
        {
            [self.QuickGrades addObject:temp];
        }
    }
    //sorts quick grades based on description
    valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"quickGradeDescription" ascending:YES];
    descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.QuickGrades = [NSMutableArray arrayWithArray:[self.QuickGrades sortedArrayUsingDescriptors:descriptors]];
    //splits quick grades into two columns
    [self splitQuickGradesArray];
    
    //Initialize PreDefinedComments
    self.PreDefComments = [[NSMutableArray alloc]init];
    NSMutableArray * allPreDefComments = [[NSMutableArray alloc]init];
    
    [self.PreDefComments removeAllObjects];
    [allPreDefComments removeAllObjects];
    
    allPreDefComments = [NSMutableArray arrayWithArray:[self.currentModule.preDefinedComments allObjects]];
    //Select only active PreDefinedComments
    for( int i = 0; i < [allPreDefComments count]; i ++)
    {
        PreDefinedComments * temp = [allPreDefComments objectAtIndex:i];
        if([temp.isActive boolValue] == true)
        {
            [self.PreDefComments addObject:temp];
        }
    }
    //reload tablviews after filling table's content arrays
    [self.PreDefinedCommentsTable reloadData];
    [self.leftQuickGradeTable reloadData];
    [self.rightQuickGradeTable reloadData];
    [self.ModuleTable reloadData];
    
    NSLog(@"Speech %@",self.currentSpeech.speechType);
    
    
}
-(void) viewWillDisappear:(BOOL)animated{
    [self.QuickGrades removeAllObjects];
    [self.PreDefComments removeAllObjects];
}

//Splits QuickGrades Arrays in between 2 different columns
-(void) splitQuickGradesArray
{
    NSRange someRange;
    
    someRange.location = 0;
    someRange.length = [self.QuickGrades count] / 2;
    self.rightQuickGrades = [NSMutableArray arrayWithArray:[self.QuickGrades subarrayWithRange:someRange]];
    
    
    someRange.location = someRange.length;
    someRange.length = [self.QuickGrades count] - someRange.length;
    self.leftQuickGrades = [NSMutableArray arrayWithArray:[self.QuickGrades subarrayWithRange:someRange]];
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
    int num;
    
    if(tableView.tag == 0)
    {
        num = 2;
    }else{
        num = 1;
    }
    
    return num;
}

//sets the number of rows in a TableView
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num;
    
    if(tableView.tag == 0)
    {
        if(section == 1)
        {
            num = 1;
        }else{
            num = [self.SpeechModules count];
        }
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

//creates the cells based on which module is selected.
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
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        if(indexPath.section == 1)
        {
            cell.textLabel.text = @"Penalties";
        }else{
            Module * temp = [self.SpeechModules objectAtIndex: indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.moduleName];
        }
    }
    
    //left QuickGrades Table
    if(tableView.tag == 1)
    {
        QuickGrade * temp = [self.leftQuickGrades objectAtIndex:indexPath.row];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"-",@"ok",@"+", nil]];
        segment.tintColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
        segment.tag = 1;
        
        NSLog(@"saved score is %@",temp.score);
        
        [segment setSelectedSegmentIndex:[temp.score integerValue]];
        
        objc_setAssociatedObject(segment, "obj",temp, OBJC_ASSOCIATION_ASSIGN);
        [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];
        cell.accessoryView = segment;
        cell.textLabel.textColor = [UIColor colorWithRed:38.0/355.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Right QuickGrades Table
    if (tableView.tag == 2)
    {
        QuickGrade * temp = [self.rightQuickGrades objectAtIndex:indexPath.row];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"-",@"ok",@"+", nil]];
        segment.tintColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
        segment.tag = 1;
        
        NSLog(@"saved score is %@",temp.score);
        
        [segment setSelectedSegmentIndex:[temp.score integerValue]];
        
        objc_setAssociatedObject(segment, "obj",temp, OBJC_ASSOCIATION_ASSIGN);
        [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];
        cell.accessoryView = segment;
        cell.textLabel.textColor = [UIColor colorWithRed:38.0/355.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //Predefined comments table
    if(tableView.tag == 3)
    {
        PreDefinedComments * temp = [self.PreDefComments objectAtIndex:indexPath.row];
        UISwitch * commentSwitch = [[UISwitch alloc]init];
        commentSwitch.tintColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
        commentSwitch.tag = 3;
        
        [commentSwitch setOn: [temp.isSelected boolValue] animated:NO];
        
        objc_setAssociatedObject(commentSwitch, "obj", temp, OBJC_ASSOCIATION_ASSIGN);
        [commentSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
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
    //Change quickGrades and PreDefinedComments arrays based on which module is selected.
    if(tableView.tag == 0)
    {
        NSLog(@"about to do stuff");
        //[self saveStudentRubricValues];
        if(indexPath.section == 1)
        {
            [self continueToFinalize:nil];
        }else{
            //Saves grade for module before changing modules
            self.currentModule.points = [NSNumber numberWithInt:[self.moduleGrade.text intValue]];
            
            Module * module = [self.SpeechModules objectAtIndex:indexPath.row];
            for(int i = 0; i < [self.currentStudentSpeech.speech.modules count]; i ++){
                Module * temp = [[self.currentStudentSpeech.speech.modules allObjects] objectAtIndex:i];
                if(temp.moduleName == module.moduleName){
                    self.currentModule = temp;
                }
            }
            
            //Search through all QuickGrades and PreDefinedComments in an array to selective active
            NSMutableArray * allQuickGrades = [NSMutableArray arrayWithArray:[self.currentModule.quickGrade allObjects]];
            [self.QuickGrades removeAllObjects];
            for( int i = 0; i < [allQuickGrades count]; i ++)
            {
                QuickGrade * temp = [allQuickGrades objectAtIndex:i];
                bool tempbool = [temp.isActive boolValue];
                if(tempbool == true)
                {
                    [self.QuickGrades addObject:temp];
                }
            }
            
            [self splitQuickGradesArray];
            NSMutableArray * allPreDefComments = [NSMutableArray arrayWithArray:[self.currentModule.preDefinedComments allObjects]];
            [self.PreDefComments removeAllObjects];
            for( int i = 0; i < [allPreDefComments count]; i ++)
            {
                PreDefinedComments * temp = [allPreDefComments objectAtIndex:i];
                bool tempbool = [temp.isActive boolValue];
                if(tempbool == true)
                {
                    [self.PreDefComments addObject:temp];
                }
            }
            self.moduleGrade.text = [NSString stringWithFormat:@"%@",module.points];
            self.modulePoints.text = [NSString stringWithFormat:@"/ %@",module.pointsPossible];
            [self.rightQuickGradeTable reloadData];
            [self.leftQuickGradeTable reloadData];
            [self.PreDefinedCommentsTable reloadData];
        }
    }
}

- (IBAction)continueToFinalize:(id)sender
{
    NSError * error;
    self.currentStudentSpeech.duration = [NSNumber numberWithInt:[self.timerLabel.text intValue]];
//    [self.currentStudentSpeech setValue: [NSNumber numberWithInt:self.presentationTime]  forKey:@"duration"];
    
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"Can't Save duration %@",[error localizedDescription]);
    }
    
    StudentPenaltiesVC * penalties = [self.storyboard instantiateViewControllerWithIdentifier:@"Student Penalties"];
    penalties.currentStudent = self.currentStudent;
    penalties.currentStudentSpeech = self.currentStudentSpeech;
    [self.navigationController pushViewController:penalties animated:YES];
}



-(void)segmentChanged:(id)sender
{
    UISegmentedControl * segment = sender;
    if(segment.tag == 1 || segment.tag == 2)
    {
        NSManagedObject * temp = objc_getAssociatedObject(sender, "obj");
        NSNumber * value = [NSNumber numberWithInteger:[segment selectedSegmentIndex]];
        [temp setValue:value forKey:@"score"];
        
        NSError * error = nil;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"Can't Save Quick Grade %@",[error localizedDescription]);
        }
        NSLog(@"Value for segment is %@",value);
    }
}
-(void)switchChanged:(id)sender
{
    UISwitch * tempSwitch = sender;
    if(tempSwitch.tag == 3)
    {
        NSManagedObject * temp = objc_getAssociatedObject(sender, "obj");
        NSNumber * value  = [NSNumber numberWithBool:[tempSwitch isOn]];
        [temp setValue:value forKey:@"isSelected"];
        
        NSError * error = nil;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"Can't Save Pre Defined Comment %@",[error localizedDescription]);
        }
        NSLog(@"Value for comment is %@",value);
    }
}
#pragma mark - Timer stuff
- (IBAction)startStopTimer:(id)sender {
    
    // If start is false then we need to start update the Label with the new time.
    if (startTimer == false) {
        
        // Since it is false we need to reset it back to true.
        startTimer = true;
        
        // Gets the current time.
        time = [NSDate timeIntervalSinceReferenceDate];
        
        // Changes the title of the button to Stop!
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        self.presentationTime = 0.0;
        // Calls the update method.
        [self update];
        
    }else {
        
        // Since it is false we need to reset it back to false.
        startTimer = false;
        
        // Changes the title of the button back to Start.
        [sender setTitle:@"Start" forState:UIControlStateNormal];
    }
}

-(void)update
{
    // If start is false then we shouldn't be updateing the time se we return out of the method.
    if (startTimer == false) {
        
        return;
        
    }
    // We get the current time and then use that to calculate the elapsed time.
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsedTime = currentTime - time;
    
    // We calculate the minutes.
    int minutes = (int)(elapsedTime / 60.0);
    
    // We calculate the seconds.
    int seconds = (int)(elapsedTime = elapsedTime - (minutes * 60));
    
    // We update our Label with the current time.
    self.timerLabel.text = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
    self.presentationTime += seconds;
    
    // We recursively call update to get the new time.
    [self performSelector:@selector(update) withObject:self afterDelay:0.1];
    
}
@end
