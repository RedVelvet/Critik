//
//  Module.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PreDefinedComments, QuickGrade, SpeechModule;

@interface Module : NSManagedObject

@property (nonatomic, retain) NSString * moduleName;
@property (nonatomic, retain) NSSet *speechModule;
@property (nonatomic, retain) NSSet *quickGrade;
@property (nonatomic, retain) NSSet *preDefinedComments;
@end

@interface Module (CoreDataGeneratedAccessors)

- (void)addSpeechModuleObject:(SpeechModule *)value;
- (void)removeSpeechModuleObject:(SpeechModule *)value;
- (void)addSpeechModule:(NSSet *)values;
- (void)removeSpeechModule:(NSSet *)values;

- (void)addQuickGradeObject:(QuickGrade *)value;
- (void)removeQuickGradeObject:(QuickGrade *)value;
- (void)addQuickGrade:(NSSet *)values;
- (void)removeQuickGrade:(NSSet *)values;

- (void)addPreDefinedCommentsObject:(PreDefinedComments *)value;
- (void)removePreDefinedCommentsObject:(PreDefinedComments *)value;
- (void)addPreDefinedComments:(NSSet *)values;
- (void)removePreDefinedComments:(NSSet *)values;

@end
