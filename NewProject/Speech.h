//
//  Speech.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentSpeech;

@interface Speech : NSManagedObject

@property (nonatomic, retain) NSString * speechType;
@property (nonatomic, retain) NSSet *studentSpeech;
@end

@interface Speech (CoreDataGeneratedAccessors)

- (void)addStudentSpeechObject:(StudentSpeech *)value;
- (void)removeStudentSpeechObject:(StudentSpeech *)value;
- (void)addStudentSpeech:(NSSet *)values;
- (void)removeStudentSpeech:(NSSet *)values;

@end
