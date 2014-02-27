//
//  StudentPreDefinedComments.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PreDefinedComments, StudentSpeech;

@interface StudentPreDefinedComments : NSManagedObject

@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) StudentSpeech *studentSpeech;
@property (nonatomic, retain) PreDefinedComments *preDefinedComments;

@end
