//
//  StudentSelectionVC.m
//  Critik
//
//  Created by Dalton Decker on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentSelectionVC.h"

@interface StudentSelectionVC ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation StudentSelectionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.currSpeech);
    //Set the title of the current view based on the speech selected
    self.navigationController.title = self.currSpeech;
    
    /*Core Data Implementation:
    Create a managedObjectContext and set equal to AppDelegates ManagedObjectContext.*/
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    //initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting the entity name to grab from Core Data.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    //Retrieve sections from core data and store within sections attribute
    self.sections = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    
    //Fill Section Picker and order by section name
    if([self.sections count] >1){
        
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionName" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        self.sections = [NSMutableArray arrayWithArray:[self.sections sortedArrayUsingDescriptors:descriptors]];
    }
    
    
    /* Student list implementation
    Fills the students table with the first section data of the pickerview when view is first presented*/
    Section * temp = [self.sections objectAtIndex:0];
    NSSet * set = temp.students;
    self.students = [NSMutableArray arrayWithArray:[set allObjects]];
    
    //If students table hasn't been ordered, then set to alphabetical order by last name.
    if([self.students count] >1)
    {
        //retrieve a student to determine if list is sorted or not.
        Student * temp = [self.students objectAtIndex:0];
        if(temp.orderIndex == [NSNumber numberWithInt: -1])
        {
            id sender;
            [sender setTag:0];
            [self setStudentOrder:sender];
        }else{
            NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
            NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
            self.students = [NSMutableArray arrayWithArray:[self.students sortedArrayUsingDescriptors:descriptors]];

        }
    }
    //Updates orderIndex for students list
    for(int i = 0; i < [self.students count]; i ++)
    {
        Student * temp = [self.students objectAtIndex:i];
        temp.orderIndex = [NSNumber numberWithInt:i];
        [self.students setObject:temp atIndexedSubscript:i];
    }
    
    
    //Update section picker and student table when view controller is loaded.
    [self.SectionPicker reloadAllComponents];
    [self.StudentTable reloadData];
}

-(void) viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker View data source

//sets number of rows in picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.sections count];
}

//sets the number of sections in the picker view
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

//links the contents of the pickerArray with the PickerView
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Section * tempSection = [self.sections objectAtIndex:row];
    return tempSection.sectionName;
}

//Updates data within student list based on what section is selected in the picker view
-(void) pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Section * temp = [self.sections objectAtIndex:row];
    NSSet * set = temp.students;
    self.students = [NSMutableArray arrayWithArray:[set allObjects]];
    
    // Sort the array by last name
    if([self.students count] >1)
    {
        Student * temp = [self.students objectAtIndex:0];
        if(temp.orderIndex == [NSNumber numberWithInt: -1])
        {
            id sender;
            [sender setTag:0];
            [self setStudentOrder:sender];
        }else{
            
            NSMutableArray * tempStudents = [[NSMutableArray alloc]init];
            for(int i = 0; i < [self.students count]; i ++)
            {
                Student * temp = [self.students objectAtIndex:i];
                [tempStudents insertObject:temp atIndex: (NSInteger)temp.orderIndex];
            }
            self.students = tempStudents;
        }
    }
    
    [self.StudentTable reloadData];
    
}

#pragma mark - Table view data source

//sets the number of sections in a TableView
- (int)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//sets the number of rows in a TableView
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (int)[self.students count];
}

//creates the cells with the appropriate information displayed in them. Name, Founding Year, Population, and Area.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    Student * tempStudent = [self.students objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",tempStudent.firstName, tempStudent.lastName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Create new Evaluation View
    StudentEvaluationVC * evaluateSpeech = [self.storyboard instantiateViewControllerWithIdentifier:@"Student Evaluation"];
    //Create a temp student from student selected from table
    Student * currentStudent = [self.students objectAtIndex:indexPath.row];
    //set Evaluation's current Student as the Student selected
    evaluateSpeech.currentStudent = currentStudent;
    //Set the current SpeechName
    evaluateSpeech.currentSpeechName = self.currSpeech;

    //Get a list of all speeches from core data
    //initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting the entity name to grab from Core Data.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Speech" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(isTemplate = %@)",@"true"]];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray * allSpeeches = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"%d",[allSpeeches count]);
