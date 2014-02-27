//
//  QuickGrade.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module, StudentQuickGrade;

@interface QuickGrade : NSManagedObject

@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSString * quickGradeDescription;
@property (nonatomic, retain) Module *module;
@property (nonatomic, retain) NSSet *studentQuickGrade;
@end

@interface QuickGrade (CoreDataGeneratedAccessors)

- (void)addStudentQuickGradeObject:(StudentQuickGrade *)value;
- (void)removeStudentQuickGradeObject:(StudentQuickGrade *)value;
- (void)addStudentQuickGrade:(NSSet *)values;
- (void)removeStudentQuickGrade:(NSSet *)values;

@end
