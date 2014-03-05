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

@property int timerMinutes;
@property int timerSeconds;
@property BOOL timerHasStarted;

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
    
    self.timerSeconds = 0;
    self.timerMinutes = 0;
    self.timerHasStarted = NO;

    //Set title based on speech and student
    self.navigationItem.title = [NSString stringWithFormat:@"Evaluate: %@ - %@ %@",self.currentSpeechName,self.currentStudent.firstName,self.currentStudent.lastName];
    
    //Sets the QuickGrade and PreDefinedComments Tables as non selectable
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity;
    
    NSError* error;
    
    if(self.currentSpeech == nil)
    {
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"StudentSpeech" inManagedObjectContext:self.managedObjectContext]];
         [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"student = %@",self.currentStudent]];
        
        NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        StudentSpeech * studentSpeech = [objects lastObject];
        NSArray * speeches = [NSArray arrayWithArray: [studentSpeech.speechesGiven allObjects]];
        for(int i = 0; i < [speeches count]; i ++)
        {
            Speech * temp = [speeches objectAtIndex:i];
            if(temp.speechType == self.currentSpeechName){
                self.currentSpeech = temp;
            }
        }
    }
    //Retireve modules from coredata if array is null.
    if(self.SpeechModules == nil)
    {
        self.SpeechModules = [NSArray arrayWithArray:[self.currentSpeech.modules allObjects]];
        
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
//        entity = [NSEntityDescription entityForName:@"Module" inManagedObjectContext:self.managedObjectContext];
//        [fetchRequest setEntity:entity];
//        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"moduleName = %@",@"Introduction"]];
//        NSArray * modules = [NSArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        NSArray * modules = [NSArray arrayWithArray:[self.currentSpeech.modules allObjects]];
        self.currentModule = [modules firstObject];
    }
    self.modulePoints.text = [NSString stringWithFormat:@"/ %@",self.currentModule.points];
    
    if(self.QuickGrades == nil)
    {
        NSMutableArray * allQuickGrades = [NSMutableArray arrayWithArray:[self.currentModule.quickGrade allObjects]];
        
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
        NSMutableArray * allPreDefComments = [NSMutableArray arrayWithArray:[self.currentModule.preDefinedComments allObjects]];
        
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
        NSLog(@"about to do stuff");
    //reload tablviews after filling table's content arrays
    [self.PreDefinedCommentsTable reloadData];
    [self.leftQuickGradeTable reloadData];
    [self.rightQuickGradeTable reloadData];
    [self.ModuleTable reloadData];
    
    //set continue button as hidden unless Conclusion module is selected
    self.continueButton.titleLabel.text = @"Continue";
    self.continueButton.backgroundColor = [UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0];
    self.continueButton.hidden = YES;
    NSLog(@"Speech %@",self.currentSpeech.speechType);
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

//creates the cells based on which module is selected.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NSLog(@"about to do stuff");
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
        
        QuickGrade * segmentValue = [self findEntity:@"QuickGrade" withAttribute:@"quickGradeDescription" andValue:cell.textLabel.text];
        NSLog(@"saved score is %@",segmentValue.score);
        if(segmentValue.score == Nil)
        {
            segment.selectedSegmentIndex = (NSInteger)segmentValue.score;
        }
    
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
        
        QuickGrade * segmentValue = [self findEntity:@"QuickGrade" withAttribute:@"quickGradeDescription" andValue:cell.textLabel.text];
        if(segmentValue.score == Nil)
        {
            segment.selectedSegmentIndex = (NSInteger) segmentValue.score;
        }
        
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
        [commentSwitch setOn:false];
        
        PreDefinedComments * switchValue = [self findEntity:@"PreDefinedComments" withAttribute:@"comment" andValue:cell.textLabel.text];
        if(switchValue.isSelected == Nil)
        {
            if(switchValue.isSelected == [NSNumber numberWithBool:true])
            {
                [commentSwitch setSelected:true];
            }else{
                [commentSwitch setSelected:false];
            }
        }
        
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
    [self saveStudentRubricValues];
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
        NSMutableArray * allQuickGrades = [NSMutableArray arrayWithArray:[self.currentModule.quickGrade allObjects]];
        
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
        NSMutableArray * allPreDefComments = [NSMutableArray arrayWithArray:[self.currentModule.preDefinedComments allObjects]];
        
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

//- (IBAction)startTimer:(id)sender
//{
//    if(self.timerHasStarted == NO){
//        [self.startTimer setTitle:@"PAUSE" forState:(UIControlStateNormal)];
//        self.timerHasStarted=YES;
//        [self timer:nil];
//    }
//    if(self.timerHasStarted == YES){
//        self.timerHasStarted = NO;
//        self.startTimer.titleLabel.text = @"PLAY";
//        
//    }
//}
//
//- (IBAction)resetTimer:(id)sender
//{
//    self.timerSeconds = 0;
//    self.timerMinutes = 0;
//    self.timerHasStarted = NO;
//    self.startTimer.titleLabel.text = @"PLAY";
//    [self.timerLabel setText:@"00:00"];
//}
//
//-(void) timer:(id)sender{
//    
//    if(self.timerHasStarted){
//        NSString *sec=[NSString stringWithFormat:@"%i",self.timerSeconds];
//        
//        if(self.timerSeconds<10){
//            sec = [NSString stringWithFormat:@"0%i",self.timerSeconds];
//        }
//        
//        NSString *min = [NSString stringWithFormat:@"%i",self.timerMinutes];
//        if(self.timerMinutes<10){
//            min = [NSString stringWithFormat:@"0%i",self.timerMinutes];
//        }
//        
//        NSString *time=[NSString stringWithFormat:@"%@:%@", min, sec];
//        
//        [self.timerLabel setText:time];
//        NSString * tempDuration = time;
//        if(![tempDuration isEqualToString:@"30:00"])
//        {
//            [self performSelector:@selector(timer:) withObject:nil afterDelay:1.0];
//        }
//        self.timerSeconds+=1;
//        if(self.timerSeconds>59){
//            self.timerSeconds=0;
//            self.timerMinutes+=1;
//        }
//    }
//    else
//    {
//        self.timerSeconds = 0;
//        self.timerMinutes = 0;
//    }
//}



-(void)saveStudentRubricValues
{
    NSLog(@"About to store quick grade");
    UITableViewCell * cell;
    NSIndexPath * indexPath;

    NSError *saveError;
    QuickGrade * quickGrade;
    for(int i = 0; i < [self.leftQuickGrades count]; i ++)
    {
        
        indexPath = [NSIndexPath indexPathForRow: i inSection:0];
        cell = [self.leftQuickGradeTable cellForRowAtIndexPath:indexPath];
        UISegmentedControl * segment = (UISegmentedControl *)cell.accessoryView;
        NSInteger value = [segment selectedSegmentIndex];
        quickGrade = [self findEntity:@"QuickGrade" withAttribute:@"quickGradeDescription" andValue:cell.textLabel.text];
        NSLog(@"%i",value);
        NSLog(@"Setting quickGrade");
        [quickGrade setValue: [NSNumber numberWithInteger:value] forKey:@"score"];
        
        NSLog(@"Value after saving %@",quickGrade.score);
        NSLog(@"Set Value of quick Grade");
        if (![self.managedObjectContext save:&saveError]) {
            NSLog(@"Saving quick grade failed: %@", saveError);
        } else {
            NSLog(@"Quick Grade Saved!!!");
        }
    }
    //save the right tables quick grades
    for(int i = 0; i < [self.rightQuickGrades count]; i ++)
    {
        indexPath = [NSIndexPath indexPathForRow: i inSection:0];
        cell = [self.rightQuickGradeTable cellForRowAtIndexPath:indexPath];
        UISegmentedControl * segment = (UISegmentedControl *)cell.accessoryView;
        NSInteger value = [segment selectedSegmentIndex];
        quickGrade = [self findEntity:@"PreDefinedComments" withAttribute:@"comment" andValue:cell.textLabel.text];
        
        NSLog(@"Setting preDefinedComment");
        [quickGrade setValue: [NSNumber numberWithInteger:value] forKey:@"isSelected"];
        
        
        
        NSLog(@"Set Value of quick Grade");
        if (![self.managedObjectContext save:&saveError]) {
            NSLog(@"Saving preDefinedComment failed: %@", saveError);
        } else {
            NSLog(@"Pre Defined Comment Saved!!!");
        }
    }
//    //save the right tables quick grades
//    for(int i = 0; i < [self.PreDefinedComments count]; i ++)
//    {
//        indexPath = [NSIndexPath indexPathForRow: i inSection:0];
//        cell = [self.PreDefinedCommentsTable cellForRowAtIndexPath:indexPath];
//        UISegmentedControl * segment = (UISegmentedControl *)cell.accessoryView;
//        NSInteger value = [segment selectedSegmentIndex];
//        quickGrade = [self findEntity:@"PreDefinedComments" withAttribute:@"comment" andValue:cell.textLabel.text];
//        
//        NSLog(@"Setting preDefinedComment");
//        [quickGrade setValue: [NSNumber numberWithInteger:value] forKey:@"isSelected"];
//        NSLog(@"Set Value of quick Grade");
//        if (![self.managedObjectContext save:&saveError]) {
//            NSLog(@"Saving preDefinedComment failed: %@", saveError);
//        } else {
//            NSLog(@"Pre Defined Comment Saved!!!");
//        }
//    }
}
- (id)findEntity:(NSString *)entity withAttribute: (NSString *)attribute andValue:(NSString*)value
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%@ == %@ AND module == %@",attribute,value,self.currentModule]];
    
    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    
    return [objects firstObject];
}
@end






















