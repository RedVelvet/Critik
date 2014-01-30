//
//  DetailViewController.m
//  PresentationFeedback
//
//  Created by Gautham on 7/28/13.
//  Copyright (c) 2013 Gautham. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#define NUMBERS @"0123456789"

@interface DetailViewController ()

@end


@implementation DetailViewController
@synthesize quickGrades;

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
    // Initializing..
    
    NSLog(@"Hi \u00B0 ");
   
    NSLog(@"Introduction ViewDidload");
    
    moduleName = [moduleTitles objectAtIndex:0];
    
    UILabel* stuLabel = (UILabel*)[self.view viewWithTag:200];
    [stuLabel setText:stuName];
    
    [super viewDidLoad];
    checked = NO;
    
    [self addObjectsToPage];
    
    sqlite3 *database;
      
    gradeCnt = 0;
    commentCnt = 0;
    
    NSString * grades = @"";
    
    for (int i = 0; i < [quickGrades count]; i++) {
        grades = [grades stringByAppendingFormat:@"%@%@",[quickGrades objectAtIndex:i],@"\n"];
            }
    
    for (int j=0; j<[preCommentsDic1 count]; j++) {
        
        UIButton *button = (UIButton*)[self.view viewWithTag:[[[preCommentsDic1 allKeys] objectAtIndex:j] integerValue]];
        [button setImage:[UIImage imageNamed:@"CheckBoxChecked.jpeg"] forState:UIControlStateNormal];
        [button setSelected:YES];
    }
    
    for (int k=0; k<[quickGradesDic1 count]; k++) {
        
        NSString *index = [[quickGradesDic1 allKeys] objectAtIndex:k];
        NSLog(@"index  : %@",index);
        
        //fething the selected values and prepopulating them

        UIButton *quickButton1 = (UIButton*)[self.view viewWithTag:[index integerValue]*1000];
        UIButton *quickButton2 = (UIButton*)[self.view viewWithTag:[index integerValue]*1000+1];
        UIButton *quickButton3 = (UIButton*)[self.view viewWithTag:[index integerValue]*1000+2];
       
        if([[quickGradesDic1 objectForKey:index] integerValue] == -1){
            
            [quickButton1 setImage:[UIImage imageNamed:@"red_button_disabled.jpg"] forState:UIControlStateNormal];
            [quickButton2 setImage:[UIImage imageNamed:@"ok.jpg"] forState:UIControlStateNormal];
            [quickButton3 setImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
            
        }
        else if([[quickGradesDic1 objectForKey:index] integerValue] == 0){
            
            [quickButton1 setImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
            [quickButton2 setImage:[UIImage imageNamed:@"ok_disabled.jpg"] forState:UIControlStateNormal];
            [quickButton3 setImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
            
        }
        else{
            [quickButton1 setImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
            [quickButton2 setImage:[UIImage imageNamed:@"ok.jpg"] forState:UIControlStateNormal];
            [quickButton3 setImage:[UIImage imageNamed:@"green_button_disabled.jpg"] forState:UIControlStateNormal];
                        
        }
    }
    
    // Retrieving Score and written comments
    
    UITextField *textF = (UITextField*)[self.view viewWithTag:901];
    if([pointsArray count] > 1)
        textF.text = [pointsArray objectAtIndex:textF.tag - 901];
    else
        textF.text = @"";
    
    UITextView *textV = (UITextView*)[self.view viewWithTag:801];
    if([commentsArray count] > 1)
        textV.text = [commentsArray objectAtIndex:textV.tag - 801];
    else
        textV.text = @"";
    
    // Retrieving Max points for grading from database
    
    maxPoints = 0;
    UILabel *pointsLabel = (UILabel*)[self.view viewWithTag:700];
        
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    
    NSString *query = [NSString stringWithFormat:@"SELECT MaxPoints from Modules where ModuleName = '%@' and SpeechType = '%@'",moduleName,speechType];
	
    sqlite3_stmt *statement;
    
	sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        pointsLabel.text = [NSString stringWithFormat:@"/ %d Pts",sqlite3_column_int(statement, 0)];
        maxPoints = sqlite3_column_int(statement, 0);
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);
    
	// Do any additional setup after loading the view.
}

-(void) addObjectsToPage{
    
    sqlite3 *database;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    sqlite3_stmt *statement;
    
    
    UIScrollView *scrollView1 = [[UIScrollView alloc] init];
    [scrollView1 setScrollEnabled:YES];
    [scrollView1 setScrollsToTop:YES];
    [scrollView1 showsVerticalScrollIndicator];
    [scrollView1 setBounces:YES];
    
    // Creating Quick Grade View
    
    int yPos1 = 5, yPos2 = 5;
    
    NSString *quickQuery = [NSString stringWithFormat:@"select QuickGradeID, QuickGradeDescription from QuickGrade where SpeechType = '%@' and ModuleName = '%@' and isActive = 1",speechType,moduleName];    
    
    sqlite3_prepare_v2(database, [quickQuery UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
                
        UILabel *quickLabel;
        UIButton *quickButton1;
        UIButton *quickButton2;
        UIButton *quickButton3;
        
        int tagID = sqlite3_column_int(statement, 0);
        
        if(tagID%2 != 0){
            
            quickLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yPos1, 180, 50)];
            quickButton1 = [[UIButton alloc] initWithFrame:CGRectMake(220, yPos1+10, 30, 30)];
            quickButton2 = [[UIButton alloc] initWithFrame:CGRectMake(255, yPos1+10, 30, 30)];
            quickButton3 = [[UIButton alloc] initWithFrame:CGRectMake(290, yPos1+10, 30, 30)];
            
            yPos1 += 45;
            
        }
        else{
            quickLabel = [[UILabel alloc] initWithFrame:CGRectMake(360, yPos2, 180, 50)];
            quickButton1 = [[UIButton alloc] initWithFrame:CGRectMake(570, yPos2+10, 30, 30)];
            quickButton2 = [[UIButton alloc] initWithFrame:CGRectMake(605, yPos2+10, 30, 30)];
            quickButton3 = [[UIButton alloc] initWithFrame:CGRectMake(640, yPos2+10, 30, 30)];
            
            yPos2 += 45;
        }
        
        [quickLabel setText:[NSString stringWithFormat:@"\u00BA %s",sqlite3_column_text(statement, 1)]];
        [quickLabel setTag:tagID+100];
        [quickLabel setNumberOfLines:2];
        [scrollView1 addSubview:quickLabel];
        
        [quickButton1 setImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
        [quickButton2 setImage:[UIImage imageNamed:@"ok.jpg"] forState:UIControlStateNormal];
        [quickButton3 setImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
        
        
        [quickButton1 addTarget:self action:@selector(checkQuickGrade:) forControlEvents:UIControlEventTouchUpInside];
        [quickButton2 addTarget:self action:@selector(checkQuickGrade:) forControlEvents:UIControlEventTouchUpInside];
        [quickButton3 addTarget:self action:@selector(checkQuickGrade:) forControlEvents:UIControlEventTouchUpInside];
        
        [quickButton1 setTag:tagID*1000];
        [quickButton2 setTag:tagID*1000+1];
        [quickButton3 setTag:tagID*1000+2];
        
        [scrollView1 addSubview:quickButton1];
        [scrollView1 addSubview:quickButton2];
        [scrollView1 addSubview:quickButton3];
        
        gradeCnt++;
        
    }
    
    [scrollView1 setContentSize:CGSizeMake(650.0, gradeCnt*27.0)];
    [scrollView1 setFrame:CGRectMake(15, 100, 680, 150)];
    [self.view addSubview:scrollView1];
    
    // Creating Predefined Comments View
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setScrollEnabled:YES];
    [scrollView setScrollsToTop:YES];
    [scrollView showsVerticalScrollIndicator];
    [scrollView setBounces:YES];
    
    int y1 = 20, y2 = 6;
        
    NSString *query = [NSString stringWithFormat:@"select PredefinedCommentID, PredefinedCommentDescription from PredefinedComment where SpeechType = '%@' and ModuleName = '%@' and isActive = 1",speechType,moduleName];
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(25.5, y1, 31, 31)];
        [button setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkCommentButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:sqlite3_column_int(statement, 0)];
        [scrollView addSubview:button];
        
        y1 += 50;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(65, y2, 565, 47)];
        [label1 setText:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)]];
        [label1 setNumberOfLines:2];
        [label1 setTag:sqlite3_column_int(statement, 0)+10000];
        [scrollView addSubview:label1];
        
        y2 += 50;
        
        commentCnt++;
    }
    
    [scrollView setFrame:CGRectMake(30, 290, 650, 275)];
    [scrollView setContentSize:CGSizeMake(650.0, commentCnt*50.0)];
    [self.view addSubview:scrollView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(35, 612, 450, 100)];
    [textView setBackgroundColor:[UIColor lightGrayColor]];
    [textView performSelector:@selector(setDelegate:) withObject:self];
    [textView setFont:[UIFont fontWithName:@"Times New Roman" size:18.0]];
    [textView setTag:801];
    [self.view addSubview:textView];
    
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);

}

