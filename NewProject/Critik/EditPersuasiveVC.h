//
//  EditPersuasiveVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickGradeCell.h"

@interface EditPersuasiveVC : UIViewController{
    UIScrollView *beingScrolled_;
}

@property (weak, nonatomic) IBOutlet UITableView *quickTable1;
@property (weak, nonatomic) IBOutlet UITableView *quickTable2;
@property (weak, nonatomic) IBOutlet UIScrollView *quickGradeScrollView;

@end
