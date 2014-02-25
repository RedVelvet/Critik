//
//  PreDefinedComments.h
//  Critik
//
//  Created by Dalton Decker on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module;

@interface PreDefinedComments : NSManagedObject

@property (nonatomic, retain) NSString * preDefComments;
@property (nonatomic, retain) NSNumber * preDefID;
@property (nonatomic, retain) Module *moduleID;

@end
