//
//  EditInformativeVC.m
//  Critik
//
//  Created by Dalton Decker on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditInformativeVC.h"

@interface EditInformativeVC ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation EditInformativeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //[self.ScrollView setContentSize:CGSizeMake(320, 808)];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"QuickGrade" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    
    if(self.quickGrades == nil){
        //self.quickGrades = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        self.quickGrades = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
        
    }
    
    entity = [NSEntityDescription entityForName:@"PreDefinedComments" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    if([self.preDefinedComments count] == 0){
        //self.preDefinedComments = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
        
        self.preDefinedComments = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];

    }
    if([self.SpeechSections count] == 0)
    {
        self.SpeechSections = [NSArray arrayWithObjects: @"Introduction",@"Organization",@"Reasoning and Evidence",@"Presentation Aid",@"Voice and Language",@"Physical Delivery",@"Conclusion",nil];
    }
    [self.QuickGradeTable1 reloadData];
    [self.QuickGradeTable2 reloadData];
    [self.SpeechSectionsTable reloadData];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if(tableView.tag == 0){
        return [self.quickGrades count]/2;
    }
    if(tableView.tag == 1){
        return [self.preDefinedComments count];
    }else{
        return [self.SpeechSections count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    //left QuickGrades Table
    if(tableView.tag == 0)
    {
        //First half of QuickGrades is placed in the left table
        if([self.quickGrades count]/2 > indexPath.row)
        {
        
            QuickGrade * temp;
            temp.quickGradeDescription = [self.quickGrades objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];
        }
        
    }
    
    //Right QuickGrades Table
    if (tableView.tag == 1)
    {
        //Second half of QuickGrades is placed in the right table
        if([self.quickGrades count]/2 < indexPath.row)
        {
            
            QuickGrade * temp;
            temp.quickGradeDescription= [self.quickGrades objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.quickGradeDescription];
        }
        
    }else{
        
        PreDefinedComments * temp;
//        temp.preDefComments= [self.preDefinedComments objectAtIndex:indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@",temp.preDefComments];
        
        
    }
    return cell;
    
}


//Allows QuickGrades tables scroll together
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{

    if (scrollView == self.QuickGradeTable1) {
        self.QuickGradeTable2.contentOffset = scrollView.contentOffset;
    } else if(scrollView == self.QuickGradeTable2){
        self.QuickGradeTable1.contentOffset = scrollView.contentOffset;
    }
    
}

@end
