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
@property NSTimer * timer;

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
    
    
    self.presentationTime = [self.currentStudentSpeech.duration intValue];
    [self.timerButton setImage:[UIImage imageNamed:@"play25trans.png"] forState:UIControlStateNormal];
    [self.timerResetButton setImage:[UIImage imageNamed:@"reset25trans.png"] forState:UIControlStateNormal];
    
    int minutes = (self.presentationTime / 60.0);
    // We calculate the seconds.
    int seconds = (self.presentationTime - (minutes * 60));
    // We update our Label with the current time.
    self.timerLabel.text = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
    // We set start to false because we don't want the time to be on until we press the button.
    startTimer = false;
    
    //set AppDelegate and NSManagedObjectContext
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];

    //sets currentSpeech
    self.currentSpeech = self.currentStudentSpeech.speech;
    //Set title based on speech and student
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",self.currentStudent.firstName,self.currentStudent.lastName];
    
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
    self.moduleLabel.text = self.currentModule.moduleName;
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
    
}

-(void) viewWillDisappear:(BOOL)animated{
    NSError * error;
    if(![self.managedObjectContext save:&error])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Warning!" message: @"Presentation could not be saved."delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
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
        
        Module * temp = [self.SpeechModules objectAtIndex: indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.moduleName];
        
    }
    
    //left QuickGrades Table
    if(tableView.tag == 1)
    {
        QuickGrade * temp = [self.leftQuickGrades objectAtIndex:indexPath.row];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"-",@"ok",@"+", nil]];
        segment.tintColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
        segment.tag = 1;
        
        [segment setSelectedSegmentIndex:[temp.score integerValue]];
        
        objc_setAssociatedObject(segment, "obj",temp, OBJC_ASSOCIATION_ASSIGN);
        [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];
        cell.accessoryView = segment;
        cell.textLabel.textColor = [UIColor colorWithRed:38.0/355.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.textLabel.numberOfLines = 0;
        
    }
    
    //Right QuickGrades Table
    if (tableView.tag == 2)
    {
        QuickGrade * temp = [self.rightQuickGrades objectAtIndex:indexPath.row];
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"-",@"ok",@"+", nil]];
        segment.tintColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
        segment.tag = 1;
        
        [segment setSelectedSegmentIndex:[temp.score integerValue]];
        
        objc_setAssociatedObject(segment, "obj",temp, OBJC_ASSOCIATION_ASSIGN);
        [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];
        cell.accessoryView = segment;
        cell.textLabel.textColor = [UIColor colorWithRed:38.0/355.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.textLabel.numberOfLines = 0;
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
        cell.textLabel.textColor = [UIColor colorWithRed:38.0/355.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.textLabel.numberOfLines = 0;
        
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
    
    //This is the string that is going to be compared to the input string
    NSString *testString = [NSString string];
    NSScanner *scanner = [NSScanner scannerWithString:self.moduleGrade.text];
    //This is the character set containing all digits. It is used to filter the input string
    NSCharacterSet *skips = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    
    //This goes through the input string and puts all the
    //characters that are digits into the new string
    [scanner scanCharactersFromSet:skips intoString:&testString];
    //If the string containing all the numbers has the same length as the input...
    if([self.moduleGrade.text length] != [testString length] && ![self.moduleGrade.text intValue] <= [self.modulePoints.text intValue] ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Module Points Error" message: @"Points given must be a number less than or equal to points possible" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }else{
        //save current points
        self.currentModule.points = [NSNumber numberWithInt: [self.moduleGrade.text intValue]];
    //Change quickGrades and PreDefinedComments arrays based on which module is selected.
    Module * module = [self.SpeechModules objectAtIndex:indexPath.row];
        if(tableView.tag == 0)
        {
            
            if([module.moduleName isEqualToString:@"Penalties"])
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
                self.moduleLabel.text = self.currentModule.moduleName;
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
}

//Continue to view were penalties for presentation are applied and additional comments
- (IBAction)continueToFinalize:(id)sender
{
    
    self.currentStudentSpeech.duration = [NSNumber numberWithInt:self.presentationTime];
    StudentPenaltiesVC * penalties = [self.storyboard instantiateViewControllerWithIdentifier:@"Student Penalties"];
    penalties.currentStudent = self.currentStudent;
    penalties.currentStudentSpeech = self.currentStudentSpeech;
    [self.navigationController pushViewController:penalties animated:YES];
}

//If segment changes by user input. Then save the change to core data.
-(void)segmentChanged:(id)sender
{
    //new segment corresponding to tableviewcell.
    UISegmentedControl * segment = sender;
    //if cell is a quick grade
    if(segment.tag == 1 || segment.tag == 2)
    {
        //retrieve nsobject related to segmented control
        NSManagedObject * temp = objc_getAssociatedObject(sender, "obj");
        //store the value from the user's input
        NSNumber * value = [NSNumber numberWithInteger:[segment selectedSegmentIndex]];
        //save to core data
        [temp setValue:value forKey:@"score"];
        
        NSError * error = nil;
        if(![self.managedObjectContext save:&error])
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Warning!" message: @"Presentation could not be saved."delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}
//if user changes position of switch for predefined comments.
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
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Warning!" message: @"Presentation could not be saved."delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}
#pragma mark - Timer stuff
//Start and stop timer, displaying related images
- (IBAction)startStopTimer:(id)sender {
    
    // If start is false then we need to start update the Label with the new time.
    if (startTimer == false) {
      
        
        // Changes the title of the button to Stop!
        [sender setImage:[UIImage imageNamed:@"pause25trans.png"] forState:UIControlStateNormal];
        // Calls the update method.
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
        startTimer = true;
        
    }else {
        
        // Since it is false we need to reset it back to false.
        [self.timer invalidate];
        self.timer = nil;
        startTimer = false;
        
        // Changes the title of the button back to Start.
        [sender setImage:[UIImage imageNamed:@"play25trans.png"] forState:UIControlStateNormal];
        
        
    }
}
//reset timer to zero
- (IBAction)resetTimer:(id)sender{
    self.presentationTime = 0;
    self.timerLabel.text = @"0:00";
}
//iterate timer function
- (void)update
{
    // If start is false then we shouldn't be updateing the time se we return out of the method.
    if (startTimer == true) {
        
        // We get the current time and then use that to calculate the elapsed time.
        self.presentationTime++;
        // We calculate the minutes.
        int minutes = (self.presentationTime / 60.0);
        
        // We calculate the seconds.
        int seconds = (self.presentationTime - (minutes * 60));
        
        // We update our Label with the current time.
        self.timerLabel.text = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
        
        
//        // We recursively call update to get the new time.
//        [self performSelector:@selector(update) withObject:self afterDelay:0.1];
    }
}
@end
