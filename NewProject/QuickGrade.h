//
//  QuickGrade.h
//  Critik
//
//  Created by Dalton Decker on 4/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module;

@interface QuickGrade : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * quickGradeDescription;
@property (nonatomic, retain) NSString * quickGradeID;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) Module *module;

@end
