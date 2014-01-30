//
//  Edit_ConclusionViewController.m
//  Presentation Feedback
//
//  Created by Gautham raaz on 11/28/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import "Edit_ConclusionViewController.h"

@interface Edit_ConclusionViewController ()

@end

@implementation Edit_ConclusionViewController
@synthesize addQuickView, addPreCommentView;

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
    moduleName = [moduleTitles objectAtIndex:6];
    
    [super viewDidLoad];
    [addQuickView setHidden:YES];
    [addPreCommentView setHidden:YES];
    NSLog(@"Edit_Introduction viewDidLoad");
    
}


- (void) viewDidDisappear:(BOOL)animated
{
    moduleName = [moduleTitles objectAtIndex:6];
    [self insertIntoDB];
    NSLog(@"Edit_Introduction DidDisappear");
    
}

-(void) viewDidAppear:(BOOL)animated
{
    moduleName = [moduleTitles objectAtIndex:6];
    
    NSLog(@"Edit_Introduction Didappear");
    
    [quickGradeEditDict setDictionary:nil];
    [preCommEditDict setDictionary:nil];
    [isQuickCheckedDic setDictionary:nil];
    [isCommCheckedDic setDictionary:nil];
    [deleteQuickArray setArray:nil];
    [deletePreCommArray setArray:nil];
    
    [self getObjectsDataFromDB];
    [self setMaxPointsFromDB];
    [self addObjectsToPage];
    
    [addQuickView setHidden:YES];
    [addPreCommentView setHidden:YES];
}

#pragma mark - IBAction Methods

