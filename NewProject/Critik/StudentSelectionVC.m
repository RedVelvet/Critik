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
        self.sections = [[NSMutableArray alloc]init];
        self.students = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.title = self.currSpeech;
    
    
    //Create a managedObjectContext and set equal to AppDelegates ManagedObjectContext.
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    
    //initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting the entity name to grab from Core Data.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    //Setting sections equal to the objects grabbed from Core Data with the entity name 'Section'
    self.sections = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    //Sort Students array based on what has been set.
    
    if([self.sections count] >1){
        
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionName" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        self.sections = [NSMutableArray arrayWithArray:[self.sections sortedArrayUsingDescriptors:descriptors]];
    }
    
    //Fills the students table with the first section data of the pickerview
    Section * temp = [self.sections objectAtIndex:0];
    NSSet * set = temp.students;
    self.students = [NSMutableArray arrayWithArray:[set allObjects]];
    
    //If students table hasn't been ordered, then set to alphabetical order by last name.
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

    StudentEvaluationVC * evaluateSpeech = [self.storyboard instantiateViewControllerWithIdentifier:@"Student Evaluation"];
    
    Student * temp = [self.students objectAtIndex:indexPath.row];
    evaluateSpeech.currentStudent = temp;
    evaluateSpeech.currentSpeechName = self.currSpeech;

    
    [self.navigationController pushViewController:evaluateSpeech animated:YES];
    
}

//Sorts students based on instructor selection in popover
- (IBAction) setStudentOrder: (id) sender
{
    if([sender tag] == 1){
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

@end
