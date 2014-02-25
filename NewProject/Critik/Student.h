//
//  Student.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/19/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * studentID;
@property (nonatomic, retain) Section *section;

@end
