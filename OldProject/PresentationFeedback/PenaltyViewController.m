//
//  PenaltyViewController.m
//  PresentationFeedback
//
//  Created by Gautham raaz on 11/21/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import "PenaltyViewController.h"
#import <sqlite3.h>
#import "Constants.h"
#define NUMBERS @"0123456789"

@interface PenaltyViewController ()

@end

@implementation PenaltyViewController
@synthesize penaltiesValue, durationLabel;

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
    
    UILabel* stuLabel = (UILabel*)[self.view viewWithTag:200];
    [stuLabel setText:stuName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissVC) name:@"DismissVC" object:nil];
    
	// Do any additional setup after loading the view.
    
    pointsEarned1 = 0;
    
    for(int i=0 ;i< [pointsArray count];i++)
    {
        pointsEarned1 = pointsEarned1 + [[pointsArray objectAtIndex:i] integerValue];
    }
    
    durationLabel.text = tempDuration;
    duration = durationLabel.text;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"PenaltyViewController viewDidAppear");
    
    pointsEarned1 = 0;
    
    for(int i=0 ;i< [pointsArray count];i++)
    {
        pointsEarned1 = pointsEarned1 + [[pointsArray objectAtIndex:i] integerValue];
    }
}

-(void)viewDidDisappear
{
    NSLog(@"PenaltyViewController viewDidDisappear");
    
    penalties1 = [penaltiesValue.text integerValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkButton:(id)sender {
    
    UIButton *checkButton = (UIButton*)sender;
    
    checkButton.selected = !checkButton.selected;
    
    if(checkButton.selected)
    {
        [checkButton setImage:[UIImage imageNamed:@"CheckBoxChecked.jpeg"] forState:UIControlStateNormal];
        if([sender tag] == 0)
            overTime = @"Over Time";
        else
            dueLastWeek = @"Late Presentation";
            
    }
    else
    {
        [checkButton setImage:[UIImage imageNamed:@"CheckBox.jpeg"] forState:UIControlStateNormal];
        if([sender tag] == 0)
            overTime = @"";
        else
            dueLastWeek = @"";
    }

}

- (IBAction)finalizeButtonPressed:(id)sender {
    
    pointsEarned1 = 0;
    
    for(int i=0 ;i< [pointsArray count];i++)
    {
        pointsEarned1 = pointsEarned1 + [[pointsArray objectAtIndex:i] integerValue];
    }
    
    penalties1 = [penaltiesValue.text integerValue];
    
    finalComments = [(UITextView*)[self.view viewWithTag:600] text];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryBoard_iPad" bundle:nil];
    EvaluationViewController *evaluationVC = (EvaluationViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"EvaluationViewController"];
    
    [self presentViewController:evaluationVC animated:YES completion:nil];   
    
}




#pragma mark Text View delegate methods

-(void)textViewDidBeginEditing:(UITextView*)textView
{
    [textView resignFirstResponder];
    
    if ([textView tag] == 600) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5 ];
        [textView setFrame:CGRectMake(360, 250, 336, 111)];
        [UIView commitAnimations];
    }
}

-(void)textViewDidEndEditing:(UITextView*)textView
{
    [textView resignFirstResponder];
    
    if ([textView tag] == 600) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [textView setFrame:CGRectMake(360, 395, 336, 111)];
        [UIView commitAnimations];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    int tempMaxPoints = [[NSString stringWithFormat:@"%@%@", [textField text], string] integerValue];
    
    if (textField.tag == 300) {
        
        if ([textField.text length] > 2) {
            textField.text = [textField.text substringToIndex:1];
            return NO;
        }
        
//        if ([[textField text] integerValue] > pointsEarned1) {
//            textField.text = [textField.text substringToIndex:1];
//            return NO;
//        }
//        
//        
//        if(tempMaxPoints > pointsEarned1){
//            textField.text = [textField.text substringToIndex:1];
//            return NO;
//        }
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:NUMBERS];
        
        for (int i = 0; i < [string length]; i++) {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c]) {
                return NO;
            }
        }
    }
    return YES;
}


-(void) dismissVC
{
    NSLog(@"Hellooo.. m in penalty");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
