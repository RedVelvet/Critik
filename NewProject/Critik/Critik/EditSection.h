//
//  EditSection.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface EditSection : UIViewController
{
    int index;
    NSMutableDictionary *sectionDic;
    NSMutableArray *studentsArray;
    AppDelegate *appDelegate;
}




@end
