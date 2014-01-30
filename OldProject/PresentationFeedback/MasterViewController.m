//
//  MasterViewController.m
//  PresentationFeedback
//
//  Created by Gautham on 7/28/13.
//  Copyright (c) 2013 Gautham. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewManager.h"
#import "SecondViewController.h"
#import "LandingPageViewController.h"
@interface MasterViewController ()
@property BOOL landingPageSeen;
@end

int second = 0;
int minute = 0;


@implementation MasterViewController
@synthesize SecondViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    isBack = NO;
    isBackFromLast = NO;
    
    [super viewDidLoad];
    
    NSLog(@"In Master View viewdidload");
    
    self.landingPageSeen = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToLanding) name:@"GotoLanding" object:nil];
        
    // Timer variables
    
    timerLabel = [[UILabel alloc] init];
    [timerLabel setText:@"00 : 00"];
    
    
    moduleTitles= [[NSMutableArray alloc] initWithObjects:@"Introduction", @"Organization", @"Reasoning and Evidence",@"Presentational Aid(s)",@"Voice and Language",
                   @"Physical Delivery",@"Conclusion",nil];
    
    preCommentsDic1 = [[NSMutableDictionary alloc] init];
    preCommentsDic2 = [[NSMutableDictionary alloc] init];
    preCommentsDic3 = [[NSMutableDictionary alloc] init];
    preCommentsDic4 = [[NSMutableDictionary alloc] init];
    preCommentsDic5 = [[NSMutableDictionary alloc] init];
    preCommentsDic6 = [[NSMutableDictionary alloc] init];
    preCommentsDic7 = [[NSMutableDictionary alloc] init];
    
    commentsArray = [[NSMutableArray alloc] init];
    pointsArray = [[NSMutableArray alloc] init];
    quickGradeStrArray = [[NSMutableArray alloc] init];
    
    quickGradesDic1 = [[NSMutableDictionary alloc] init];
    quickGradesDic2 = [[NSMutableDictionary alloc] init];
    quickGradesDic3 = [[NSMutableDictionary alloc] init];
    quickGradesDic4 = [[NSMutableDictionary alloc] init];
    quickGradesDic5 = [[NSMutableDictionary alloc] init];
    quickGradesDic6 = [[NSMutableDictionary alloc] init];
    quickGradesDic7 = [[NSMutableDictionary alloc] init];
    
    allPreCommArray = [[NSMutableArray alloc] initWithObjects:preCommentsDic1,preCommentsDic2, preCommentsDic3, preCommentsDic4, preCommentsDic5, preCommentsDic6, preCommentsDic7, nil];
    
    allQuickArray = [[NSMutableArray alloc] initWithObjects:quickGradesDic1, quickGradesDic2, quickGradesDic3, quickGradesDic4, quickGradesDic5, quickGradesDic6, quickGradesDic7, nil];
    
    quickGradeEditDict = [[NSMutableDictionary alloc] init];
    preCommEditDict = [[NSMutableDictionary alloc] init];
    isQuickCheckedDic = [[NSMutableDictionary alloc] init];
    isCommCheckedDic = [[NSMutableDictionary alloc] init];
    deleteQuickArray = [[NSMutableArray alloc] init];
    deletePreCommArray = [[NSMutableArray alloc] init];
    
    sectionDic = [[NSMutableDictionary alloc] init];
    studentsArray = [[NSMutableArray alloc] init];
    studentIDArray = [[NSMutableArray alloc] init];
    completedStudentsArray = [[NSMutableArray alloc] init];
    
    for(int i=0;i<10;i++)
    {
        [commentsArray addObject:@""];
        [pointsArray addObject:@""];
        [quickGradeStrArray addObject:@""];
    }
    
    [self createDataFile];

}


