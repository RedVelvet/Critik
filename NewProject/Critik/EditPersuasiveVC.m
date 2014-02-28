//
//  EditPersuasiveVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditPersuasiveVC.h"

@interface EditPersuasiveVC ()

@end

@implementation EditPersuasiveVC

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
    if(beingScrolled_ == nil)
        beingScrolled_ = scrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *otherScrollView = (scrollView == self.quickTable1) ? self.quickTable2 : self.quickTable1;
    if(otherScrollView != beingScrolled_)
    {
        [otherScrollView setContentOffset:[scrollView contentOffset] animated:NO];
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
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (tableView.tag == 1) {
        
        
        [self.quickTable1 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        
//        if([students count] != 0){
//            cell.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:100.0/255.0 blue:30.0/255.0 alpha:1.0];
//            cell.textLabel.textColor = [UIColor whiteColor];
//        }
//        else{
//            cell.backgroundColor = [UIColor whiteColor];
//            cell.textLabel.textColor = [UIColor blackColor];
//        }
//        Student *tempStudent = [self.students objectAtIndex:indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", tempStudent.firstName, tempStudent.lastName];
//        cell.detailTextLabel.text = tempStudent.studentID; // FOR DEBUGGING PURPOSES
        cell.textLabel.text = @"Column 1";

    }
    else if (tableView.tag == 2)
    {
        static NSString *CellIdentifier = @"Cell";
        
        [self.quickTable2 registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
//        if([students count] != 0){
//            cell.backgroundColor = [UIColor colorWithRed:35.0/255.0 green:100.0/255.0 blue:30.0/255.0 alpha:1.0];
//            cell.textLabel.textColor = [UIColor whiteColor];
//        }
//        else{
//            cell.backgroundColor = [UIColor whiteColor];
//            cell.textLabel.textColor = [UIColor blackColor];
//        }
//        Student *tempStudent = [self.students objectAtIndex:indexPath.row];
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", tempStudent.firstName, tempStudent.lastName];
//        cell.detailTextLabel.text = tempStudent.studentID; // FOR DEBUGGING PURPOSES
        cell.textLabel.text = @"Column 2";
    }
        return cell;
        
    }
    

@end