- (IBAction)checkButtonClicked:(id)sender {
    
    BOOL isChecked;
    
    NSLog(@"clicked tag: %ld", (long)[sender tag]);
    
    UIButton *checkButton = (UIButton*)sender;
    
    
    if ([checkButton tag] % 100 == 0) {
        
        checkButton.selected = !checkButton.selected;
        
        if(checkButton.selected)
        {
            [checkButton setImage:[UIImage imageNamed:@"CheckBoxChecked.jpeg"] forState:UIControlStateNormal];
            if ([checkButton tag]/100000 > 0) {
                [deleteQuickArray addObject:[NSString stringWithFormat:@"%d",[checkButton tag]/100000]];
            }
            else {
                [deletePreCommArray addObject:[NSString stringWithFormat:@"%d",[checkButton tag]/100]];
            }
        }
        else
        {
            [checkButton setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
            if ([checkButton tag]/100000 > 0) {
                [deleteQuickArray removeObject:[NSString stringWithFormat:@"%d",[checkButton tag]/100000]];
            }
            else {
                [deletePreCommArray removeObject:[NSString stringWithFormat:@"%d",[checkButton tag]/100]];
            }
        }
    }
    else
    {
        if([checkButton tag] % 100 == 1)
            isChecked = NO;
        else
            isChecked = YES;
        
        if(!isChecked)
        {
            [checkButton setImage:[UIImage imageNamed:@"CheckBoxChecked.jpeg"] forState:UIControlStateNormal];
            [checkButton setTag:[checkButton tag]+1];
            
            if ([checkButton tag]/100000 > 0) {
                [isQuickCheckedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",[checkButton tag]/100000]];
            }
            else {
                [isCommCheckedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",[checkButton tag]/100]];
            }
            
        }
        else
        {
            [checkButton setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
            [checkButton setTag:[checkButton tag]-1];
            if ([checkButton tag]/100000 > 0) {
                [isQuickCheckedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",[checkButton tag]/100000]];
            }
            else {
                [isCommCheckedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",[checkButton tag]/100]];
            }
        }
    }
}


- (IBAction)addButtonPressed:(id)sender
{
    
    if([sender tag] == 200)
    {
        [addQuickView setFrame:CGRectMake(275, 325, 30, 270)];
        [self.view addSubview:addQuickView];
        [addQuickView setHidden:NO];
        [(UITextView*)[addQuickView viewWithTag:400] setText:@""];
    }
    else
    {
        [addPreCommentView setFrame:CGRectMake(275, 325, 350, 270)];
        [self.view addSubview:addPreCommentView];
        [addPreCommentView setHidden:NO];
        [(UITextView*)[addPreCommentView viewWithTag:500] setText:@""];
    }
    
    NSLog(@"quickGradeDict : %@",quickGradeEditDict);
    NSLog(@"isQuickCheckedDic : %@", isQuickCheckedDic);
    NSLog(@"preCommDict : %@", preCommEditDict);
    NSLog(@"isCommCheckedDic : %@", isCommCheckedDic);
}

- (IBAction)deleteButtonPressed:(id)sender
{
    NSLog(@"deleteQuickArray : %@, deletePreCommArray : %@", deleteQuickArray, deletePreCommArray);
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    sqlite3 *database;
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    
    if ([sender tag] == 300) {
        
        for (int i=0; i<[deleteQuickArray count]; i++) {
            
            NSString *deleteQuery = [[NSString alloc] initWithFormat:@"delete from QuickGrade where QuickGradeID ='%@'",[deleteQuickArray objectAtIndex:i]];
            sqlite3_exec(database, [deleteQuery  UTF8String],NULL, NULL, NULL);
        }
        
        [quickGradeEditDict removeObjectsForKeys:deleteQuickArray];
        [isQuickCheckedDic removeObjectsForKeys:deleteQuickArray];
        [deleteQuickArray setArray:nil];
    }
    else {
        
        for (int i=0; i<[deletePreCommArray count]; i++) {
            
            NSString *deleteQuery = [[NSString alloc] initWithFormat:@"delete from PredefinedComment where PredefinedCommentID ='%@'",[deletePreCommArray objectAtIndex:i]];
            sqlite3_exec(database, [deleteQuery  UTF8String],NULL, NULL, NULL);
        }
        
        [preCommEditDict removeObjectsForKeys:deletePreCommArray];
        [isCommCheckedDic removeObjectsForKeys:deletePreCommArray];
        [deletePreCommArray setArray:nil];
    }
    
    sqlite3_close(database);
    
    [(UIScrollView*)[self.view viewWithTag:1] removeFromSuperview];
    [(UIScrollView*)[self.view viewWithTag:2] removeFromSuperview];
    [self addObjectsToPage];
    
}

- (IBAction)doneButtonPressed:(id)sender;
{
    [self getQuickGradeCount];
    [self getPreCommCount];
    
    if([sender tag] == 403){
        
        [addQuickView setHidden:YES];
        NSString *description = [(UITextView*)[addQuickView viewWithTag:[sender tag]-3] text];
        
        if (![description isEqualToString:@""]) {
            [quickGradeEditDict setObject:description forKey:[NSString stringWithFormat:@"%d",++totalQuickGrdCount]];
            [isQuickCheckedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",totalQuickGrdCount]];
            [self addQuickGrade:description];
        }
    }
    else{
        
        [addPreCommentView setHidden:YES];
        NSString *commDesc = [(UITextView*)[addPreCommentView viewWithTag:[sender tag]-3] text];
        
        if (![commDesc isEqualToString:@""]) {
            [preCommEditDict setObject:commDesc forKey:[NSString stringWithFormat:@"%d",++totalPreCommCount]];
            [isCommCheckedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",totalPreCommCount]];
            [self addPreComments:commDesc];
        }
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if([sender tag] == 402)
        [addQuickView setHidden:YES];
    else
        [addPreCommentView setHidden:YES];
}

#pragma mark - Utility methods

-(void) getQuickGradeCount
{
    sqlite3 *database;
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    
    NSString *query = @"select QuickGradeID from QuickGrade";
	
    sqlite3_stmt *statement;
    
	sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        totalQuickGrdCount = sqlite3_column_int(statement, 0);
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);
}

-(void) getPreCommCount
{
    sqlite3 *database;
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    
    NSString *query = @"select PredefinedCommentID from PredefinedComment";
	
    sqlite3_stmt *statement;
    
	sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        totalPreCommCount = sqlite3_column_int(statement, 0);
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);
}

-(void) setMaxPointsFromDB
{
    sqlite3 *database;
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UITextField *pointsTextField = (UITextField*)[self.view viewWithTag:901];
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    
    NSString *query = [NSString stringWithFormat:@"SELECT MaxPoints from Modules where ModuleName = '%@' and SpeechType = '%@'",moduleName,speechType];
	
    sqlite3_stmt *statement;
    
	sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        pointsTextField.text = [NSString stringWithFormat:@"%d",sqlite3_column_int(statement, 0)];
        
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);
}

-(void) getObjectsDataFromDB
{
    sqlite3 *database;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    sqlite3_stmt *statement;
    
    int tagID = 0;
    
    NSString *quickQuery = [NSString stringWithFormat:@"select QuickGradeID, QuickGradeDescription,isActive from QuickGrade where SpeechType = '%@' and ModuleName = '%@'",speechType,moduleName];
    
    sqlite3_prepare_v2(database, [quickQuery UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        tagID = sqlite3_column_int(statement, 0);
        
        [quickGradeEditDict setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)] forKey:[NSString stringWithFormat:@"%d",tagID]];
        
        if(sqlite3_column_int(statement, 2) == 0){
            [isQuickCheckedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)]];
        }
        else{
            [isQuickCheckedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)]];
        }
        
    }
    
    NSString *query = [NSString stringWithFormat:@"select PredefinedCommentID, PredefinedCommentDescription, isActive from PredefinedComment where SpeechType = '%@' and ModuleName = '%@'",speechType,moduleName];
    
    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        tagID = sqlite3_column_int(statement, 0);
        
        if(sqlite3_column_int(statement, 2) == 0){
            [isCommCheckedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)]];
        }
        else{
            [isCommCheckedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)]];
        }
        
        [preCommEditDict setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 1)] forKey:[NSString stringWithFormat:@"%d",tagID]];
        
    }
    
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);
    
    NSLog(@"quickGradeDict : %@, preCommDict : %@",quickGradeEditDict, preCommEditDict);
    NSLog(@"isQuickCheckedDic : %@, isCommCheckedDic : %@",isQuickCheckedDic, isCommCheckedDic);
}

