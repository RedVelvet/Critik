//
//  StudentSelectionVC.m
//  Critik
//
//  Created by Dalton Decker on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentSelectionVC.h"

@interface StudentSelectionVC () <DBRestClientDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property NSString * orderIndexType;
@property int currentPickerSectionIndex;

@end

@implementation StudentSelectionVC
@synthesize restClient;

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
    self.currentPickerSectionIndex = 0;
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
    self.currentPickerSectionIndex = row;
    Section * temp = [self.sections objectAtIndex:row];
    NSSet * set = temp.students;
    self.students = [NSMutableArray arrayWithArray:[set allObjects]];
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:self.orderIndexType ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.students = [NSMutableArray arrayWithArray:[self.students sortedArrayUsingDescriptors:descriptors]];
    
    [self.StudentTable reloadData];
    
}

#pragma mark - Table View

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
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    Student * tempStudent = [self.students objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",tempStudent.firstName, tempStudent.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",tempStudent.studentID];
    
    return cell;
}

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
    //Get all templte speeches from core data
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Speech" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(isTemplate = %@)",@"true"]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    //All template speeches
    NSArray * allTemplateSpeeches = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([currentStudent.studentSpeech count] != [allTemplateSpeeches count]){
        [self createStudentSpeeches:allTemplateSpeeches forStudent: currentStudent];
    }else{
        [self updateStudentSpeeches:allTemplateSpeeches forStudent: currentStudent];
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
    //Push to evaluation view to start evaluating student speech
    [self.navigationController pushViewController:evaluateSpeech animated:YES];
    
}

#pragma mark Student Speech Create/Update

