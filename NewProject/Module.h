//
//  Module.h
//  Critik
//
//  Created by Dalton Decker on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Module : NSManagedObject

@property (nonatomic, retain) NSNumber * moduleID;
@property (nonatomic, retain) NSString * moduleName;

@end
