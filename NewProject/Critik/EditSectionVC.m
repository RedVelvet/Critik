//
//  EditSectionVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 2/18/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditSectionVC.h"
#import "AddSectionVC.h"
#import "AddStudentVC.h"

@interface EditSectionVC ()

@end

@implementation EditSectionVC
@synthesize sections, students, managedObjectContext, restClient;

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
	// Do any additional setup after loading the view.

    // Core Data Stuff
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Section" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    sections = [[NSArray alloc]init];
    sections = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    int size = [sections count];
    NSLog(@"there are %d objects in the array", size);
    //Instantiate NSMutableArray

    students = [[NSMutableArray alloc]init];
    
    if ([sections count] == 0) {
        self.sectionLabel.text = @"Add a section";
    }
    else
    {
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionName" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        sections = [sections sortedArrayUsingDescriptors:descriptors];
    }
    
    UIView *pickerView = (UIPickerView*)[self.view viewWithTag:1000];
    
    
        
}

-(void) viewDidAppear:(BOOL)animated{
    
    
    
    [self.studentTableView reloadData];
}

#pragma mark - Picker View data source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [sections count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    Section * section = [sections objectAtIndex:row];
    self.currSection = section;
    return section.sectionName;
    
}

#pragma mark - Picker View delegate methods

