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
@property NSString * orderIndexType;
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
    
    if([self.currSpeech isEqualToString:@"Informative"]){
        self.orderIndexType = @"informativeOrder";
    }else if([self.currSpeech isEqualToString:@"Persuasive"]){
        self.orderIndexType = @"persuasiveOrder";
    }else if([self.currSpeech isEqualToString:@"Interpersonal"]){
        self.orderIndexType = @"interpersonalOrder";
    }
    
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
    self.students = [NSMutableArray arrayWithArray:[temp.students allObjects]];
    
    //If students table hasn't been ordered, then set to alphabetical order by last name.
    if([self.students count] >1)
    {   int sum = 0;
        for(int i = 0; i < [self.students count]; i ++){
            Student * temp = [self.students objectAtIndex:i];
            if([self.currSpeech isEqualToString:@"Informative"]){
                sum += (int)temp.informativeOrder;
            }else if([self.currSpeech isEqualToString:@"Persuasive"]){
                sum += (int)temp.persuasiveOrder;
            }else if([self.currSpeech isEqualToString:@"Interpersonal"]){
                sum += (int)temp.interpersonalOrder;
            }
        }
        if(!([self.students count]*([self.students count]+1))/2 == sum)
        {
            [self setStudentOrder:@"Alphabetize"];
        }else{
            
            NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:self.orderIndexType ascending:YES];
            NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
            self.students = [NSMutableArray arrayWithArray:[self.students sortedArrayUsingDescriptors:descriptors]];
        }
        
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
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:self.orderIndexType ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.students = [NSMutableArray arrayWithArray:[self.students sortedArrayUsingDescriptors:descriptors]];
    
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
    NSArray * allTemplateSpeeches = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"%d",[allTemplateSpeeches count]);
    if([currentStudent.studentSpeech count] == 0)
    {
        //For loop to add all possible speeches
        for(int a = 0; a < [allTemplateSpeeches count]; a ++)
        {
            //The Template speech from which to create new StudentSpeech
            Speech * templateSpeech = [allTemplateSpeeches objectAtIndex:a];
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
    }else{
        bool needToAddSpeech = true;
        NSLog(@"Need to update speeches");
        for(int i = 0; i < [allTemplateSpeeches count]; i ++)
        {
            Speech * templateSpeech = [allTemplateSpeeches objectAtIndex: i];
            Speech * currentSpeech;
            NSArray * studentSpeeches = [currentStudent.studentSpeech allObjects];
            for(int j = 0; j < [studentSpeeches count]; j ++)
            {
                StudentSpeech * currentStudentSpeech = [studentSpeeches objectAtIndex:j];
                currentSpeech = currentStudentSpeech.speech;
                
                if([templateSpeech.speechType isEqualToString:currentSpeech.speechType]){
                    needToAddSpeech = false;
                }
            }
            if(needToAddSpeech)
            {
                //Create newStudentSpeech and newSpeech and insert into managedObjectContext to be saved to core data.
                StudentSpeech * newStudentSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"StudentSpeech" inManagedObjectContext:self.managedObjectContext];
                Speech * newSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"Speech" inManagedObjectContext:self.managedObjectContext];
                
                //Makes the new speech a copy of the current speech to evaluate
                [newSpeech setValue:@"false" forKeyPath:@"isTemplate"];
                [newSpeech setValue:currentSpeech.speechType forKeyPath:@"speechType"];
                
                //Add the Modules to the new Speech along with the QuickGrades and PreDefinedComments related to that Module being added
                NSArray * templateModules = [currentSpeech.modules allObjects];
                for(int a = 0; a < [templateModules count]; a ++){
                    //current module from template module
                    Module * tempModule = [templateModules objectAtIndex:a];
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
                    for(int m = 0;  m< [templateQuickGrades count]; m ++){
                        //current QuickGrade from Current Module
                        QuickGrade * tempQuickGrade = [templateQuickGrades objectAtIndex:m];
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
                    for(int m = 0; m < [templateComments count]; m ++){
                        //current PreDefinedComment from Current Module
                        PreDefinedComments * tempComment = [templateComments objectAtIndex:m];
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
            }else{
                //IF SPEECH EXISTS, THEN UPDATE IT!!!
                
                /* need to be able to edit descriptions if they were changed. But i need an identifier to determine which one that is*/
                
                //templateSpeech.type and currentSpeech.type are equal
                NSArray * allStudentModules = [currentSpeech.modules allObjects];
                NSArray * allTemplateModules = [templateSpeech.modules allObjects];
                for(int a = 0; a < [allTemplateModules count]; a ++){
                    //current module from template module and student module
                    Module * tempModule = [allTemplateModules objectAtIndex:a];
                    Module * studentModule = [allStudentModules objectAtIndex:a];
                    
                    //Update student Module possible points
                    studentModule.pointsPossible = tempModule.pointsPossible;
                    
                    //quick grades from template and student being compared
                    NSArray * templateQuickGrades = [tempModule.quickGrade allObjects];
                    NSArray * studentQuickGrades = [studentModule.quickGrade allObjects];
                    //nothing needs to be added yet.
                    bool needToAdd = false;
                    //iterate through template quick grades to determine what needs to be added.
                    for(int m = 0;  m< [templateQuickGrades count]; m ++){
                        //current QuickGrade from Current Module
                        QuickGrade * tempQuickGrade = [templateQuickGrades objectAtIndex:m];
                        for(int b = 0; b < [studentQuickGrades count]; b ++){
                            QuickGrade * studentQuickGrade = [studentQuickGrades objectAtIndex:b];
                            //if quick grade doesn't exist, then set bool that it needs to be added.
                            if(![studentQuickGrade.quickGradeDescription isEqualToString:tempQuickGrade.quickGradeDescription]){
                                needToAdd = true;
                            }
                            
                        }
                        // add current quick grade from template to current student
                        if(needToAdd){
                            //Create new comment within managedObjectContext
                            QuickGrade * newQuickGrade = [NSEntityDescription insertNewObjectForEntityForName:@"QuickGrade" inManagedObjectContext:self.managedObjectContext];
                            //set new quick grade attributes equal to the template quick grade
                            [newQuickGrade setValue:tempQuickGrade.isActive forKeyPath:@"isActive"];
                            [newQuickGrade setValue:tempQuickGrade.quickGradeDescription forKeyPath:@"quickGradeDescription"];
                            [newQuickGrade setValue:tempQuickGrade.score forKeyPath:@"score"];
                            [newQuickGrade setValue:studentModule forKeyPath:@"module"];
                            
                            //add QuickGrade to current Module
                            [studentModule addQuickGradeObject:newQuickGrade];
                        }
                    }
                    
                    //Pre Defined Comments from template and student being compared
                    NSArray * templateComments = [tempModule.preDefinedComments allObjects];
                    NSArray * studentComments = [studentModule.preDefinedComments allObjects];
                    //Nothing needs to be added yet.
                    needToAdd = false;
                    //Iterate through template comments to determine what needs to be added.
                    for(int m = 0; m < [templateComments count]; m ++){
                        //current PreDefinedComment from Current Module
                        PreDefinedComments * tempComment = [templateComments objectAtIndex:m];
                        for(int b = 0; b < [studentComments count]; b ++){
                            //if pre Defined comment doesn't exist, then set bool that it needs to be added.
                            if(![studentComments.description isEqualToString:templateComments.description]){
                                needToAdd = true;
                            }
                        }
                        // add current comment from template to current student
                        if(needToAdd){
                            //Create new PreDefinedComment within managedObjectContext
                            PreDefinedComments * newComment = [NSEntityDescription insertNewObjectForEntityForName:@"PreDefinedComments" inManagedObjectContext:self.managedObjectContext];
                            //set new PreDefinedComment equal to current PreDefinedComment to add
                            [newComment setValue:tempComment.comment forKeyPath:@"comment"];
                            [newComment setValue:tempComment.isActive forKeyPath:@"isActive"];
                            [newComment setValue:tempComment.isSelected forKeyPath:@"isSelected"];
                            [newComment setValue:studentModule forKeyPath:@"module"];
                            
                            //add PreDefinedComment to current Module
                            [studentModule addPreDefinedCommentsObject:newComment];
                        }
                    }
                }
            }
        }
    }

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

//Sorts students based on instructor selection in popover
- (void) setStudentOrder: (NSString*) order
{
//    NSString *orderIndexType;
//    if([self.currSpeech isEqualToString:@"Informative"]){
//        orderIndexType = @"informativeOrder";
//    }else if([self.currSpeech isEqualToString:@"Persuasive"]){
//        orderIndexType = @"persuasiveOrder";
//    }else if([self.currSpeech isEqualToString:@"Interpersonal"]){
//        orderIndexType = @"interpersonalOrder";
//    }
    
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
    NSLog(@"Order Changed");
//    NSMutableArray * tempStudents = [[NSMutableArray alloc]init];
//    for(int i = 0; i < [self.students count]; i ++)
//    {
//        Student * temp = [self.students objectAtIndex:i];
//        [temp setValue:[NSNumber numberWithInt:i] forKeyPath:orderIndexType];
//        [tempStudents insertObject:temp atIndex:i];
//    }
    for(int i = 0; i < [self.students count]; i ++){
        Student * temp = [self.students objectAtIndex:i];
        [temp setValue:[NSNumber numberWithInt:i] forKeyPath:self.orderIndexType];
    }
    
    NSError * error;
    if(![self.managedObjectContext save:&error]){
        NSLog(@"Error saving to core data: %@",error);
    }
    
    [self.StudentTable reloadData];
}

- (IBAction)UnwindFromOrderPopoverToStudentSelectionAndRandomize:(UIStoryboardSegue *)unwindSegue
{
    [self setStudentOrder:@"Randomize"];
}
- (IBAction)UnwindFromOrderPopoverToStudentSelectionAndAlphabetize:(UIStoryboardSegue *)unwindSegue
{
    [self setStudentOrder:@"Alphabetize"];
}

@end
