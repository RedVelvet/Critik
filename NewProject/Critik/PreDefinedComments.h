//
//  PreDefinedComments.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/28/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module;

@interface PreDefinedComments : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * isActive;
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) Module *module;

@end