-(void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Section *temp = [self.sections objectAtIndex: row];
    NSSet *students = temp.students;
    

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.students count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    [self.studentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    if([students count] != 0){
        cell.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:100.0/255.0 blue:30.0/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    Student *tempStudent = [self.students objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", tempStudent.firstName, tempStudent.lastName];
    cell.detailTextLabel.text = tempStudent.studentID; // FOR DEBUGGING PURPOSES
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Student *studentToDelete = [self.students objectAtIndex:indexPath.row];
        [self.students removeObjectAtIndex:indexPath.row];
        
        //Remove student from section
        [studentToDelete.section removeStudentsObject:studentToDelete];
        
        // You might want to delete the object from your Data Store if you’re using CoreData
        [managedObjectContext deleteObject:studentToDelete];
        NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
        }
        
        // Animate the deletion
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
       
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Unwind

// called after 'Save' is tapped on the AddSectionVC
- (IBAction)unwindToEditSection:(UIStoryboardSegue *)sender
{
    AddSectionVC *addSectionVC = (AddSectionVC *)sender.sourceViewController;
    NSString *sectionName = addSectionVC.sectionTextField.text;
    
    // If NOT blank and NOT whitespace
    if(![sectionName length] == 0 && ![[sectionName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){

        // Check if there is already a student with the new id
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(sectionName like %@)", sectionName];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
        NSLog(@"Count %d", count);
        
        if(count == 0)
        {

            // Add Section to Core Data
            Section *newSection = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:managedObjectContext];
            newSection.sectionName = sectionName;
            
            if (![managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:managedObjectContext];
            [fetchRequest setEntity:entity];
            
            sections = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionName" ascending:YES];
            NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
            sections = [sections sortedArrayUsingDescriptors:descriptors];
            [self.sectionPicker reloadAllComponents];
        }
        else{
            NSLog(@"Section already exists");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Error"
                                  message: @"A section with this name already exists"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
}


// called after 'Save' is tapped on the AddStudentVC
- (IBAction)unwindToTableView:(UIStoryboardSegue *)sender
{
    AddStudentVC *addStudentVC = (AddStudentVC *)sender.sourceViewController;
    NSString *firstName = addStudentVC.studentFirstNameTF.text;
    NSString *lastName = addStudentVC.studentLastNameTF.text;
    NSString *sNum = addStudentVC.sNumTF.text;
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];

    // If NOT blank and NOT whitespace
    if(![firstName length] == 0 && ![[firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0
       && ![lastName length] == 0 && ![[lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0
       && ![sNum length] == 0 && ![[sNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        
        // Check if there is already a student with the new id
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(studentID like %@)", sNum];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
        NSLog(@"Count %d", count);
        
        if(count == 0)
        {
            // Add Student to Core Data
            Student *newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:managedObjectContext];
            newStudent.firstName = firstName;
            newStudent.lastName = lastName;
            newStudent.studentID = sNum;
            newStudent.section = self.currSection;
            
            // Add Student to current section
            [self.currSection addStudentsObject:newStudent];
            
            // Save context
            if (![managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            [self.studentTableView reloadData];
        }
        else
        {
            NSLog(@"Student already exists");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Error"
                                  message: @"A student with this id already exists"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
}

// called after 'Upload Roster' is tapped on the AddStudentVC
- (IBAction)unwindToEditSectionForRosterUpload:(UIStoryboardSegue *)sender
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
//    [self downloadFile];
    [self addStudentsToSectionFromRoster];
}

#pragma mark - Buttons
- (IBAction)addStudentPressed:(id)sender {
    
    NSLog(@"hurray!! the button was pressed!");
    NSLog(@"%@",self.currSection.sectionName);
}

- (IBAction)deleteSectionPressed:(id)sender{
    
    NSLog(@"%@", self.currSection.sectionName);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure want to delete section" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    [alert show];
    [alert setTag:1];
}

#pragma mark - Utility methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 1) {
        
        if (buttonIndex==0) {
            
        }
        else
        {
            // Okay was pressed so delete the section, this will cascade to all students in the section
            [managedObjectContext deleteObject:self.currSection];
            NSError *error;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
            }
            [self.sectionPicker reloadAllComponents];
            [self.studentTableView reloadData];
        }
    }
}

-(void) addStudentsToSectionFromRoster
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *localPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", self.currSection.sectionName]];
    
    // LOCAL TEST PATH /Volumes/Macintosh HD/Users/dougwettlaufer/Library/Application Support/iPhone Simulator/7.0.3/Applications/FF66739D-1276-4074-A567-C23D7F2BF65D
    
    NSStringEncoding encoding;
    NSError *error;
    NSString *fileContents = [[NSString alloc] initWithContentsOfFile:localPath usedEncoding:&encoding error:&error];
    
    // Remove tab characters
    [fileContents stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    // Array of arrays (file lines)
    NSArray *fileArray = [fileContents componentsSeparatedByString:@"\n"];


    NSMutableArray *studentArray = [[NSMutableArray alloc]init];
    
    // Start at index 2 because the first two lines are not of interest to us
    for (int i = 2; i < [fileArray count]-1; i++) {
  
        // Split line on commas
        NSArray *lineItem = [[fileArray objectAtIndex:i] componentsSeparatedByString:@","];
        studentArray = [NSMutableArray arrayWithArray:lineItem];
        
        NSString *firstName = [studentArray objectAtIndex:3];
        NSString *lastName = [studentArray objectAtIndex:2];
        NSString *sNum = [studentArray objectAtIndex:1];
        
        NSLog(@"S#: %@ \nLast name: %@ \nFirst name: %@", [studentArray objectAtIndex:1], [studentArray objectAtIndex:2], [studentArray objectAtIndex:3]);
        
        // Save unique students to core data
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(studentID like %@)", sNum];
        [fetchRequest setPredicate:predicate];
        NSError *error;
        NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
        NSLog(@"Count %d", count);
        
        if(count == 0)
        {
            // Add Student to Core Data
            Student *newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:managedObjectContext];
            newStudent.firstName = firstName;
            newStudent.lastName = lastName;
            newStudent.studentID = sNum;
            newStudent.section = self.currSection;
            
            // Add Student to current section
            [self.currSection addStudentsObject:newStudent];
            
            // Save context
            if (![managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        else{
            NSLog(@"Student with s# %@ could not be added", sNum);
        }

    }

    
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
        // App hasn't been linked so create folder '/Apps/Critik'
    }
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *localPath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@.csv",self.currSection.sectionName]];
    
    [[self restClient] loadFile:[NSString stringWithFormat:@"/Apps/Critik/%@.csv",self.currSection.sectionName] intoPath:localPath];
    
    
}
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    
    NSLog(@"File loaded into path: %@", localPath);
    
    [self addStudentsToSectionFromRoster];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"File has been downloaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Failed to download file. Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
