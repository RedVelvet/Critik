//
//  Constants.h
//  PresentationFeedback
//
//  Created by Gautham raaz on 10/6/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

// Common Variables

AppDelegate *appDelegate;

int gradeCnt;
int commentCnt;
int pointsEarned1;
int penalties1;
int totalQuickGrdCount;
int totalPreCommCount;
int maxPoints;
BOOL isBack;
BOOL isBackFromLast;
BOOL started;

NSString *stuName;
NSString *stuID;
NSString *section;
NSString *overTime;
NSString *dueLastWeek;
NSString *finalComments;
NSString *duration;
NSString *tempDuration;
NSString *modeType;
NSString *speechType;
NSString *moduleName;

NSString *appFile;

NSMutableArray *pointsArray;
NSMutableArray *commentsArray;
NSMutableArray *quickGradeStrArray;
NSMutableArray *allPreCommArray;
NSMutableArray *allQuickArray;
NSMutableArray *studentsArray;
NSMutableArray *studentIDArray;
NSMutableArray *completedStudentsArray;
NSMutableArray *sectionArray;
NSMutableArray *moduleTitles;

// Evaluation Variables

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

// Edit Variables

NSMutableDictionary *quickGradeEditDict;
NSMutableDictionary *isQuickCheckedDic;

NSMutableDictionary *preCommEditDict;
NSMutableDictionary *isCommCheckedDic;

NSMutableArray *deleteQuickArray;
NSMutableArray *deletePreCommArray;

NSMutableDictionary *sectionDic;
