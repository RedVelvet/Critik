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
@synthesize sections, students, managedObjectContext;

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

    students = [[NSArray alloc]init];
    
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
    // Section *temp = [self.sections objectAtIndex: row]
    students = [self.currSection.students allObjects];
    
    [self.studentTableView reloadData];
    NSLog(@"Row : %d  Component : %d", row, component);
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
    
    return [students count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    [self.studentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if([students count] != 0){
        cell.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:100.0/255.0 blue:30.0/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = [self.students objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the managedObjectContext from the AppDelegate (for use in CoreData Applications)
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appdelegate.managedObjectContext;
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        
//        YourObject *object = [self.dataSourceArray objectAtIndex:indexPath.row];
//        [self.dataSourceArray removeObjectAtIndex:indexPath.row];
//        // You might want to delete the object from your Data Store if you’re using CoreData
//        [context deleteObject:pairToDelete];
//        NSError *error;
//        [context save:&error];
//        // Animate the deletion
//        [tableView deleteRowsAtIndexPaths:[NSArrayarrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        // Additional code to configure the Edit Button, if any
//        if (self.dataSourceArray.count == 0) {
//            self.editButton.enabled = NO;
//            self.editButton.titleLabel.text = @”Edit”;
//        }
//    }
//    elseif (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        YourObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Header" inManagedObjectContext:context];
//        newObject.value = @”value”;
//        [context save:&error];
//        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationFade];
//        if (self.dataSourceArray.count > 0) {
//            self.editButton.enabled = YES;
//        }
//    }
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

        // Add Section to Core Data
        Section *newSection = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:managedObjectContext];
        newSection.sectionName = sectionName;
        NSError *error;
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
}



- (IBAction)unwindToTableView:(UIStoryboardSegue *)sender
{
    AddStudentVC *addStudentVC = (AddStudentVC *)sender.sourceViewController;
    NSString *firstName = addStudentVC.studentFirstNameTF.text;
    NSString *lastName = addStudentVC.studentLastNameTF.text;
    NSString *sNum = addStudentVC.sNumTF.text;
    NSLog(@"--- Unwind to Tableview");
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];

    // If NOT blank and NOT whitespace
    if(![firstName length] == 0 && ![[firstName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0
       && ![lastName length] == 0 && ![[lastName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0
       && ![sNum length] == 0 && ![[sNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        
        // Add Student to Core Data
        Student *newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:managedObjectContext];
        newStudent.firstName = firstName;
        newStudent.lastName = lastName;
        newStudent.studentID = sNum;
        NSError *error;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        [self.currSection addStudentsObject:newStudent];
        
    }
}
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //    stuName = [studentsArray objectAtIndex:indexPath.row];
//    //    stuID = [studentIDArray objectAtIndex:indexPath.row];
//    //    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}

- (IBAction)showStudentsPressed:(id)sender {
    
    NSLog(@"hurray!! the button was pressed!");
    NSLog(@"%@",self.currSection.sectionName);
}
@end
