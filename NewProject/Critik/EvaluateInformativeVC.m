//
//  EvaluateInformativeVC.m
//  Critik
//
//  Created by Dalton Decker on 2/25/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EvaluateInformativeVC.h"

@interface EvaluateInformativeVC ()

@end

@implementation EvaluateInformativeVC

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
    
    self.currentStudent = [[Student alloc]init];
    self.SpeechSections = [NSArray arrayWithObjects: @"Introduction",@"Organization",@"Reasoning and Evidence",@"Presentation Aid",@"Voice and Language",@"Physical Delivery",@"Conclusion",nil];
    [self.SpeechSectionsTable reloadData];
    
	// Do any additional setup after loading the view.
   // NSLog(self.currentStudent.firstName);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//sets the number of sections in a TableView
- (int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//sets the number of rows in a TableView
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

//creates the cells with the appropriate information displayed in them. Name, Founding Year, Population, and Area.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    
    UIView * selectedBackgroundView = [[UIView alloc]init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:117.0/255.0 blue:84.0/255.0 alpha:1.0]]; // set color here
    cell.selectedBackgroundView = selectedBackgroundView;
    
    cell.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    NSString *cellTitle = [self.SpeechSections objectAtIndex:indexPath.row];
    cell.textLabel.text = cellTitle;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

@end
