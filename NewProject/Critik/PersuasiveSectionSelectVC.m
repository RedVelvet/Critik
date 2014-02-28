//
//  PersuasiveSectionSelectVC.m
//  Critik
//
//  Created by Dalton Decker on 2/21/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "PersuasiveSectionSelectVC.h"


@interface PersuasiveSectionSelectVC()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation PersuasiveSectionSelectVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.sections = [[NSArray alloc]init];
        self.students = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    
    self.sections = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    if([self.sections count] >1){
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionName" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        self.sections = [NSMutableArray arrayWithArray:[self.sections sortedArrayUsingDescriptors:descriptors]];
    }
    
    //Fills the students table with the first section data of the pickerview
    Section * temp = [self.sections objectAtIndex:0];
    NSSet * set = temp.students;
    self.students = [NSMutableArray arrayWithArray:[set allObjects]];
    
    //Sorts students table by Last Name
    if([self.students count] >1){
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        self.students = [NSMutableArray arrayWithArray:[self.students sortedArrayUsingDescriptors:descriptors]];
    }
    
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

-(void) pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Section * temp = [self.sections objectAtIndex:row];
    NSSet * set = temp.students;
    self.students = [NSArray arrayWithArray:[set allObjects]];
    //    Student * student = [[Student alloc]init];
    //    student.firstName = @"Dalton";
    //    self.students = [NSArray arrayWithObject:student];
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
    
    Student * tempStudent = [self.students objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",tempStudent.firstName, tempStudent.lastName];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EvaluatePersuasiveVC * evaluateSpeech = [self.storyboard instantiateViewControllerWithIdentifier:@"persuasive"];
    //evaluateSpeech.currentStudent = [self.StudentTable indexPathForSelectedRow];
    [self.navigationController pushViewController:evaluateSpeech animated:YES];
    
}

@end