-(void) addObjectsToPage{
    
    
    UIScrollView *scrollView1 = [[UIScrollView alloc] init];
    [scrollView1 setScrollEnabled:YES];
    [scrollView1 setScrollsToTop:YES];
    [scrollView1 showsVerticalScrollIndicator];
    [scrollView1 setTag:1];
    [scrollView1 setBounces:YES];
    [scrollView1 setBackgroundColor:[UIColor whiteColor]];
    
    yPos1 = 5;
    yPos2 = 5;
    NSString *tagID = @"";
    
    for (int i=0; i<[quickGradeEditDict count]; i++) {
        
        UITextView *quickTextView;
        UIButton *quickButton1;
        UIButton *quickButton2;
        
        tagID = [[[quickGradeEditDict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i];
        
        if(i % 2 == 0){
            
            quickTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, yPos1, 180, 50)];
            quickButton1 = [[UIButton alloc] initWithFrame:CGRectMake(220, yPos1+10, 31, 31)];
            quickButton2 = [[UIButton alloc] initWithFrame:CGRectMake(280, yPos1+10, 31, 31)];
            
            yPos1 += 45;
        }
        else{
            quickTextView = [[UITextView alloc] initWithFrame:CGRectMake(360, yPos2, 180, 50)];
            quickButton1 = [[UIButton alloc] initWithFrame:CGRectMake(570, yPos2+10, 31, 31)];
            quickButton2 = [[UIButton alloc] initWithFrame:CGRectMake(630, yPos2+10, 31, 31)];
            
            yPos2 += 45;
        }
        
        [quickTextView setText:[NSString stringWithFormat:@"%@",[quickGradeEditDict objectForKey:tagID]]];
        [quickTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [quickTextView setTag:1000 + [tagID integerValue]];
        [quickTextView performSelector:@selector(setDelegate:) withObject:self];
        
        [scrollView1 addSubview:quickTextView];
        
        [quickButton1 setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
        [quickButton1 setTag:[tagID integerValue]*100000];
        
        
        if([[isQuickCheckedDic objectForKey:tagID] integerValue] == 0){
            [quickButton2 setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
            [quickButton2 setTag:[tagID integerValue]*100000 + 1];
        }
        else{
            [quickButton2 setImage:[UIImage imageNamed:@"CheckBoxChecked.jpeg"] forState:UIControlStateNormal];
            [quickButton2 setTag:[tagID integerValue]*100000 + 2];
        }
        
        
        [quickButton1 addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [quickButton2 addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView1 addSubview:quickButton1];
        [scrollView1 addSubview:quickButton2];
        
    }
    
    [scrollView1 setContentSize:CGSizeMake(620.0, [quickGradeEditDict count]*27.0)];
    [scrollView1 setFrame:CGRectMake(15, 145, 680, 180)];
    [self.view addSubview:scrollView1];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setScrollEnabled:YES];
    [scrollView setScrollsToTop:YES];
    [scrollView showsVerticalScrollIndicator];
    [scrollView setTag:2];
    [scrollView setBounces:YES];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    
    y1 = 20, y2 = 6;
    
    for (int i=0; i<[preCommEditDict count]; i++) {
        
        
        UIButton *commentButton1 = [[UIButton alloc] initWithFrame:CGRectMake(15, y1, 31, 31)];
        UIButton *commentButton2 = [[UIButton alloc] initWithFrame:CGRectMake(80, y1, 31, 31)];
        
        [commentButton1 setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
        
        tagID = [[[preCommEditDict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i];
        
        [commentButton1 setTag:[tagID integerValue]*100];
        
        if([[isCommCheckedDic objectForKey:tagID] integerValue] == 0){
            [commentButton2 setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
            [commentButton2 setTag:[tagID integerValue]*100 + 1];
        }
        else{
            [commentButton2 setImage:[UIImage imageNamed:@"CheckBoxChecked.jpeg"] forState:UIControlStateNormal];
            [commentButton2 setTag:[tagID integerValue]*100 + 2];
        }
        
        [commentButton1 addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [commentButton2 addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrollView addSubview:commentButton1];
        [scrollView addSubview:commentButton2];
        
        y1 += 50;
        
        UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(110, y2, 545, 47)];
        [commentTextView setText:[preCommEditDict objectForKey:tagID]];
        [commentTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [commentTextView setTag:2000 + [tagID integerValue]];
        [commentTextView performSelector:@selector(setDelegate:) withObject:self];
        
        [scrollView addSubview:commentTextView];
        
        y2 += 50;
        
    }
    
    [scrollView setFrame:CGRectMake(15, 435, 680, 260)];
    [scrollView setContentSize:CGSizeMake(620.0, [preCommEditDict count]*50.0)];
    [self.view addSubview:scrollView];
    
    NSLog(@"quickGradeDict : %@, preCommDict : %@",quickGradeEditDict, preCommEditDict);
}

- (void) addQuickGrade:(NSString*)description
{
    
    UITextView *quickTextView;
    UIButton *quickButton1;
    UIButton *quickButton2;
    
    UIScrollView *scrollView1 = (UIScrollView*)[self.view viewWithTag:1];
    
    int tagID = totalQuickGrdCount;
    
    if([quickGradeEditDict count] % 2 != 0){
        
        quickTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, yPos1, 180, 50)];
        quickButton1 = [[UIButton alloc] initWithFrame:CGRectMake(220, yPos1+10, 31, 31)];
        quickButton2 = [[UIButton alloc] initWithFrame:CGRectMake(280, yPos1+10, 31, 31)];
        
        yPos1 += 45;
        
    }
    else{
        quickTextView = [[UITextView alloc] initWithFrame:CGRectMake(360, yPos2, 180, 50)];
        quickButton1 = [[UIButton alloc] initWithFrame:CGRectMake(570, yPos2+10, 31, 31)];
        quickButton2 = [[UIButton alloc] initWithFrame:CGRectMake(630, yPos2+10, 31, 31)];
        
        yPos2 += 45;
    }
    
    [quickTextView setText:[NSString stringWithFormat:@"%@",description]];
    [quickTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [scrollView1 addSubview:quickTextView];
    
    [quickButton1 setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
    [quickButton1 setTag:tagID*100000];
    
    [quickButton2 setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
    [quickButton2 setTag:tagID*100000+1];
    
    [quickButton1 addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [quickButton2 addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView1 addSubview:quickButton1];
    [scrollView1 addSubview:quickButton2];
    [scrollView1 setContentSize:CGSizeMake(620.0, [quickGradeEditDict count]*27.0)];
    
    // Adding to QuikGrade to Database
    
    sqlite3 *database;
    
    NSString *stmt;
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK)
    {
        stmt = [NSString stringWithFormat:@"INSERT INTO QuickGrade (QuickGradeID,ModuleName,SpeechType,QuickGradeDescription,IsActive) VALUES ('%d','%@','%@','%@',0)", totalQuickGrdCount, moduleName, speechType, description];
        
        sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
    }
    
    sqlite3_close(database);
    
}

- (void) addPreComments:(NSString*)description
{
    
    UIButton *commentButton1 = [[UIButton alloc] initWithFrame:CGRectMake(15, y1, 31, 31)];
    UIButton *commentButton2 = [[UIButton alloc] initWithFrame:CGRectMake(80, y1, 31, 31)];
    
    UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:2];
    
    [commentButton1 setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
    
    int tagID = totalPreCommCount;
    
    [commentButton1 setTag:tagID*100];
    
    [commentButton2 setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
    [commentButton2 setTag:tagID*100+1];
    
    [commentButton1 addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [commentButton2 addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:commentButton1];
    [scrollView addSubview:commentButton2];
    
    y1 += 50;
    
    UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(110, y2, 545, 47)];
    [commentTextView setText:description];
    [commentTextView setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    [scrollView addSubview:commentTextView];
    
    y2 += 50;
    
    [scrollView setContentSize:CGSizeMake(620.0, [preCommEditDict count]*50.0)];
    
    // Adding to QuikGrade to Database
    
    sqlite3 *database;
    
    NSString *stmt;
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK)
    {
        
        stmt = [NSString stringWithFormat:@"INSERT INTO PredefinedComment (PredefinedCommentID,ModuleName,SpeechType,PredefinedCommentDescription,IsActive) VALUES ('%d','%@','%@','%@',0)", totalPreCommCount, moduleName, speechType, description];
        
        sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
    }
    
    sqlite3_close(database);
    
}

-(void)insertIntoDB
{
    sqlite3 *database;
    
    NSString *stmt;
    NSString *id = @"";
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK)
    {
        stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO Modules(ModuleName,SpeechType,MaxPoints) VALUES ('%@','%@','%@')", moduleName, speechType,[(UITextField*)[self.view viewWithTag:901] text]];
        
        sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
        
        
        for (int i = 0; i<[quickGradeEditDict count]; i++) {
            
            id = [[[quickGradeEditDict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i];
            
            stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO QuickGrade (QuickGradeID,ModuleName,SpeechType,QuickGradeDescription,IsActive) VALUES ('%@','%@','%@','%@','%@')", id, moduleName, speechType, [quickGradeEditDict objectForKey:id], [isQuickCheckedDic objectForKey:id]];
            
            sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
            
        }
        
        
        for (int i = 0; i<[preCommEditDict count]; i++) {
            
            id = [[[preCommEditDict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i];
            
            stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO PredefinedComment (PredefinedCommentID,ModuleName,SpeechType,PredefinedCommentDescription,IsActive) VALUES ('%@','%@','%@','%@','%@')", id, moduleName, speechType, [preCommEditDict objectForKey:id], [isCommCheckedDic objectForKey:id]];
            
            sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
            
        }
    }
    
    sqlite3_close(database);
    
}

//-(void)insertIntoDB
//{
//    sqlite3 *database;
//    
//    NSString *stmt;
//    NSString *id = @"";
//    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    if(sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK)
//    {
//        stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO Modules(ModuleName,SpeechType,MaxPoints) VALUES ('%@','%@','%@')", moduleName, speechType,[(UITextField*)[self.view viewWithTag:901] text]];
//        
//        sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
//        
//        
//        for (int i = 0; i<[quickGradeEditDict count]; i++) {
//            
//            id = [[[quickGradeEditDict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i];
//            
//            stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO QuickGrade (QuickGradeID,QuickGradeDescription,IsActive) VALUES ('%@','%@','%@')", id, [quickGradeEditDict objectForKey:id], [isQuickCheckedDic objectForKey:id]];
//            
//            sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
//            
//        }
//        
//        
//        for (int i = 0; i<[preCommEditDict count]; i++) {
//            
//            id = [[[preCommEditDict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i];
//            
//            stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO PredefinedComment (PredefinedCommentID,PredefinedCommentDescription,IsActive) VALUES ('%@','%@','%@')", id, [preCommEditDict objectForKey:id], [isCommCheckedDic objectForKey:id]];
//            
//            sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
//            
//        }
//    }
//    
//    sqlite3_close(database);
//    
//}

-(void)textViewDidBeginEditing:(UITextView*)textView
{
    NSLog(@"begining");
    UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:2];
    CGRect rec1 = CGRectMake(15, 100, 680, 260);
    CGRect rec2 = scrollView.frame;
    
    if ([textView tag]/1000 == 2 && !(CGRectEqualToRect(rec1, rec2))) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [scrollView setFrame:CGRectMake(15, 100, 680, 260)];
        [UIView commitAnimations];
        
    }
}

-(void)textViewDidEndEditing:(UITextView*)textView
{
    [textView resignFirstResponder];
    
    if ([textView tag]/1000 == 2) {
        
        UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:2];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [scrollView setFrame:CGRectMake(15, 435, 680, 260)];
        [UIView commitAnimations];
        
    }
    
    NSLog(@"textView tag : %d",textView.tag);
    
    if ([textView tag]/1000 == 1) {
        [quickGradeEditDict setObject:[textView text] forKey:[NSString stringWithFormat:@"%d",[textView tag] - 1000]];
    }
    else{
        [preCommEditDict setObject:[textView text] forKey:[NSString stringWithFormat:@"%d",[textView tag] - 2000]];
    }
}

//suspend keypad

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
