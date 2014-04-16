//
//  EditPersuasiveVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditSpeechVC.h"
#define moduleTableTag 1
#define leftTableTag 2
#define rightTableTag 3
#define commentsTableTag 4
#define kOFFSET_FOR_KEYBOARD 352.0
@interface EditSpeechVC ()

@end

@implementation EditSpeechVC
@synthesize managedObjectContext, modules, quickGrades, preDefinedComments;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View

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
    
    // Which speech was selected
    if (self.sendingButtonTag == 13) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Informative"];
        [fetchRequest setPredicate:predicate];
        self.navBar.title = @"Edit: Informative";
    }
    else if (self.sendingButtonTag == 14)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Persuasive"];
        [fetchRequest setPredicate:predicate];
        self.navBar.title = @"Edit: Persuasive";
    }
    else if (self.sendingButtonTag == 15)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Interpersonal"];
        [fetchRequest setPredicate:predicate];
        self.navBar.title = @"Edit: Interpersonal";
    }
    
    
    NSError *error;
    NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    NSLog(@"Count %d", count);

    
    //  speech hasn't been added yet DEBUG CODE
    if(count == 0)
    {
        Speech *newSpeech = [NSEntityDescription insertNewObjectForEntityForName:@"Speech" inManagedObjectContext:managedObjectContext];
        
        switch (self.sendingButtonTag) {
            case 13:
                newSpeech.speechType = @"Informative";
                break;
            case 14:
                newSpeech.speechType = @"Persuasive";
                break;
            case 15:
                newSpeech.speechType = @"Interpersonal";
                break;
            default:
                break;
        }
        
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        // Add Modules to Core Data
        Module *introModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        introModule.moduleName = @"Introduction";
        introModule.orderIndex = [NSNumber numberWithInt:0];
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
        
        Module *penaltiesModule = [NSEntityDescription insertNewObjectForEntityForName:@"Module" inManagedObjectContext:managedObjectContext];
        penaltiesModule.moduleName = @"Penalties";
        penaltiesModule.orderIndex = [NSNumber numberWithInt:7];
        penaltiesModule.speech = newSpeech;
        
        NSSet *moduleSet = [NSSet setWithObjects:introModule, orgModule, reasonModule, presentationModule, voiceModule, physicalModule, conclusionModule, penaltiesModule, nil];
        // Add Module to current Speech
        [newSpeech addModules:moduleSet];
        newSpeech.isTemplate = @"true";
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

    // The view just opened so lets select introduction and setup the tables
    if ([self.moduleLabel.text isEqualToString:@"Module Label"]) {
        self.moduleLabel.text = @"Introduction";
        self.currModule = [self.modules objectAtIndex:0];
        self.pointTF.text = [NSString stringWithFormat:@"%@",self.currModule.pointsPossible];
        self.quickGrades = [NSMutableArray arrayWithArray:[self.currModule.quickGrade allObjects]];
        self.preDefinedComments = [NSMutableArray arrayWithArray:[self.currModule.preDefinedComments allObjects]];
        NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self splitQuickGrades];
        [self.moduleTable selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
        [self.commentsTable reloadData];
        [self.quickTable1 reloadData];
        [self.quickTable2 reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewDidAppear:(BOOL)animated {
//    
//    //sets the Introduction module as the first selected module
//    NSIndexPath * indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//    [self.moduleTable selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
//}

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
            [self.quickGrades removeAllObjects];
            [self.quickGrades1 removeAllObjects];
            [self.quickGrades2 removeAllObjects];
            self.currModule = [modules objectAtIndex:indexPath.row];
            self.quickGrades = [NSMutableArray arrayWithArray:[self.currModule.quickGrade allObjects]];
            [self splitQuickGrades];
            self.preDefinedComments = [NSMutableArray arrayWithArray:[self.currModule.preDefinedComments allObjects]];
            self.moduleLabel.text = self.currModule.moduleName;
            self.pointTF.text = [NSString stringWithFormat:@"%@",self.currModule.pointsPossible];
            [self.quickTable1 reloadData];
            [self.quickTable2 reloadData];
            [self.commentsTable reloadData];
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
        
        if (tableView.tag != moduleTableTag) { // can't delete from the module table
            if (tableView.tag == leftTableTag)
            {
                QuickGrade *quickToDelete = [self.quickGrades1 objectAtIndex:indexPath.row];
                NSLog(@"index: %@", quickToDelete.quickGradeDescription);
                [self.quickGrades removeObject:quickToDelete];
                [self.quickGrades1 removeObject:quickToDelete];
                // Remove the comment from module
                [quickToDelete.module removeQuickGradeObject:quickToDelete];
                
                // Delete the object from the data store
                [managedObjectContext deleteObject:quickToDelete];
                NSError *error;
                if(![managedObjectContext save:&error])
                {
                    NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Error"
                                          message: @"Quick Grade could not be saved"
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else if (tableView.tag == rightTableTag)
            {
                QuickGrade *quickToDelete = [self.quickGrades2 objectAtIndex:indexPath.row];
                NSLog(@"index: %@", quickToDelete.quickGradeDescription);
                [self.quickGrades removeObject:quickToDelete];
                [self.quickGrades2 removeObject:quickToDelete];
                
                // Remove the comment from module
                [quickToDelete.module removeQuickGradeObject:quickToDelete];
                
                // Delete the object from the data store
                [managedObjectContext deleteObject:quickToDelete];
                NSError *error;
                if(![managedObjectContext save:&error])
                {
                    NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Error"
                                          message: @"Quick Grade could not be saved"
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                // Delete the row from the data source
                PreDefinedComments *predefToDelete = [self.preDefinedComments objectAtIndex:indexPath.row];
                [self.preDefinedComments removeObjectAtIndex:indexPath.row];
                
                // Remove the comment from module
                [predefToDelete.module removePreDefinedCommentsObject:predefToDelete];
                
                // Delete the object from the data store
                [managedObjectContext deleteObject:predefToDelete];
                NSError *error;
                if(![managedObjectContext save:&error])
                {
                    NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Error"
                                          message: @"Comment could not be deleted"
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
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
    NSInteger rows = 0;
    if (tableView.tag == moduleTableTag)//module tableview
    {
        rows = [self.modules count]-1; //won't display penalties
    }
    else if (tableView.tag == leftTableTag)
    {

        rows = [self.quickGrades1 count];
    }
    else if (tableView.tag == rightTableTag)
    {
        rows = [self.quickGrades2 count];
    }
    else if (tableView.tag == commentsTableTag)
    {
        rows = [self.preDefinedComments count];
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
        [self.quickTable1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        QuickGrade *tempQuickGrade = [self.quickGrades1 objectAtIndex:indexPath.row];
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:[tempQuickGrade.isActive boolValue]animated:NO];
        
        // associate table tag and object with button for later use in updating isActive
        switchView.tag = leftTableTag;
        objc_setAssociatedObject(switchView, "obj", tempQuickGrade, OBJC_ASSOCIATION_ASSIGN);
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//        cell.textLabel.text = tempQuickGrade.quickGradeDescription;
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 185, 30)];
        tf.adjustsFontSizeToFitWidth = YES;
        tf.textColor = [UIColor blackColor];
        tf.text = tempQuickGrade.quickGradeDescription;
        tf.backgroundColor = [UIColor whiteColor];
        tf.tintColor = [UIColor blueColor];
        tf.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        tf.delegate = self;
        tf.tag = leftTableTag;
        tf.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [tf setEnabled: YES];
        objc_setAssociatedObject(tf, "obj1", tempQuickGrade, OBJC_ASSOCIATION_ASSIGN);
        [cell addSubview:tf];
        


    }
    else if (tableView.tag == rightTableTag)
    {
        
        [self.quickTable2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        QuickGrade *tempQuickGrade = [self.quickGrades2 objectAtIndex:indexPath.row];
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:[tempQuickGrade.isActive boolValue]animated:NO];
        
        // associate table tag and object with button for later use in updating isActive
        switchView.tag = leftTableTag;
        objc_setAssociatedObject(switchView, "obj", tempQuickGrade, OBJC_ASSOCIATION_ASSIGN);
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//        cell.textLabel.text = tempQuickGrade.quickGradeDescription;
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 185, 30)];
        tf.adjustsFontSizeToFitWidth = YES;
        tf.textColor = [UIColor blackColor];
        tf.tintColor = [UIColor blueColor];
        tf.text = tempQuickGrade.quickGradeDescription;
        tf.backgroundColor = [UIColor whiteColor];
        tf.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        tf.delegate = self;
        tf.tag = rightTableTag;
        tf.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [tf setEnabled: YES];
        objc_setAssociatedObject(tf, "obj1", tempQuickGrade, OBJC_ASSOCIATION_ASSIGN);
        [cell addSubview:tf];

        
    }
    else if (tableView.tag == commentsTableTag)
    {
        [self.commentsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        PreDefinedComments *tempPredef = [preDefinedComments objectAtIndex:indexPath.row];
        UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:[tempPredef.isActive boolValue] animated:NO];
        
        // associate table tag and object with button for later use in updating isActive
        switchView.tag = commentsTableTag;
        objc_setAssociatedObject(switchView, "obj", tempPredef, OBJC_ASSOCIATION_ASSIGN);
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//        cell.textLabel.text = tempPredef.comment;
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 185, 30)];
        tf.adjustsFontSizeToFitWidth = YES;
        tf.textColor = [UIColor blackColor];
        tf.tintColor = [UIColor blueColor];
        tf.text = tempPredef.comment;
        tf.backgroundColor = [UIColor whiteColor];
        tf.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        tf.delegate = self;
//        [tf setPlaceholder:@"commentsTableTag"];
        tf.tag = commentsTableTag;
        tf.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [tf setEnabled: YES];
        objc_setAssociatedObject(tf, "obj1", tempPredef, OBJC_ASSOCIATION_ASSIGN);
        [cell addSubview:tf];
    }
    
    return cell;
        
}

# pragma mark - Popover Handling

- (void) dismissPopover:(NSArray *)addContentArray
{
    /* Dismiss your popover here and process data */
    NSLog(@"Popover: %@ Content: %@", [addContentArray objectAtIndex:0], [addContentArray objectAtIndex:1]);
    [popover dismissPopoverAnimated:YES];
    NSString *fromPopover = [addContentArray objectAtIndex:0];
    NSString *content = [addContentArray objectAtIndex:1];
    
    if ([fromPopover isEqualToString:@"Add Comment"]) { // Adding a predefined comment
        
        // If NOT blank and NOT whitespace
        if(![content length] == 0 && ![[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        {
            // Check if there is already a predef comment in the current module
            BOOL predefExists = NO;
            for (PreDefinedComments *p in preDefinedComments)
            {
                NSLog(@"PreDefined Comments: %@", p.comment);
                if ([p.comment caseInsensitiveCompare:content] == NSOrderedSame) {
                    predefExists = YES;
                    break;
                }
            }
            
            
            if(!predefExists)
            {
                
                // Add predef to Core Data
                PreDefinedComments *newPredef = [NSEntityDescription insertNewObjectForEntityForName:@"PreDefinedComments" inManagedObjectContext:managedObjectContext];
                newPredef.comment = content;
                newPredef.module = self.currModule;

                [self.currModule addPreDefinedCommentsObject:newPredef];
                
                NSError *error;
                if (![managedObjectContext save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Error"
                                          message: @"Comment could not be saved"
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                self.preDefinedComments = [NSMutableArray arrayWithArray:[self.currModule.preDefinedComments allObjects]];
                [self.commentsTable reloadData];
            }
            else{
                NSLog(@"Comment already exists");
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Error"
                                      message: @"A Comment with this name already exists"
                                      delegate: nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                [alert show];
            }

            
            
        }
    }
    else if ([fromPopover isEqualToString:@"Add Quick Grade"]) // Adding a quick grade
    {
        // If NOT blank and NOT whitespace
        if(![content length] == 0 && ![[content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
        {
            // Check if there is already a quickGrade in the current module
            BOOL quickGradeExists = NO;
            for (QuickGrade *q in quickGrades)
            {
                NSLog(@"Quick Grade: %@", q.quickGradeDescription);
                if ([q.quickGradeDescription caseInsensitiveCompare:content] == NSOrderedSame) {
                    quickGradeExists = YES;
                    break;
                }
            }
            
            
            if(!quickGradeExists)
            {
                
                // Add QuickGrade to Core Data
                QuickGrade *newQuickGrade = [NSEntityDescription insertNewObjectForEntityForName:@"QuickGrade" inManagedObjectContext:managedObjectContext];
                newQuickGrade.quickGradeDescription = content;
                newQuickGrade.module = self.currModule;
                newQuickGrade.score = [NSNumber numberWithInt:0];

                [self.currModule addQuickGradeObject:newQuickGrade];
                
                NSError *error;
                if (![managedObjectContext save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle: @"Error"
                                          message: @"Quick Grade could not be saved"
                                          delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                self.quickGrades = [NSMutableArray arrayWithArray:[self.currModule.quickGrade allObjects]];
                [self splitQuickGrades];
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"addToModuleSegue"]) {
        popover = [(UIStoryboardPopoverSegue *)segue popoverController];

        AddToModuleVC *addToModuleVC = (AddToModuleVC *)popover.contentViewController;
        
        NSInteger tag = [(UIButton *)sender tag];
        NSLog(@"Sending button tag: %d", tag);
        addToModuleVC.delegate = self;
        addToModuleVC.sendingButtonTag = tag;
        
    }
}

# pragma mark - Utility
- (void) switchChanged:(id)sender{
    UISwitch* switchControl = sender;
    if (switchControl.tag == leftTableTag || switchControl.tag == rightTableTag) {
        NSManagedObject *temp = objc_getAssociatedObject(sender, "obj");
        NSNumber *boolValue = (switchControl.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0]);
        [temp setValue:boolValue forKey:@"isActive"];
        NSLog( @"The switch is %@ for table: %d which is %@", switchControl.on ? @"ON" : @"OFF", switchControl.tag,  boolValue);
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    } else if (switchControl.tag == commentsTableTag)
    {
        NSManagedObject *temp = objc_getAssociatedObject(sender, "obj");
        NSNumber *boolValue = (switchControl.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0]);
        [temp setValue:boolValue forKey:@"isActive"];
        NSLog( @"The switch is %@ for table: %d which is %@", switchControl.on ? @"ON" : @"OFF", switchControl.tag,  boolValue);
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
}

- (void) splitQuickGrades
{
//    if ([self.quickGrades count] != 1) {
    
        NSRange someRange;
        
        someRange.location = 0;
        someRange.length = [self.quickGrades count] / 2;
        self.quickGrades2 = [NSMutableArray arrayWithArray:[self.quickGrades subarrayWithRange:someRange]];
    
        
        someRange.location = someRange.length;
        someRange.length = [self.quickGrades count] - someRange.length;
        self.quickGrades1 = [NSMutableArray arrayWithArray:[self.quickGrades subarrayWithRange:someRange]];
    
//    }
//    else
//    {
//        [self.quickGrades1 addObject:[self.quickGrades objectAtIndex:0]];
//    }
}

# pragma mark - Textfield
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    NSLog(@"textFieldDidBeginEditing");
    NSLog(@"textfield tag: %d",sender.tag);
    NSLog(@"origin: %f",self.view.frame.origin.y);
    if (sender.tag == commentsTableTag)
    {
        NSLog(@"origin: %f",self.view.frame.origin.y);
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if (textField.tag == leftTableTag || textField.tag == rightTableTag) {
        QuickGrade *temp = (QuickGrade*)objc_getAssociatedObject(textField, "obj1");
        
        [temp setValue:textField.text forKey:@"quickGradeDescription"];
        //        NSLog( @"The switch is %@ for table: %d which is %@", switchControl.on ? @"ON" : @"OFF", switchControl.tag,  boolValue);
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    } else if (textField.tag == commentsTableTag)
    {
        PreDefinedComments *temp = (PreDefinedComments*)objc_getAssociatedObject(textField, "obj1");
        [temp setValue:textField.text forKey:@"comment"];
        //        NSLog( @"The switch is %@ for table: %d which is %@", switchControl.on ? @"ON" : @"OFF", switchControl.tag,  boolValue);
        NSError *error = nil;
        // Save the object to persistent store
        if (![managedObjectContext save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
    
    return YES;
}

- (IBAction)pointTFDidEndEditing:(id)sender {
    NSLog(@"Points tf changed to %@", self.pointTF.text);
    // If NOT blank and NOT whitespace
    if(![self.pointTF.text length] == 0 && ![[self.pointTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        NSNumber* numberToSave = [NSNumber numberWithInteger:[self.pointTF.text integerValue]];
        if (numberToSave && [numberToSave intValue] > 0) {
            NSManagedObject *temp = self.currModule;
            NSNumberFormatter *numValue = [[NSNumberFormatter alloc]init];
            [numValue setNumberStyle:NSNumberFormatterNoStyle];
            [temp setValue:[numValue numberFromString: self.pointTF.text] forKey:@"pointsPossible"];
            NSError *error = nil;
            // Save the object to persistent store
            if (![managedObjectContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
        }
        else
        {
            NSLog(@"%@ is incorrect in the points textfield",numberToSave);
            [self.pointTF setText:@"0"];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Error"
                                  message: @"Enter a positive number in the points field"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

#pragma mark - Keyboard
- (void) keyboardWasShown:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    // Portrait:    Height: 264.000000  Width: 768.000000
    // Landscape:   Height: 1024.000000 Width: 352.000000
}
-(void)keyboardWillShow {
    NSLog(@"keyboardwillshow");
    // Animate the current view out of the way
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if (self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
}

-(void)keyboardWillHide {
    NSLog(@"keyboardwillhide");
    NSLog(@"origin: %f",self.view.frame.origin.y);
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}
@end
