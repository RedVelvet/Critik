//
//  StudentSpeech.h
//  Critik
//
//  Created by Dalton Decker on 4/8/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Speech, Student;

@interface StudentSpeech : NSManagedObject

@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * totalPoints;
@property (nonatomic, retain) NSString * isLate;
@property (nonatomic, retain) NSString * overTime;
@property (nonatomic, retain) NSNumber * penaltyPoints;
@property (nonatomic, retain) NSNumber * pointsEarned;
@property (nonatomic, retain) Speech *speech;
@property (nonatomic, retain) Student *student;

@end
