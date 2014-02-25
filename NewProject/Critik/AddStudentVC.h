//
//  AddStudentVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/19/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStudentVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *studentFirstNameTF;
@property (weak, nonatomic) IBOutlet UITextField *studentLastNameTF;
@property (weak, nonatomic) IBOutlet UITextField *sNumTF;
@property (weak, nonatomic) IBOutlet UIButton *uploadRoster;

@end
