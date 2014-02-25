//
//  StudentPreDefinedComments.h
//  Critik
//
//  Created by Dalton Decker on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Speech, Student;

@interface StudentPreDefinedComments : NSManagedObject

@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) NSManagedObject *moduleID;
@property (nonatomic, retain) NSSet *preDefID;
@property (nonatomic, retain) Speech *speechID;
@property (nonatomic, retain) NSSet *studentID;
@end

@interface StudentPreDefinedComments (CoreDataGeneratedAccessors)

- (void)addPreDefIDObject:(NSManagedObject *)value;
- (void)removePreDefIDObject:(NSManagedObject *)value;
- (void)addPreDefID:(NSSet *)values;
- (void)removePreDefID:(NSSet *)values;

- (void)addStudentIDObject:(Student *)value;
- (void)removeStudentIDObject:(Student *)value;
- (void)addStudentID:(NSSet *)values;
- (void)removeStudentID:(NSSet *)values;

@end
