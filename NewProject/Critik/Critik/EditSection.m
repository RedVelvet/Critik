//
//  EditSection.m
//  Critik
//
//  Created by Doug Wettlaufer on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "EditSection.h"

@interface EditSection ()

@end

@implementation EditSection

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
    index = 0;
    [sectionDic setDictionary:nil];

    [studentsArray setArray:nil];
    
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
