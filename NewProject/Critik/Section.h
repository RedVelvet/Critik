//
//  Section.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/28/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSSet *students;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
