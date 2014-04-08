//
//  Student.h
//  Critik
//
//  Created by Dalton Decker on 4/7/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section, StudentSpeech;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * informativeOrder;
@property (nonatomic, retain) NSString * studentID;
@property (nonatomic, retain) NSNumber * persuasiveOrder;
@property (nonatomic, retain) NSNumber * interpersonalOrder;
@property (nonatomic, retain) Section *section;
@property (nonatomic, retain) NSSet *studentSpeech;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addStudentSpeechObject:(StudentSpeech *)value;
- (void)removeStudentSpeechObject:(StudentSpeech *)value;
- (void)addStudentSpeech:(NSSet *)values;
- (void)removeStudentSpeech:(NSSet *)values;

@end
