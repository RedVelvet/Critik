//
//  QuickGrade.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/28/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module;

@interface QuickGrade : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * quickGradeDescription;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) Module *module;

@end