//    if([currentStudent.studentSpeech count] == 0)
//    {
        //For loop to add all possible speeches
        for(int a = 0; a < [allSpeeches count]; a ++)
        {
            //The Template speech from which to create new StudentSpeech
            Speech * templateSpeech = [allSpeeches objectAtIndex:a];
            //Create newStudentSpeech and newSpeech and insert into managedObjectContext to be saved to core data.
            StudentSpeech * newStudentSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"StudentSpeech" inManagedObjectContext:self.managedObjectContext];
            Speech * newSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"Speech" inManagedObjectContext:self.managedObjectContext];

            //Makes the new speech a copy of the current speech to evaluate
            [newSpeech setValue:@"false" forKeyPath:@"isTemplate"];
            [newSpeech setValue:templateSpeech.speechType forKeyPath:@"speechType"];
            
            //Add the Modules to the new Speech along with the QuickGrades and PreDefinedComments related to that Module being added
            NSArray * templateModules = [templateSpeech.modules allObjects];
            for(int i = 0; i < [templateModules count]; i ++){
                //current module from template module
                Module * tempModule = [templateModules objectAtIndex:i];
                //create new Module and add to managedObjectContext
                Module * newModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:self.managedObjectContext];
                
                //Set values of newModule based on templateModule
                [newModule setValue:tempModule.moduleName forKeyPath:@"moduleName"];
                [newModule setValue:tempModule.points forKeyPath:@"points"];
                [newModule setValue:tempModule.orderIndex forKeyPath:@"orderIndex"];
                [newModule setValue:tempModule.written forKeyPath:@"written"];
                [newModule setValue:newSpeech forKeyPath:@"speech"];
                
                //add Module to newSpeech
                [newSpeech addModulesObject:newModule];
                
                //Add the quickGrades to the new Module being added
                NSArray * templateQuickGrades = [tempModule.quickGrade allObjects];
                for(int j = 0; j < [templateQuickGrades count]; j ++){
                    //current QuickGrade from Current Module
                    QuickGrade * tempQuickGrade = [templateQuickGrades objectAtIndex:j];
                    //Create new QuickGrade within managedObjectContext
                    QuickGrade * newQuickGrade = [NSEntityDescription insertNewObjectForEntityForName:@"QuickGrade" inManagedObjectContext:self.managedObjectContext];
                    
                    //Set values of new QuickGrade based on template QuickGrade
                    [newQuickGrade setValue:tempQuickGrade.isActive forKeyPath:@"isActive"];
                    [newQuickGrade setValue:tempQuickGrade.quickGradeDescription forKeyPath:@"quickGradeDescription"];
                    [newQuickGrade setValue:tempQuickGrade.score forKeyPath:@"score"];
                    [newQuickGrade setValue:newModule forKeyPath:@"module"];
                    
                    //add QuickGrade to current Module
                    [newModule addQuickGradeObject:newQuickGrade];
                }
                
                //Add the preDefinedComments to the new Module being added
                NSArray * templateComments = [tempModule.preDefinedComments allObjects];
                for(int j = 0; j < [templateComments count]; j ++){
                    //current PreDefinedComment from Current Module
                    PreDefinedComments * tempComment = [templateComments objectAtIndex:j];
                    //Create new PreDefinedComment within managedObjectContext
                    PreDefinedComments * newComment = [NSEntityDescription insertNewObjectForEntityForName:@"PreDefinedComments" inManagedObjectContext:self.managedObjectContext];
                    //set new PreDefinedComment equal to current PreDefinedComment to add
//                    newComment = tempComment;
                    [newComment setValue:tempComment.comment forKeyPath:@"comment"];
                    [newComment setValue:tempComment.isActive forKeyPath:@"isActive"];
                    [newComment setValue:tempComment.isSelected forKeyPath:@"isSelected"];
                    [newComment setValue:newModule forKeyPath:@"module"];
                    
                    //add PreDefinedComment to current Module
                    [newModule addPreDefinedCommentsObject:newComment];
                }
            }
            //assigns the new Speech to the new Student Speech
            [newStudentSpeech setValue:newSpeech forKeyPath:@"speech"];
            
            //adds the newly created student speech as a studentSpeech for the current Student
            [currentStudent addStudentSpeechObject:newStudentSpeech];
            
            
            //Save managedObjectContext to Core Data. Print out error if can not save
            if(![self.managedObjectContext save:&error])
            {
                NSLog(@"Could not save studentSpeech: %@", [error localizedDescription]);
            }
        }
//    }else{
//        
//        NSLog(@"Need to update speeches");
//        //[self updateStudentSpeech];
//    }
    
    //Sets the currentStudentSpeech to pass on to the Evaluation page
    NSArray * studentSpeechesToSelectFrom = [currentStudent.studentSpeech allObjects];
    for(int i = 0; i < [studentSpeechesToSelectFrom count]; i ++){
        StudentSpeech * tempSS = [studentSpeechesToSelectFrom objectAtIndex:i];
        Speech * temp = tempSS.speech;
        NSString * speechName = temp.speechType;
        if([speechName isEqualToString:self.currSpeech]){
            evaluateSpeech.currentStudentSpeech = [studentSpeechesToSelectFrom objectAtIndex:i];
        }
    }
    
    [self.navigationController pushViewController:evaluateSpeech animated:YES];
    
}


# pragma mark - Popover Handling
- (void)showPopover:(id)sender
{
    
}
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    if ([identifier isEqualToString:@"studentOrder"]) {
//        if (self.orderPopover == nil) {
//            return YES;
//        }
//        return NO;
//    }
//    return YES;
//}
//- (void) dismissPopover:(NSString *)order
//{
//    // Dismiss the popover here and process data
//    [popover dismissPopoverAnimated:YES];
//    [self setStudentOrder:order];
//
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"orderPopoverSegue"]) {
//        popover = [(UIStoryboardPopoverSegue *)segue popoverController];
//        popover.popoverBackgroundViewClass = [UIPopoverBackgroundView class];
//        
//         StudentOrderPopoverVC* popoverView = (StudentOrderPopoverVC *)popover.contentViewController;
//
//        popoverView.delegate = self;
//    }
//}

//Sorts students based on instructor selection in popover
- (void) setStudentOrder: (NSString*) order
{
    if([order isEqualToString: @"Randomize"]){
        // create temporary array
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self.students count]];
        
        for (id anObject in self.students)
        {
            NSUInteger randomPos = arc4random()%([tmpArray count]+1);
            [tmpArray insertObject:anObject atIndex:randomPos];
        }
        
        self.students = [NSMutableArray arrayWithArray:tmpArray];
        
    }else{
        
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        self.students = [NSMutableArray arrayWithArray:[self.students sortedArrayUsingDescriptors:descriptors]];
    }
    NSLog(@"ORder Changed");
    NSMutableArray * tempStudents = [[NSMutableArray alloc]init];
    for(int i = 0; i < [self.students count]; i ++)
    {
        Student * temp = [self.students objectAtIndex:i];
        temp.orderIndex = [NSNumber numberWithInt: i];
        [tempStudents insertObject:temp atIndex:i];
    }
    self.students = tempStudents;
}

- (IBAction)UnwindFromFinalizeToStudentSelection:(UIStoryboardSegue *)unwindSegue{
    
}

@end
