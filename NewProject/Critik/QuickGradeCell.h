//
//  QuickGradeCell.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickGradeCell : UITableViewCell{
    UIButton * column1;
    UIButton * column2;
    
    UILabel* column1_label1;
    UILabel* column1_label2;
    
    UILabel* column2_label1;
    UILabel* column2_label2;
}

@property (nonatomic,retain) UIButton * column1;
@property (nonatomic,retain) UIButton * column2;

@property (nonatomic,retain) UILabel* column1_label1;
@property (nonatomic,retain) UILabel* column1_label2;

@property (nonatomic,retain) UILabel* column2_label1;
@property (nonatomic,retain) UILabel* column2_label2;

@end
