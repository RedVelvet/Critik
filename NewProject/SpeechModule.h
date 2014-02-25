//
//  SpeechModule.h
//  Critik
//
//  Created by Dalton Decker on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module, Speech;

@interface SpeechModule : NSManagedObject

@property (nonatomic, retain) NSNumber * modulePoints;
@property (nonatomic, retain) Module *moduleID;
@property (nonatomic, retain) Speech *speechID;

@end
