//
//  EditPersuasiveVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditPersuasiveVC.h"
#define moduleTableTag 1
#define leftTableTag 2
#define rightTableTag 3
#define commentsTableTag 4
@interface EditPersuasiveVC ()

@end

@implementation EditPersuasiveVC
@synthesize managedObjectContext, modules, quickGrades, preDefinedComments;
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
                                   entityForName:@"Speech" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if (self.sendingButtonTag == 13) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Persuasive"];
        [fetchRequest setPredicate:predicate];
    }
    else if (self.sendingButtonTag == 14)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Informative"];
        [fetchRequest setPredicate:predicate];
    }
    else if (self.sendingButtonTag == 15)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Interpersonal"];
        [fetchRequest setPredicate:predicate];
    }
    
    
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    NSLog(@"Count %d", count);

    
    // persuasive speech hasn't been added yet DEBUG CODE
    if(count == 0)
    {
        Speech *newSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"Speech" inManagedObjectContext:managedObjectContext];
        newSpeech.speechType = @"Persuasive";
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        // Add Modules to Core Data
        Module *introModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        introModule.moduleName = @"Introduction";
        introModule.orderIndex = 0;
        introModule.speech = newSpeech;
        
        Module *orgModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        orgModule.moduleName = @"Organization";
        orgModule.orderIndex = [NSNumber numberWithInt:1];
        orgModule.speech = newSpeech;
        
        Module *reasonModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        reasonModule.moduleName = @"Reasoning and Evidence";
        reasonModule.orderIndex = [NSNumber numberWithInt:2];
        reasonModule.speech = newSpeech;
        
        Module *presentationModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        presentationModule.moduleName = @"Presentation Aids";
        presentationModule.orderIndex = [NSNumber numberWithInt:3];
        presentationModule.speech = newSpeech;
       
        Module *voiceModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        voiceModule.moduleName = @"Voice and Language";
        voiceModule.orderIndex = [NSNumber numberWithInt:4];
        voiceModule.speech = newSpeech;
       
        Module *physicalModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        physicalModule.moduleName = @"Physical Delivery";
        physicalModule.orderIndex = [NSNumber numberWithInt:5];
        physicalModule.speech = newSpeech;
       
        Module *conclusionModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        conclusionModule.moduleName = @"Conclusion";
        conclusionModule.orderIndex = [NSNumber numberWithInt:6];
        conclusionModule.speech = newSpeech;
        
        NSSet *moduleSet = [NSSet setWithObjects:introModule, orgModule, reasonModule, presentationModule, voiceModule, physicalModule, conclusionModule, nil];
        // Add Module to current Speech
        [newSpeech addModules:moduleSet];
        
        // Save context
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        self.currSpeech = newSpeech;
     }
    else
    {
        self.currSpeech = [[NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]] objectAtIndex:0];
    }
    
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
    self.modules = [NSMutableArray arrayWithArray:[self.currSpeech.modules sortedArrayUsingDescriptors:descriptors]];

    if ([self.moduleLabel.text isEqualToString:@"Module Label"]) {
        self.moduleLabel.text = @"Introduction";
        self.currModule = [self.modules objectAtIndex:0];
        self.quickGrades = [NSMutableArray arrayWithArray:[self.currModule.quickGrade allObjects]];
        [self.quickTable1 reloadData];
        [self.quickTable2 reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Magic to make the two uitableviews scroll as one
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    beingScrolled_ = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(beingScrolled_ == nil && scrollView.tag != moduleTableTag && scrollView.tag != commentsTableTag)
        beingScrolled_ = scrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *otherScrollView = (scrollView == self.quickTable1) ? self.quickTable2 : self.quickTable1;
    if(otherScrollView != beingScrolled_ && scrollView.tag != moduleTableTag && scrollView.tag != commentsTableTag)
    {
        [otherScrollView setContentOffset:[scrollView contentOffset] animated:NO];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (tableView.tag) {
        case moduleTableTag:
           
            self.currModule = [modules objectAtIndex:indexPath.row];
            self.quickGrades = [NSMutableArray arrayWithArray:[self.currModule.quickGrade allObjects]];
            self.moduleLabel.text = self.currModule.moduleName;
            [self.quickTable1 reloadData];
            [self.quickTable2 reloadData];
            NSLog(@"Module: %@", self.currModule.moduleName);
            break;
        case leftTableTag:
            break;
        case rightTableTag:
            break;
        case commentsTableTag:
            break;
            
        default:
            break;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL editable = NO;
    
    switch (tableView.tag) {
        case moduleTableTag:
            editable = NO;
            break;
        case leftTableTag:
            editable = YES;
            break;
        case rightTableTag:
            editable = YES;
            break;
        case commentsTableTag:
            editable = YES;
            break;
            
        default:
            break;
    }
    
    return editable;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        Student *studentToDelete = [self.students objectAtIndex:indexPath.row];
//        [self.students removeObjectAtIndex:indexPath.row];
//        
//        //Remove student from section
//        [studentToDelete.section removeStudentsObject:studentToDelete];
//        
//        // You might want to delete the object from your Data Store if you’re using CoreData
//        [managedObjectContext deleteObject:studentToDelete];
//        NSError *error;
//        if (![managedObjectContext save:&error]) {
//            NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
//        }
        
        // Animate the deletion
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
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
    NSInteger rows;
    if (tableView.tag == moduleTableTag)//module tableview
    {
        rows = [modules count];
    }
    else
    {
        // If the array has an odd length then integer division will result in 1 to few rows for the right table (quickTable2)
        if ([quickGrades count] % 2 != 0)
            rows = [quickGrades count]/2 + 1;
        else
            rows = [quickGrades count]/2;
    }
    
    NSLog(@"Tag: %d Rows: %d", tableView.tag, rows);
    return rows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (tableView.tag == moduleTableTag) {
        [self.moduleTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:38/255.0f green:38/255.0f blue:38/255.0f alpha:1.0f];;

        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:0/255.0f green:112/255.0f blue:83/255.0f alpha:1.0f];
        cell.selectedBackgroundView =  customColorView;

        cell.textLabel.textColor = [UIColor whiteColor];
        Module *tempModule = [modules objectAtIndex:indexPath.row];
        cell.textLabel.text = tempModule.moduleName;
    }
    else if (tableView.tag == leftTableTag ) {
        // If the array has an odd length that means that the tables will not be the same size. In that case the
        // left table will use half of the array length minus 1. The exception to this rule is when there is
        // only one element in the array, in that case we will only use the left table.
        if ([quickGrades count] % 2 != 0 && [quickGrades count] != 1) {
            
            if (indexPath.row < [quickGrades count]/2) { // array is odd so use up to n-1 rows
                [self.quickTable1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                QuickGrade *tempQuickGrade = [quickGrades objectAtIndex:indexPath.row];
                cell.textLabel.text = tempQuickGrade.quickGradeDescription;

            }
        }
        else // the array is even or there is only one element in the array so we're clear to use all rows
        {
            [self.quickTable1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            QuickGrade *tempQuickGrade = [quickGrades objectAtIndex:indexPath.row];
            cell.textLabel.text = tempQuickGrade.quickGradeDescription;

        }
        
    }
    else if (tableView.tag == rightTableTag)
    {
        
        if([quickGrades count] == 1) // when the array only has one object only dequeue a cell
        {
            [self.quickTable2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
        }
        else
        {
            [self.quickTable2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            QuickGrade *tempQuickGrade = [quickGrades objectAtIndex:[quickGrades count]/2 + indexPath.row];
            cell.textLabel.text = tempQuickGrade.quickGradeDescription;
        }
        
        
    }
    else if (tableView.tag == commentsTableTag)
    {
        [self.commentsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    return cell;
        
}

# pragma mark - Unwind

- (IBAction)unwindToQuickGrades:(UIStoryboardSegue *)sender
{
    self.addQuickGradePopover = nil;
    AddQuickGradeVC *addQuickGradeVC = (AddQuickGradeVC *)sender.sourceViewController;
    
    NSString *quickGradeDescription = addQuickGradeVC.quickGradeDescriptionTF.text;
    
    // If NOT blank and NOT whitespace
    if(![quickGradeDescription length] == 0 && ![[quickGradeDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        
        // Check if there is already a quickGrade in the current module
        BOOL quickGradeExists = NO;
        for (QuickGrade *q in quickGrades)
        {
            NSLog(@"Quick Grade: %@", q.quickGradeDescription);
            if ([q.quickGradeDescription isEqualToString:quickGradeDescription]) {
                quickGradeExists = YES;
                break;
            }
        }
        
        
        if(!quickGradeExists)
        {
            
            // Add QuickGrade to Core Data
            QuickGrade *newQuickGrade = [NSEntityDescription insertNewObjectForEntityForName:@"QuickGrade" inManagedObjectContext:managedObjectContext];
            newQuickGrade.quickGradeDescription = quickGradeDescription;
            newQuickGrade.module = self.currModule;
            newQuickGrade.score = 0;
            newQuickGrade.isActive = NO;
            [self.currModule addQuickGradeObject:newQuickGrade];
            
            NSError *error;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
            self.quickGrades = [NSMutableArray arrayWithArray:[self.currModule.quickGrade allObjects]];
            [self.quickTable1 reloadData];
            [self.quickTable2 reloadData];
        }
        else{
            NSLog(@"Quick Grade already exists");
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Error"
                                  message: @"A Quick Grade with this name already exists"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }

}

- (IBAction)unwindToPredefinedComments:(UIStoryboardSegue *)sender
{
    
}
- (void) dismissPopover:(NSObject *)yourDataToTransfer
{ /* Dismiss you popover here and process data */

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addToModuleSegue"]) {
        UIStoryboardPopoverSegue *pop = (UIStoryboardPopoverSegue*)segue;
        pop.popoverController.delegate = self;
        AddToModuleVC *addToModuleVC = [segue destinationViewController];
        NSInteger tag = [(UIButton *)sender tag];
        
    }
}

@end
