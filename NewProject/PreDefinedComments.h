//
//  PreDefinedComments.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module, StudentPreDefinedComments;

@interface PreDefinedComments : NSManagedObject

@property (nonatomic, retain) NSString * preDefComments;
@property (nonatomic, retain) Module *module;
@property (nonatomic, retain) NSSet *studentPreDefinedComments;
@end

@interface PreDefinedComments (CoreDataGeneratedAccessors)

- (void)addStudentPreDefinedCommentsObject:(StudentPreDefinedComments *)value;
- (void)removeStudentPreDefinedCommentsObject:(StudentPreDefinedComments *)value;
- (void)addStudentPreDefinedComments:(NSSet *)values;
- (void)removeStudentPreDefinedComments:(NSSet *)values;

@end
