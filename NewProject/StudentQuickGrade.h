//
//  StudentQuickGrade.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuickGrade, StudentSpeech;

@interface StudentQuickGrade : NSManagedObject

@property (nonatomic, retain) NSNumber * quickGradeValue;
@property (nonatomic, retain) StudentSpeech *studentSpeech;
@property (nonatomic, retain) QuickGrade *quickGrade;

@end
