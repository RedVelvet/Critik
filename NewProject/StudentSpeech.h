//
//  StudentSpeech.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Speech, SpeechModule, Student, StudentPreDefinedComments, StudentQuickGrade, WrittenComments;

@interface StudentSpeech : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * totalPoints;
@property (nonatomic, retain) Speech *speech;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) NSSet *studentQuickGrade;
@property (nonatomic, retain) NSSet *studentPreDefinedComments;
@property (nonatomic, retain) NSSet *writtenComments;
@property (nonatomic, retain) NSSet *speechModule;
@end

@interface StudentSpeech (CoreDataGeneratedAccessors)

- (void)addStudentQuickGradeObject:(StudentQuickGrade *)value;
- (void)removeStudentQuickGradeObject:(StudentQuickGrade *)value;
- (void)addStudentQuickGrade:(NSSet *)values;
- (void)removeStudentQuickGrade:(NSSet *)values;

- (void)addStudentPreDefinedCommentsObject:(StudentPreDefinedComments *)value;
- (void)removeStudentPreDefinedCommentsObject:(StudentPreDefinedComments *)value;
- (void)addStudentPreDefinedComments:(NSSet *)values;
- (void)removeStudentPreDefinedComments:(NSSet *)values;

- (void)addWrittenCommentsObject:(WrittenComments *)value;
- (void)removeWrittenCommentsObject:(WrittenComments *)value;
- (void)addWrittenComments:(NSSet *)values;
- (void)removeWrittenComments:(NSSet *)values;

- (void)addSpeechModuleObject:(SpeechModule *)value;
- (void)removeSpeechModuleObject:(SpeechModule *)value;
- (void)addSpeechModule:(NSSet *)values;
- (void)removeSpeechModule:(NSSet *)values;

@end
