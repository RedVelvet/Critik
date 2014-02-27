//
//  WrittenComments.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SpeechModule, StudentSpeech;

@interface WrittenComments : NSManagedObject

@property (nonatomic, retain) NSString * writtenComments;
@property (nonatomic, retain) StudentSpeech *studentSpeech;
@property (nonatomic, retain) SpeechModule *speechModule;

@end
