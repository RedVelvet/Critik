//
//  StudentSpeech.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/28/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Speech, Student;

@interface StudentSpeech : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * totalPoints;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSSet * speechesGiven;
@property (nonatomic, retain) Student *student;
@end

@interface StudentSpeech (CoreDataGeneratedAccessors)

- (void)addSpeechesGivenObject:(Speech *)value;
- (void)removeSpeechesGivenObject:(Speech *)value;
- (void)addSpeechesGiven:(NSSet *)values;
- (void)removeSpeechesGiven:(NSSet *)values;

@end
