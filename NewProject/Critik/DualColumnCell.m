//
//  DualColumnCell.m
//  Critik
//
//  Created by Dalton Decker on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "DualColumnCell.h"

@interface DualColumnCell ()

@end

@implementation DualColumnCell

@synthesize column1,column1_label1,column2,column2_label1;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        column1 = [UIButton buttonWithType: UIButtonTypeCustom];
        column1.tag = 1;
        column1.autoresizingMask = 292;
        
        //column1.backgroundColor = [UIColor greenColor];
        column1.frame = CGRectMake(0, 0, self.contentView.bounds.size.width,  self.contentView.bounds.size.height);
        
        
        column1_label1 = [[UILabel alloc] initWithFrame: CGRectMake(column1.bounds.size.width*1/5,0,column1.bounds.size.width*4/5,column1.bounds.size.height/2)];
        
        column1_label1.backgroundColor = [UIColor greenColor];
        [column1 addSubview:column1_label1];
        
        [self.contentView addSubview: column1];
        
        
        
        column2 = [UIButton buttonWithType: UIButtonTypeCustom];
        
        
        column2.tag = 2;
        column2.autoresizingMask = 292;
        
        //column2.backgroundColor = [UIColor greenColor];
        column2.frame = CGRectMake(self.contentView.bounds.size.width, 0, self.contentView.bounds.size.width,  self.contentView.bounds.size.height);
        
        column2_label1 = [[UILabel alloc] initWithFrame: CGRectMake(column2.bounds.size.width*1/5,0,column2.bounds.size.width*4/5,column2.bounds.size.height/2)];
        
        //column2_label1.backgroundColor = [UIColor redColor];
        [column2 addSubview:column2_label1];
        
        [self.contentView addSubview: column2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//- (void)dealloc
//{
//    [super dealloc];
//}

@end
