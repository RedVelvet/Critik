//
//  Speech.h
//  Critik
//
//  Created by Dalton Decker on 2/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Speech : NSManagedObject

@property (nonatomic, retain) NSString * speechID;
@property (nonatomic, retain) NSString * speechType;

@end