-(void) createDataFile
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",stuName]];
    [[NSData data] writeToFile:appFile options:NSDataWritingAtomic error:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:appFile]) {
        NSLog(@"File Exists");
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
    started = YES;
    timerLabel.text = @"00 : 00";
    tempDuration = @"00 : 00";
    
    for(int i=0;i<10;i++)
    {
        [commentsArray setObject:@"" atIndexedSubscript:i];
        [pointsArray setObject:@"" atIndexedSubscript:i];
        [quickGradeStrArray setObject:@"" atIndexedSubscript:i];
    }
    
    NSLog(@"MasterViewController viewDidAppear");
    
    if(!self.landingPageSeen){
        
        [self goToLanding];
    }
    else{
        [self.tableView reloadData];
        DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
        // Create and configure a new detail view controller appropriate for the selection.
        UIViewController *firstVC;
        
        if ([modeType isEqualToString:@"Evaluate Students"]) {
             firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        }
        else{
             firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Edit_DetailViewController"];
        }
        
        detailViewManager.detailViewController = firstVC;
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"MasterViewController viewDidDisappear");
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
    if ([modeType isEqualToString:@"Edit Forms"])
        return 3;
    else
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 0) {
        return 7;
    }
    else if(section == 1)
    {
        if ([modeType isEqualToString:@"Edit Forms"])
            return 1;
        else
            return 2;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if([indexPath section] == 0)
        cell.textLabel.text= moduleTitles[indexPath.row];
    else if([indexPath section] == 1)
    {
        if ([modeType isEqualToString:@"Edit Forms"])
        {
            cell.textLabel.text = @"Sections";
            
        }
        else if([modeType isEqualToString:@"Evaluate Students"])
        {
            
        if([indexPath row] == 0){

            cell.textLabel.text = @"Timer";
            cell.textLabel.frame = CGRectMake(0, 340, 31, 31);
            
            startButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [startButton setFrame:CGRectMake(120, 10, 30, 30)];
            
            if(!started){
                [startButton setBackgroundImage:[UIImage imageNamed:@"pause.jpg"] forState:UIControlStateNormal];
            }else
                [startButton setBackgroundImage:[UIImage imageNamed:@"start.jpg"] forState:UIControlStateNormal];
            
            [startButton addTarget:self action:@selector(startPausePressed:) forControlEvents:UIControlEventTouchUpInside];
            [startButton setUserInteractionEnabled:YES];
            [startButton setAccessibilityViewIsModal:YES];
            [startButton setEnabled:YES];
            
            
             resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [resetButton setFrame:CGRectMake(200, 10, 30, 30)];
            [resetButton setBackgroundImage:[UIImage imageNamed:@"refresh.jpg"] forState:UIControlStateNormal];
            [resetButton addTarget:self action:@selector(resetPressed:) forControlEvents:UIControlEventTouchUpInside];
            [resetButton setUserInteractionEnabled:YES];
            [resetButton setAccessibilityViewIsModal:YES];
            [resetButton setEnabled:YES];
            
            [cell addSubview:startButton];
            [cell addSubview:resetButton];
            }
        
        else{
            cell.textLabel.text = timerLabel.text;
        }
      }
        else{
            
        }
    }
    else{
        if ([modeType isEqualToString:@"Edit Forms"])
        {
            cell.textLabel.text = @"Home Page";
        }
        else if([modeType isEqualToString:@"Evaluate Students"]){
            cell.textLabel.text = @"Student List";
        }
        
    }
    return cell;
}

#pragma mark - IBAction methods

- (IBAction)startPausePressed:(id)sender
{
    
    if(started){
        [startButton setHighlighted:YES];
        [startButton setBackgroundImage:[UIImage imageNamed:@"pause.jpg"] forState:UIControlStateNormal];
        [startButton setTitle:@"Stop" forState:(UIControlStateNormal)];
        started=NO;
        [self tick:nil];
    }
    else{
        started = YES;
        [startButton setBackgroundImage:[UIImage imageNamed:@"start.jpg"] forState:UIControlStateNormal];
    }
}

- (IBAction)resetPressed:(id)sender
{
    second = 0;
    minute = 0;
    [startButton setBackgroundImage:[UIImage imageNamed:@"start.jpg"] forState:UIControlStateHighlighted];
    if(!started){
        started = YES;
    }
    [startButton setBackgroundImage:[UIImage imageNamed:@"start.jpg"] forState:UIControlStateNormal];
    [timerLabel setText:@"00 : 00"];
    [self.tableView reloadData];
}

