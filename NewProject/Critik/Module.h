//
//  Module.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/28/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PreDefinedComments, QuickGrade, Speech;

@interface Module : NSManagedObject

@property (nonatomic, retain) NSString * moduleName;
@property (nonatomic, retain) NSNumber * points;
@property (nonatomic, retain) NSString * written;
@property (nonatomic, retain) NSNumber * orderIndex;
@property (nonatomic, retain) NSSet *preDefinedComments;
@property (nonatomic, retain) NSSet *quickGrade;
@property (nonatomic, retain) Speech *speech;
@end

@interface Module (CoreDataGeneratedAccessors)

- (void)addPreDefinedCommentsObject:(PreDefinedComments *)value;
- (void)removePreDefinedCommentsObject:(PreDefinedComments *)value;
- (void)addPreDefinedComments:(NSSet *)values;
- (void)removePreDefinedComments:(NSSet *)values;

- (void)addQuickGradeObject:(QuickGrade *)value;
- (void)removeQuickGradeObject:(QuickGrade *)value;
- (void)addQuickGrade:(NSSet *)values;
- (void)removeQuickGrade:(NSSet *)values;

@end
