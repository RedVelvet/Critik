//
//  Speech.h
//  Critik
//
//  Created by Dalton Decker on 3/19/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module;

@interface Speech : NSManagedObject

@property (nonatomic, retain) NSString * speechType;
@property (nonatomic, retain) NSString * isTemplate;
@property (nonatomic, retain) NSSet *modules;
@end

@interface Speech (CoreDataGeneratedAccessors)

- (void)addModulesObject:(Module *)value;
- (void)removeModulesObject:(Module *)value;
- (void)addModules:(NSSet *)values;
- (void)removeModules:(NSSet *)values;

@end
