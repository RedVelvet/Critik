//
//  WrittenComments.h
//  Critik
//
//  Created by Dalton Decker on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Speech, Student;

@interface WrittenComments : NSManagedObject

@property (nonatomic, retain) NSString * writtenComments;
@property (nonatomic, retain) NSManagedObject *moduleID;
@property (nonatomic, retain) Speech *speechID;
@property (nonatomic, retain) Student *studentID;

@end
