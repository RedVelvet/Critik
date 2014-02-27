//
//  SpeechModule.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Module, StudentSpeech, WrittenComments;

@interface SpeechModule : NSManagedObject

@property (nonatomic, retain) NSNumber * modulePoints;
@property (nonatomic, retain) StudentSpeech *studentSpeech;
@property (nonatomic, retain) NSSet *writtenComments;
@property (nonatomic, retain) Module *module;
@end

@interface SpeechModule (CoreDataGeneratedAccessors)

- (void)addWrittenCommentsObject:(WrittenComments *)value;
- (void)removeWrittenCommentsObject:(WrittenComments *)value;
- (void)addWrittenComments:(NSSet *)values;
- (void)removeWrittenComments:(NSSet *)values;

@end
