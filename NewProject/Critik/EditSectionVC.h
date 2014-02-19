//
//  EditSectionVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/18/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSectionVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *sectionTableView;
@property (strong, nonatomic) NSMutableArray *sections;

@end