-(void) createStudentSpeeches:(NSArray *)allTemplateSpeeches forStudent: (Student *)student
{
    NSArray * allStudentSpeeches = [student.studentSpeech allObjects];
    
    if([allStudentSpeeches count] > [allTemplateSpeeches count])
    {
        for(int i = 0; i < [allStudentSpeeches count]; i ++)
        {
            BOOL needToRemoveSpeech = true;
            StudentSpeech * studentSpeech = [allStudentSpeeches objectAtIndex:i];
            Speech * speech = studentSpeech.speech;
            
            for(int j = 0; j < [allTemplateSpeeches count]; j++){
                Speech * speechTemplate = [allTemplateSpeeches objectAtIndex:j];
                
                if([speech.speechType isEqualToString:speechTemplate.speechType]){
                    needToRemoveSpeech = false;
                }
            }
            
            if(needToRemoveSpeech){
                [student removeStudentSpeechObject:studentSpeech];
            }
        }
    }else{
        for(int i = 0; i < [allTemplateSpeeches count]; i ++){
            //Current Speech to add to Student
            Speech * speechTemplate = [allTemplateSpeeches objectAtIndex:i];
            //Create new Student Speech and add it to managedObjectContext
            StudentSpeech * newStudentSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"StudentSpeech" inManagedObjectContext:self.managedObjectContext];
            
            //Create new Speech and add it to managedObjectContext
            Speech * newSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"Speech" inManagedObjectContext:self.managedObjectContext];
            
            //Set new speech type and set as a non template speech
            newSpeech.speechType = speechTemplate.speechType;
            newSpeech.isTemplate = @"false";
            newStudentSpeech.student = student;
            newStudentSpeech.speech = newSpeech;
            
            //Iterate through all Modules within current Speech and add to new Speech
            for(int j = 0; j < [speechTemplate.modules count]; j ++){
                Module * moduleTemplate = [[speechTemplate.modules allObjects]objectAtIndex:j];
                Module * newModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:self.managedObjectContext];
                
                newModule.moduleName = moduleTemplate.moduleName;
                newModule.pointsPossible = moduleTemplate.pointsPossible;
                newModule.speech = newSpeech;
                newModule.orderIndex = moduleTemplate.orderIndex;
                
                //Iterate through all Quick Grades within current Module and add to new Module
                for(int n = 0; n < [moduleTemplate.quickGrade count]; n++){
                    QuickGrade * quickGradeTemplate = [[moduleTemplate.quickGrade allObjects] objectAtIndex:n];
                    QuickGrade * newQuickGrade = [NSEntityDescription insertNewObjectForEntityForName:@"QuickGrade" inManagedObjectContext:self.managedObjectContext];
                    
                    newQuickGrade.quickGradeDescription = quickGradeTemplate.quickGradeDescription;
                    newQuickGrade.isActive = quickGradeTemplate.isActive;
                    newQuickGrade.module = newModule;
                    newQuickGrade.quickGradeID = [NSString stringWithFormat:@"%@", [quickGradeTemplate objectID]];
                    [newModule addQuickGradeObject:newQuickGrade];
                }
                
                //Iterate through all Pre Defined Comments within current Module and add to new Module
                for(int n = 0; n < [moduleTemplate.preDefinedComments count]; n++){
                    PreDefinedComments * preDefinedCommentTemplate = [[moduleTemplate.preDefinedComments allObjects] objectAtIndex:n];
                    PreDefinedComments * newPreDefinedComment = [NSEntityDescription insertNewObjectForEntityForName:@"PreDefinedComments" inManagedObjectContext:self.managedObjectContext];
                    
                    newPreDefinedComment.comment = preDefinedCommentTemplate.comment;
                    newPreDefinedComment.isActive = preDefinedCommentTemplate.isActive;
                    newPreDefinedComment.module = newModule;
                    newPreDefinedComment.commentID = [NSString stringWithFormat:@"%@",[preDefinedCommentTemplate objectID]];
                    [newModule addPreDefinedCommentsObject:newPreDefinedComment];
                }
                //Add new Module to new Speech
                [newSpeech addModulesObject:newModule];
            }
            //Add new StudentSpeech to Student
            [student addStudentSpeechObject:newStudentSpeech];
        }
    }
    
    NSError * error;
    //Save to core data
    if(![self.managedObjectContext save:&error])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Warning!" message: [NSString stringWithFormat:@"Error updating students' speeches.\n%@",error ] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) updateStudentSpeeches:(NSArray*)allTemplateSpeeches forStudent: (Student*)student
{
    NSArray * allStudentSpeeches = [student.studentSpeech allObjects];
    
    for(int i = 0; i < [allStudentSpeeches count]; i ++)
    {
        StudentSpeech * studentSpeech = [allStudentSpeeches objectAtIndex:i];
        Speech * speech = studentSpeech.speech;
        Speech * templateSpeech;
        //Find the Template Speech that corresponds to the Student Speech being updated
        for(int j = 0; j < [allTemplateSpeeches count]; j++){
            Speech * temp = [allTemplateSpeeches objectAtIndex:j];
            if([temp.speechType isEqualToString:speech.speechType]){
                templateSpeech = temp;
            }
        }
        
        NSArray * speechModules = [speech.modules allObjects];
        NSArray * templateModules = [templateSpeech.modules allObjects];
        //Update Modules in current Speech
        for(int j = 0; j < [templateModules count]; j ++){
            Module * currentTemplateModule = [templateModules objectAtIndex:j];
            Module * currentStudentModule;
            //Find the Template Module that corresponds to the Student Module being updated
            for(int a = 0; a < [speechModules count]; a++){
                Module * temp = [speechModules objectAtIndex:a];
                if([temp.moduleName isEqualToString:currentTemplateModule.moduleName] && ![temp.moduleName isEqualToString:@"Penalties"]){
                    currentStudentModule = temp;
                    break;
                }
            }
            
            //Update current Student Module's possible points
            currentStudentModule.pointsPossible = currentTemplateModule.pointsPossible;
            
            NSArray * moduleQuickGrades = [currentStudentModule.quickGrade allObjects];
            NSArray * templateQuickGrades = [currentTemplateModule.quickGrade allObjects];
            
            for(int a = 0; a < [templateQuickGrades count]; a ++){
                
                if([moduleQuickGrades count] != [templateQuickGrades count]){
                    [self createQuickGrades:templateQuickGrades andAddTo:currentStudentModule];
                }else{
                    [self updateQuickGrades:templateQuickGrades andUpdateIn:currentStudentModule];
                }
                
            }
            
            NSArray * modulePreDefinedComments = [currentStudentModule.preDefinedComments allObjects];
            NSArray * templatePreDefinedComments = [currentTemplateModule.preDefinedComments allObjects];
            
            for(int a = 0; a < [templatePreDefinedComments count]; a ++){
                
                if([modulePreDefinedComments count] != [templatePreDefinedComments count]){
                    [self createPreDefinedComments:templatePreDefinedComments andAddTo:currentStudentModule];
                }else{
                    [self updatePreDefinedComments:templatePreDefinedComments andUpdateIn:currentStudentModule];
                }
                
            }
            
        }
        
    }
    //Save Managed Object Context to Core Data. Print out error if can not save
    NSError * error;
    if(![self.managedObjectContext save:&error])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Warning!" message: [NSString stringWithFormat:@"Presentation could not be saved.\n%@",error ] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
//Add Quick Grades that do not exist in current Module
-(void) createQuickGrades: (NSArray *)templateQuickGrades andAddTo: (Module *)studentModule
{
    NSArray * studentQuickGrades = [studentModule.quickGrade allObjects];
    
    if([studentQuickGrades count] > [templateQuickGrades count]){
        for(int i = 0; i < [studentQuickGrades count]; i ++){
            QuickGrade * currentStudentQuickGrade = [studentQuickGrades objectAtIndex:i];
            QuickGrade * currentTemplateQuickGrade;
            BOOL needToRemove = true;
            
            for(int j = 0; j < [templateQuickGrades count]; j ++){
                currentTemplateQuickGrade = [templateQuickGrades objectAtIndex:j];
                
                if([currentTemplateQuickGrade.quickGradeDescription isEqualToString:currentStudentQuickGrade.quickGradeDescription]){
                    needToRemove = false;
                    break;
                }
            }
            if(needToRemove){
                [studentModule removeQuickGradeObject:currentStudentQuickGrade];
            }
        }
        
    }else{
        for(int i = 0; i < [templateQuickGrades count]; i ++){
            QuickGrade * currentTemplateQuickGrade = [templateQuickGrades objectAtIndex:i];
            BOOL needToAdd = true;
            
            for(int j = 0; j < [studentQuickGrades count]; j ++){
                QuickGrade * temp = [studentQuickGrades objectAtIndex:j];
                
                if([temp.quickGradeDescription isEqualToString:currentTemplateQuickGrade.quickGradeDescription]){
                    needToAdd = false;
                    break;
                }
            }
            if(needToAdd){
                QuickGrade * newQuickGrade = [NSEntityDescription insertNewObjectForEntityForName:@"QuickGrade" inManagedObjectContext:self.managedObjectContext];
                
                newQuickGrade.quickGradeDescription = currentTemplateQuickGrade.quickGradeDescription;
                newQuickGrade.isActive = currentTemplateQuickGrade.isActive;
                newQuickGrade.module = studentModule;
                newQuickGrade.quickGradeID = [NSString stringWithFormat:@"%@",[currentTemplateQuickGrade objectID]];
                
                [studentModule addQuickGradeObject:newQuickGrade];
            }
        }
    }
}

//Update Quick Grades that already exists in current Module
-(void) updateQuickGrades: (NSArray *)allQuickGrades andUpdateIn: (Module *)studentModule{
    
}
//Add PreDefinedComments that do not exist in current Module
-(void) createPreDefinedComments: (NSArray *)templatePreDefinedComments andAddTo: (Module *)studentModule
{
    NSArray * studentPreDefinedComments = [studentModule.preDefinedComments allObjects];
    
    if([studentPreDefinedComments count] > [templatePreDefinedComments count]){
        for(int i = 0; i < [studentPreDefinedComments count]; i ++){
            PreDefinedComments * currentStudentPreDefinedComment = [studentPreDefinedComments objectAtIndex:i];
            PreDefinedComments * currentTemplatePreDefinedComment;
            BOOL needToRemove = true;
            
            for(int j = 0; j < [templatePreDefinedComments count]; j ++){
                currentTemplatePreDefinedComment = [templatePreDefinedComments objectAtIndex:j];
                
                if([currentTemplatePreDefinedComment.comment isEqualToString:currentStudentPreDefinedComment.comment]){
                    needToRemove = false;
                    break;
                }
                
            }
            if(needToRemove){
                [studentModule removePreDefinedCommentsObject:currentStudentPreDefinedComment];
            }
        }
        
    }else{
        for(int i = 0; i < [templatePreDefinedComments count]; i ++){
            PreDefinedComments * currentTemplatePreDefinedComment = [templatePreDefinedComments objectAtIndex:i];
            BOOL needToAdd = true;
            
            for(int j = 0; j < [studentPreDefinedComments count]; j ++){
                PreDefinedComments * temp = [studentPreDefinedComments objectAtIndex:j];
                
                if([temp.comment isEqualToString:currentTemplatePreDefinedComment.comment]){
                    needToAdd = false;
                    break;
                }
                
            }
            if(needToAdd){
                PreDefinedComments * newPreDefinedComment = [NSEntityDescription insertNewObjectForEntityForName:@"PreDefinedComments" inManagedObjectContext:self.managedObjectContext];
                
                newPreDefinedComment.comment = currentTemplatePreDefinedComment.comment;
                newPreDefinedComment.isActive = currentTemplatePreDefinedComment.isActive;
                newPreDefinedComment.module = studentModule;
                newPreDefinedComment.commentID = [NSString stringWithFormat:@"%@",[currentTemplatePreDefinedComment objectID]];
                
                [studentModule addPreDefinedCommentsObject:newPreDefinedComment];
            }
        }
    }
}
-(void) updatePreDefinedComments: (NSArray *)templatePreDefinedComments andUpdateIn: (Module *)studentModule{
    
}

#pragma mark Student Order
//Sorts students based on instructor selection in popover
- (void) setStudentOrder: (NSString*) order
{
    if([order isEqualToString: @"Randomize"])
    {
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
    
    for(int i = 0; i < [self.students count]; i ++){
        Student * temp = [self.students objectAtIndex:i];
        [temp setValue:[NSNumber numberWithInt:i] forKeyPath:self.orderIndexType];
    }
    
    NSError * error;
    if(![self.managedObjectContext save:&error]){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Warning!" message: [NSString stringWithFormat:@"Presentation could not be saved.\n%@",error ] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.StudentTable reloadData];
}

# pragma mark Export Order
/*-(void) exportStudentOrder{
    
    //Variables to store origin
    int originX = 20;
    int originY = 15;
    int contentSize = 0;
    int pageSize = 792;
    Section * currentSection = [self.sections objectAtIndex:self.currentPickerSectionIndex];
    //file name
    NSString * fileName = [NSString stringWithFormat:@"Student Order %@-%@",currentSection.sectionName,self.currSpeech ];
    //Get document directory path and create new file with given filename
    NSString *path = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:fileName];
    //create pdf context
    UIGraphicsBeginPDFContextToFile(path, CGRectZero, nil);
    //set pdf font
    UIFont * font = [UIFont fontWithName:@"Times" size:12];
    
    // Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    // Set text alignment
    paragraphStyle.alignment = NSTextAlignmentRight;
    //Set attributes based type of data
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
    
  
    
    //Begin new page
    UIGraphicsBeginPDFPage();
    
    for(int i = 0; i < [self.students count]; i ++){
        Student * currentStudent = [self.students objectAtIndex:i];
        //Draw Student Name at top of document
        [ [NSString stringWithFormat:@"%@ %@",currentStudent.firstName,currentStudent.lastName] drawAtPoint:CGPointMake(originX, originY) withAttributes:attributes];
        contentSize += 15;
        //Go to a new line
        originY += 15;
    }
    NSError *error;
    if(![self.managedObjectContext save:&error]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Student Order could not upload" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Student Order uploaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    UIGraphicsEndPDFContext();
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        
    }else if( [[DBSession sharedSession] isLinked]){
        
        NSString *destPath = [NSString stringWithFormat:@"Student Order %@-%@",currentSection.sectionName,self.currSpeech ];
        [self.restClient loadMetadata:destPath];
        [self.restClient deletePath:destPath];
        [self.restClient uploadFile: fileName toPath: destPath withParentRev:nil fromPath:path];
    }
    
    
}
*/
# pragma mark Unwind Segues
-(IBAction)UnwindFromFinalizeToStudentSelection:(UIStoryboardSegue *)unwindSegue
{
    
}

- (IBAction)UnwindFromOrderPopoverToStudentSelectionAndRandomize:(UIStoryboardSegue *)unwindSegue
{
    [self setStudentOrder:@"Randomize"];
}
- (IBAction)UnwindFromOrderPopoverToStudentSelectionAndAlphabetize:(UIStoryboardSegue *)unwindSegue
{
    [self setStudentOrder:@"Alphabetize"];
}

#pragma mark Alert View
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark Dropbox
- (DBRestClient *)restClient {
    if (!restClient) {
        restClient =
        [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"File has been uploaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"File has been uploaded successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}
@end