-(void) tick:(id)sender{
    NSLog(@"iterate");
    
    if(!started){
        NSString *sec=[NSString stringWithFormat:@"%i",second];
        if(second<10){
            sec = [NSString stringWithFormat:@"0%i",second];
        }
        NSString *min = [NSString stringWithFormat:@"%i",minute];
        if(minute<10){
            min = [NSString stringWithFormat:@"0%i",minute];
        }
        NSString *time=[NSString stringWithFormat:@"%@ : %@", min, sec];
        [timerLabel setText:time];
        tempDuration = time;
        if(![tempDuration isEqualToString:@"30 : 00"])
        {
            [self performSelector:@selector(tick:) withObject:nil afterDelay:1.0];
        }
        second+=1;
        if(second>59){
            second=0;
            minute+=1;
        }
        [self.tableView reloadData];
    }
    else
    {
        second = 0;
        minute = 0;
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([modeType isEqualToString:@"Evaluate Students"]) {
        
    if([indexPath section] == 0)
    {
        // Navigation logic may go here. Create and push another view controller.
        if(indexPath.row==0)
        {
            //load ViewController related to first module
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            // Create and configure a new detail view controller appropriate for the selection.
            UIViewController *firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
//            [self presentViewController:firstVC animated:YES completion:nil];
            detailViewManager.detailViewController = firstVC;
            
        }
        else if(indexPath.row==1)
        {
            // Get a reference to the DetailViewManager.
            // DetailViewManager is the delegate of our split view.
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            // Create and configure a new detail view controller appropriate for the selection.
            UIViewController *secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
            detailViewManager.detailViewController = secondVC;  // setter of the DetailViewManager will be called

        }
        else if(indexPath.row==2)
        {
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            // Create and configure a new detail view controller appropriate for the selection.
            UIViewController *ReasoningVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReasoningViewController"];
            detailViewManager.detailViewController = ReasoningVC;  // setter of the DetailViewManager will be called
            
        }
        else if(indexPath.row == 3)
        {
            
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            // Create and configure a new detail view controller appropriate for the selection.
            UIViewController *PresentationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PresentationalAidViewController"];
            detailViewManager.detailViewController = PresentationVC;  // setter of the DetailViewManager will be called
        }
        //VoiceAndLanguageViewController
        else if(indexPath.row == 4)
        {
            
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            detailViewManager.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VoiceAndLanguageViewController"];  // setter of the DetailViewManager will be called
        }
        //PhysicalDeliveryViewController
        else if(indexPath.row == 5)
        {
            
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            detailViewManager.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PhysicalDeliveryViewController"];
        }
        else if(indexPath.row == 6)
        {
            
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            detailViewManager.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConclusionViewController"];
            
        }
    }
    else if ([indexPath section] == 2)
    {
        UIAlertView *backAlert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Do you want to move to student list?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [backAlert show];
        [backAlert setTag:1];
        
    }


    }
    else
    {
      if([indexPath section] == 0)
       {
        if(indexPath.row==0)
        {
            //load ViewController related to first module
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            // Create and configure a new detail view controller appropriate for the selection.
            UIViewController *firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Edit_DetailViewController"];
            //            [self presentViewController:firstVC animated:YES completion:nil];
            detailViewManager.detailViewController = firstVC;
            
        }
        else if(indexPath.row==1)
        {
            // Get a reference to the DetailViewManager.
            // DetailViewManager is the delegate of our split view.
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            // Create and configure a new detail view controller appropriate for the selection.
            UIViewController *secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Edit_SecondViewController"];
            detailViewManager.detailViewController = secondVC;  // setter of the DetailViewManager will be called
            
        }
        else if(indexPath.row==2)
        {
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            // Create and configure a new detail view controller appropriate for the selection.
            UIViewController *ReasoningVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Edit_ReasoningViewController"];
            detailViewManager.detailViewController = ReasoningVC;  // setter of the DetailViewManager will be called
            
        }
        else if(indexPath.row == 3)
        {
            
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            // Create and configure a new detail view controller appropriate for the selection.
            UIViewController *PresentationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Edit_PresentationalAidViewController"];
            detailViewManager.detailViewController = PresentationVC;  // setter of the DetailViewManager will be called
        }
        //VoiceAndLanguageViewController
        else if(indexPath.row == 4)
        {
            
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            detailViewManager.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Edit_VoiceAndLanguageViewController"];  // setter of the DetailViewManager will be called
        }
        //PhysicalDeliveryViewController
        else if(indexPath.row == 5)
        {
            
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            detailViewManager.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Edit_PhysicalDeliveryViewController"];
        }
        else if(indexPath.row == 6)
        {
            
            DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
            detailViewManager.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Edit_ConclusionViewController"];
            
        }
       }
      else if([indexPath section] == 1)
      {
          DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
          detailViewManager.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SectionViewController"];
      }
    else
        {
            UIAlertView *backAlert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Moving to Home page" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
            [backAlert show];
            [backAlert setTag:2];
        }
    }
    
//
//    else if(indexPath.row == 7)
//    {
//        
//        DetailViewManager *detailViewManager = (DetailViewManager*)self.splitViewController.delegate;
//        detailViewManager.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
//    }

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {

        if (buttonIndex==0) {
        
        }
        else
        {
            isBack = YES;
            [self goToLanding];
        }
    }
    if (alertView.tag == 2) {
        
        if (buttonIndex==0) {
            
        }
        else
        {
            isBack = NO;
            [self goToLanding];
        }
    }

}

-(void) goToLanding
{
    LandingPageViewController * lpvc =  [self.storyboard instantiateViewControllerWithIdentifier:@"LandingPageViewController"];
    self.landingPageSeen = YES;
    [self presentViewController:lpvc animated:NO completion:nil];
}

@end
