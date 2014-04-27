//
//  PreDefinedComments.h
//  Critik
//
//  Created by Dalton Decker on 4/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module;

@interface PreDefinedComments : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * commentID;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) Module *module;

@end
