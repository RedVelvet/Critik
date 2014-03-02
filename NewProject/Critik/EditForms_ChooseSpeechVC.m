//
//  EditForms_ChooseSpeechVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 2/28/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditForms_ChooseSpeechVC.h"


@interface EditForms_ChooseSpeechVC ()

@end

@implementation EditForms_ChooseSpeechVC

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

- (IBAction)chooseSpeechTypePressed:(id)sender {

    //[self performSegueWithIdentifier:@"chooseSpeechSegue" sender:sender];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"chooseSpeechSegue"]) {
        
    EditPersuasiveVC *editPersuasiveVC = [segue destinationViewController];
    NSInteger tag = [(UIButton *)sender tag];
    editPersuasiveVC.sendingButtonTag = tag;
    }
}
@end
