//
//  StudentOrderPopoverVC.m
//  Critik
//
//  Created by Dalton Decker on 3/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentOrderPopoverVC.h"

@implementation StudentOrderPopoverVC



-(void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    //initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //Setting the entity name to grab from Core Data.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(section == %@)",self.currentSection]];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    //Retrieve sections from core data and store within sections attribute
    self.students = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePopoverContent:(id)sender {
    
    // Return which order to set students based on button pressed.
    if([sender tag] == 0)
    {
        //sort students by last name
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        self.students = [NSMutableArray arrayWithArray:[self.students sortedArrayUsingDescriptors:descriptors]];
        //set the order index
        for(int i = 0; i < [self.students count]; i ++)
        {
            [[self.students objectAtIndex:i] setOrderIndex:[NSNumber numberWithInt:i]];
        }
        
    }else{
        //Randomize Students
        if([self.students count] > 1)
        {
            for (NSUInteger i = [self.students count] - 1; i >= 1; i--)
            {
                int j = arc4random_uniform(i + 1);
                [self.students exchangeObjectAtIndex:j withObjectAtIndex:i];
            }
            //set the order index
            for(int i = 0; i < [self.students count]; i ++)
            {
                [[self.students objectAtIndex:i] setOrderIndex:[NSNumber numberWithInt:i]];
            }
        }
    }
    
}



@end