- (void) viewDidDisappear:(BOOL)animated
{
    moduleName = [moduleTitles objectAtIndex:0];
    
    NSLog(@"Introduction DidDisappear");
        
    
    NSString *quickGrdsStr = [[NSString alloc] init];
    NSString *quickGrdName = [[NSString alloc] init];
    NSString *quickGradeVal = @"";
    
    UITextField *pts = (UITextField*)[self.view viewWithTag:901];
    [pointsArray setObject:pts.text atIndexedSubscript:pts.tag - 901];
    
    UITextView *writtenComments = (UITextView*)[self.view viewWithTag:801];
    [commentsArray setObject:writtenComments.text atIndexedSubscript:writtenComments.tag-801];
    

    for (int i=0; i<[quickGradesDic1 count]; i++) {
        UILabel *qGLabel = (UILabel*)[self.view viewWithTag:[[[quickGradesDic1 allKeys] objectAtIndex:i] integerValue]+100];
        quickGrdName = qGLabel.text;
        
        if([[quickGradesDic1 objectForKey:[[quickGradesDic1 allKeys] objectAtIndex:i]] integerValue] == -1)
            quickGradeVal = @"-";
        else if([[quickGradesDic1 objectForKey:[[quickGradesDic1 allKeys] objectAtIndex:i]] integerValue] == 0)
            quickGradeVal = @"Ok";
        else
            quickGradeVal = @"+";
        
        quickGrdsStr = [quickGrdsStr stringByAppendingFormat:@"%@ : %@\n", quickGrdName, quickGradeVal];
        
        [quickGradeStrArray setObject:quickGrdsStr atIndexedSubscript:0];
    }
    
    NSLog(@"hi : %@",quickGradesDic1);
   
}
-(void) viewDidAppear:(BOOL)animated
{
    //[self viewDidLoad];
    
    moduleName = [moduleTitles objectAtIndex:0];
    
    NSLog(@"Introduction viewDidAppear");
    
    if (isBackFromLast) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoLanding" object:self];
        
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkCommentButton:(id)sender {
    
    NSLog(@"clicked tag: %ld", (long)[sender tag]);
    
    UIButton *checkButton = (UIButton*)sender;
    
        checkButton.selected = !checkButton.selected;
        
        if(checkButton.selected)
        {
            [checkButton setImage:[UIImage imageNamed:@"CheckBoxChecked.jpeg"] forState:UIControlStateNormal];
         [preCommentsDic1 setObject:((UILabel*)[self.view viewWithTag:[sender tag]+10000]).text forKey:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
        }
        else
        {
            [checkButton setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
            [preCommentsDic1 removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)[sender tag]]];
        }
    
}

- (IBAction)checkQuickGrade:(id)sender
{
    
    UIButton *quickGradeButton = (UIButton*)sender;
    
    NSLog(@"Tag : %ld",(long)quickGradeButton.tag);
    
    long tag = (long)quickGradeButton.tag;
        
    if(tag%1000 == 0){
        
        [quickGradeButton setImage:[UIImage imageNamed:@"red_button_disabled.jpg"] forState:UIControlStateNormal];
        [(UIButton*)[self.view viewWithTag:tag+1] setImage:[UIImage imageNamed:@"ok.jpg"] forState:UIControlStateNormal];
        [(UIButton*)[self.view viewWithTag:tag+2] setImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
        
        [quickGradesDic1 setObject:@"-1" forKey:[NSString stringWithFormat:@"%ld",(long)quickGradeButton.tag/1000]];
        
    }
    else if (tag%1000 == 1){
        
        [(UIButton*)[self.view viewWithTag:tag-1] setImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
        [quickGradeButton setImage:[UIImage imageNamed:@"ok_disabled.jpg"] forState:UIControlStateNormal];
        [(UIButton*)[self.view viewWithTag:tag+1] setImage:[UIImage imageNamed:@"green_button.png"] forState:UIControlStateNormal];
        
        [quickGradesDic1 setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)quickGradeButton.tag/1000]];
        
    }
    else{
        [(UIButton*)[self.view viewWithTag:tag-2] setImage:[UIImage imageNamed:@"red_button.png"] forState:UIControlStateNormal];
        [(UIButton*)[self.view viewWithTag:tag-1] setImage:[UIImage imageNamed:@"ok.jpg"] forState:UIControlStateNormal];
        [quickGradeButton setImage:[UIImage imageNamed:@"green_button_disabled.jpg"] forState:UIControlStateNormal];
        
        [quickGradesDic1 setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(long)quickGradeButton.tag/1000]];

    }
        
}

