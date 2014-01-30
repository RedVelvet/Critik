//
//  SectionViewController.m
//  Presentation Feedback
//
//  Created by Gautham raaz on 12/5/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import "SectionViewController.h"

@interface SectionViewController ()

@end

@implementation SectionViewController
@synthesize addSectionView, studentsTableView, restClient;

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
    
    index = 0;
    [sectionDic setDictionary:nil];
    [addSectionView setHidden:YES];
    [studentsTableView setHidden:YES];
    [studentsArray setArray:nil];
    
	// Do any additional setup after loading the view.
    [self getSections];
    [self loadScrollView];
}

#pragma mark - IBAction methods

-(IBAction)checkButtonPressed:(id)sender
{
    
    UIButton *checkButton = (UIButton*)sender;
    
    checkButton.selected = !checkButton.selected;
    
    for (int i=0; i<[sectionDic count]; i++) {
        
        UIButton *button = (UIButton*)[self.view viewWithTag:100+[[[[sectionDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i] integerValue]];
        
        [button setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
    }
    
    [checkButton setImage:[UIImage imageNamed:@"CheckBoxChecked.jpeg"] forState:UIControlStateNormal];
    
    index = [checkButton tag];

    section = [sectionDic objectForKey:[[[sectionDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:index-100]];
    
    NSLog(@"index : %d, section : %@", index, section);
}

-(IBAction)addStudents:(id)sender
{
    if(!index == 0){
        [self downloadFile];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select the section" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(IBAction)addSection:(id)sender
{
    [addSectionView setHidden:NO];
    [self.view addSubview:addSectionView];
    
}

-(IBAction)deleteSection:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure want to delete section" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    [alert show];
    [alert setTag:1];
    
}

-(IBAction)showStudents:(id)sender
{
    if(!index == 0)
    {
    
        LandingPageViewController *landingPageVC = [[LandingPageViewController alloc] init];
        [studentsArray setArray:nil];
        [landingPageVC getstudentList];
        [studentsTableView reloadData];
        if ([studentsArray count] == 0) {
        
            [studentsTableView setHidden:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"No students in the section" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        else{
            [studentsTableView setHidden:NO];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please select the section" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

}

#pragma mark - Utility Methods

- (void)getSections
{
    int i=0;
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    sqlite3 *database;
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);
    
    NSString *query = @"select DISTINCT section from Student";
	
    sqlite3_stmt *statement;
    
	sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    
    while (sqlite3_step(statement) == SQLITE_ROW)	{
        
        [sectionDic setObject:[NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)] forKey:[NSString stringWithFormat:@"%d",i++]];
    }
    sqlite3_reset(statement);
    sqlite3_finalize(statement);
    statement = nil;
    sqlite3_close(database);
}

- (IBAction)doneButtonPressed:(id)sender;
{
    int tagId;
    
    if([[sectionDic allKeys] count] > 0)
        tagId = [[[[sectionDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:[sectionDic count]-1] integerValue]+1;
    else
        tagId = 0;
    
    UITextField *sectionName = (UITextField*)[addSectionView viewWithTag:20];
    [sectionDic setObject:[sectionName text] forKey:[NSString stringWithFormat:@"%d",tagId]];
    
    UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:1];
    [scrollView setContentSize:CGSizeMake(328, [sectionDic count]*50)];
    
    UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(40, ([sectionDic count]-1)*40+20, 30, 30)];
    [checkButton setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [checkButton setTag:100 + tagId];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, ([sectionDic count]-1)*40+20, 100, 30)];
    [sectionLabel setText:[sectionName text]];
    
    [scrollView addSubview:checkButton];
    [scrollView addSubview:sectionLabel];
    
    [addSectionView setHidden:YES];
    [sectionName setText:@""];
    
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [addSectionView setHidden:YES];
}


-(void)loadScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(32, 136, 328, 165)];
    [scrollView setContentSize:CGSizeMake(328, [sectionDic count]*50)];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [scrollView setScrollsToTop:YES];
    [scrollView setShowsVerticalScrollIndicator:YES];
    [scrollView setBouncesZoom:YES];
    [scrollView setTag:1];
    
    for (int i = 0; i<[sectionDic count]; i++) {
        
        UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(40, i*40+20, 30, 30)];
        [checkButton setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
        [checkButton addTarget:self action:@selector(checkButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [checkButton setTag:100 + [[[[sectionDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i] integerValue]];
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, i*40+20, 100, 30)];
        [sectionLabel setText:[sectionDic objectForKey:[[[sectionDic allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)] objectAtIndex:i]]];
        
        [scrollView addSubview:checkButton];
        [scrollView addSubview:sectionLabel];
        
    }
    
    [self.view addSubview:scrollView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)deleteSectionInDB
{
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    sqlite3 *database;
    
    sqlite3_open([[appDelegate getDBPath] UTF8String], &database);

    NSString *deleteQuery = [[NSString alloc] initWithFormat:@"DELETE FROM Student WHERE Section ='%@'",[sectionDic objectForKey:[NSString stringWithFormat:@"%d",index-100]]];
    
    sqlite3_exec(database, [deleteQuery  UTF8String],NULL, NULL, NULL);

    sqlite3_close(database);
        
}

-(void) insertStudentsIntoDB
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *localPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", section]];
    
    
//    
//    NSMutableArray *titleArray=[[NSMutableArray alloc]init];
//    
//    NSString *fileDataString=[NSString stringWithContentsOfFile:localPath encoding:NSUTF8StringEncoding error:nil];
//    
//    NSArray *linesArray=[fileDataString componentsSeparatedByString:@"\n"];
//    
//    
//    NSLog(@"%@",titleArray);
//    
    
    
    
    NSStringEncoding encoding;
    NSError *error;
    NSString *fileContents = [[NSString alloc] initWithContentsOfFile:localPath usedEncoding:&encoding error:&error];
    
    NSLog(@"fileContents : %@", fileContents);
    [fileContents stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
//    NSArray *array = [fileContents componentsSeparatedByString:@","];
    NSArray *array = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"array : %@", array);
    [studentsArray arrayByAddingObjectsFromArray:array];
    
    sqlite3 *database;
    
    NSString *stmt;
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if(sqlite3_open([[appDelegate getDBPath] UTF8String], &database) == SQLITE_OK)
    {
        
        for (int i = 0; i<[array count]; i++) {
            
            if([[array objectAtIndex:i] rangeOfString:@"\t"].location == NSNotFound)
            {
                stmt = [NSString stringWithFormat:@"INSERT INTO Student (StuLastName,StuFirstName,Section) VALUES ('%@','%@','%@')",[[[array objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:0], [[[array objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:1], [sectionDic objectForKey:[NSString stringWithFormat:@"%d",index-100]]];
            }
            else{
                stmt = [NSString stringWithFormat:@"INSERT INTO Student (StuLastName,StuFirstName,Section) VALUES ('%@','%@','%@')",[[[array objectAtIndex:i] componentsSeparatedByString:@"\t"] objectAtIndex:0], [[[array objectAtIndex:i] componentsSeparatedByString:@"\t"] objectAtIndex:1], [sectionDic objectForKey:[NSString stringWithFormat:@"%d",index-100]]];
            }
            
            sqlite3_exec(database, [stmt  UTF8String],NULL, NULL, NULL);
        }
    }
    sqlite3_close(database);
    
}
#pragma mark - DropBox methods

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    
    NSLog(@"File upload failed with error - %@", error);
}


- (void)loadfiles:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    [[self restClient] loadMetadata:@"/"];
}


- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    
    NSLog(@"Error loading metadata: %@", error);
}


-(void)downloadFile {
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
    NSString *section = [sectionDic objectForKey:[NSString stringWithFormat:@"%d",index-100]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *localPath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@.txt",section]];
//    NSString *localPath = [docDir stringByAppendingString:@"/StudentDetails.txt"];

    [[self restClient] loadFile:[NSString stringWithFormat:@"/StudentDetails/%@.txt",section] intoPath:localPath];
    
    
}
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    
    NSLog(@"File loaded into path: %@", localPath);
    
    [self insertStudentsIntoDB];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"File has been downloaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Failed to download file. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
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
    
    [studentsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [studentsArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    stuName = [studentsArray objectAtIndex:indexPath.row];
//    stuID = [studentIDArray objectAtIndex:indexPath.row];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        
        if (buttonIndex==0) {
            
        }
        else
        {
            [self deleteSectionInDB];
            [sectionDic removeObjectForKey:[NSString stringWithFormat:@"%d",index-100]];
            
            UIScrollView *scrollView = (UIScrollView*)[self.view viewWithTag:1];
            [scrollView removeFromSuperview];
            [self loadScrollView];
        }
    }
}
@end
