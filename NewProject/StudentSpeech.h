//
//  StudentSpeech.h
//  Critik
//
//  Created by Dalton Decker on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Speech, Student;

@interface StudentSpeech : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * totalPoints;
@property (nonatomic, retain) NSSet *speechID;
@property (nonatomic, retain) NSSet *studentID;
@end

@interface StudentSpeech (CoreDataGeneratedAccessors)

- (void)addSpeechIDObject:(Speech *)value;
- (void)removeSpeechIDObject:(Speech *)value;
- (void)addSpeechID:(NSSet *)values;
- (void)removeSpeechID:(NSSet *)values;

- (void)addStudentIDObject:(Student *)value;
- (void)removeStudentIDObject:(Student *)value;
- (void)addStudentID:(NSSet *)values;
- (void)removeStudentID:(NSSet *)values;

@end
