//
//  Constants.m
//  PresentationFeedback
//
//  Created by Gautham raaz on 10/6/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import "Constants.h"

//bool isLinked=NO;
int maxPoints = 0;
int gradeCnt = 0;
int commentCnt = 0;
int pointsEarned1 = 0;
int penalties1 = 0;
int totalQuickGrdCount = 0;
int totalPreCommCount = 0;

BOOL isBack = NO;
BOOL isBackFromLast = NO;
BOOL started = YES;

NSString *stuName = @"";
NSString *stuID = @"";
NSString *section = @"";

NSMutableDictionary *preCommentsDic1;
NSMutableDictionary *preCommentsDic2;
NSMutableDictionary *preCommentsDic3;
NSMutableDictionary *preCommentsDic4;
NSMutableDictionary *preCommentsDic5;
NSMutableDictionary *preCommentsDic6;
NSMutableDictionary *preCommentsDic7;

NSMutableDictionary *quickGradesDic1;
NSMutableDictionary *quickGradesDic2;
NSMutableDictionary *quickGradesDic3;
NSMutableDictionary *quickGradesDic4;
NSMutableDictionary *quickGradesDic5;
NSMutableDictionary *quickGradesDic6;
NSMutableDictionary *quickGradesDic7;

NSMutableArray *pointsArray;
NSMutableArray *commentsArray;

NSMutableArray *quickGradeStrArray;

NSMutableArray *allPreCommArray;
NSMutableArray *allQuickArray;

NSMutableArray *studentsArray;
NSMutableArray *studentIDArray;
NSMutableArray *completedStudentsArray;
NSMutableArray *sectionArray;

AppDelegate *appDelegate;
NSString *modeType = @"";
NSString *speechType = @"";
NSString *moduleName = @"";
NSString *appFile = @"";

NSString *overTime = @"";
NSString *dueLastWeek = @"";
NSString *finalComments = @"";
NSString *duration = @"";
NSString *tempDuration = @"";
NSMutableDictionary *sectionDic;