#pragma mark Text View delegate methods

-(void)textViewDidBeginEditing:(UITextView*)textView
{
    [textView resignFirstResponder];
    
    if ([textView tag] == 801) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5 ];
        [textView setFrame:CGRectMake(35, 250, 450, 100)];
        [UIView commitAnimations];
    }
}

-(void)textViewDidEndEditing:(UITextView*)textView
{
    [textView resignFirstResponder];

    if ([textView tag] == 801) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [textView setFrame:CGRectMake(35, 612, 450, 100)];
        [UIView commitAnimations];
    }
}

- (BOOL)textViewShouldReturn:(UITextView*)textView
{
    [textView resignFirstResponder];
    return YES;
}

#pragma mark Text Field delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    int tempMaxPoints = [[NSString stringWithFormat:@"%@%@", [textField text], string] integerValue];
    
    if (textField.tag == 901) {
        
        if ([textField.text length] > 2) {
            textField.text = [textField.text substringToIndex:1];
            return NO;
        }
        
        if ([[textField text] integerValue] > maxPoints) {
            textField.text = [textField.text substringToIndex:1];
            return NO;
        }
        
        
        if(tempMaxPoints > maxPoints){
                textField.text = [textField.text substringToIndex:1];
                return NO;
        }
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:NUMBERS];
        
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
}

@end











