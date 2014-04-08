//
//  SpeechFinalizeVC.m
//  Critik
//
//  Created by Dalton Decker on 3/3/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "SpeechFinalizeVC.h"

#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 50
#define kColumnMargin 10

@interface SpeechFinalizeVC ()

@property NSArray *  QuickGrades;
@property NSArray * rightQuickGrades;
@property NSArray * leftQuickGrades;

@end

@implementation SpeechFinalizeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homepageButton:(id)sender
{
//    NSString *unwindSegueIdentifier = @"unwindSegueToStudentSelection";
//    UIViewController * selectStudents = [self.storyboard instantiateViewControllerWithIdentifier:@"Homepage"];
//    UIStoryboardSegue *unwindSegue = [self.navigationController segueForUnwindingToViewController: selectStudents fromViewController: self identifier: unwindSegueIdentifier];
//    
//    [selectStudents prepareForSegue: unwindSegue sender: self];
//    
//    [unwindSegue perform];
    
   
}
-(IBAction)evaluateStudents:(id)sender
{
    NSString *unwindSegueIdentifier = @"unwindSegueToStudentSelection";
    UIViewController * selectStudents = [self.storyboard instantiateViewControllerWithIdentifier:@"Student Selection"];
    UIStoryboardSegue *unwindSegue = [self.navigationController segueForUnwindingToViewController: selectStudents fromViewController: self identifier: unwindSegueIdentifier];
    
    [selectStudents prepareForSegue: unwindSegue sender: self];
    
    [unwindSegue perform];
}


- (IBAction)unwindToStudentSelection:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    [sourceViewController isKindOfClass:[StudentSelectionVC class]];
    
}
-(IBAction)generatePDF:(id)sender
{
//    int prevOriginX = 0;
//    int prevOriginY = 0;
//    int newOriginX = 0;
//    int newOriginY = 0;
    
//    
//    
//    
//    
//    [[NSFileManager defaultManager] createFileAtPath:@"Documents/tada.txt" contents:nil attributes:nil];
//    NSString *str = @"hello";//Your text or XML
//    [str writeToFile:@"/tada.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//    NSLog(@"%@",documentsDirectory);
    
    
    //Generate a filename with Speech name and student's full name
    NSString * fileName = [NSString stringWithFormat:@"%@-%@ %@.pdf",self.currentStudentSpeech.speech.speechType,self.currentStudent.firstName, self.currentStudent.lastName];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    CGContextRef pdfContext = CGPDFContextCreateWithURL((CFURLRef)[NSURL fileURLWithPath:appFile], NULL, NULL);

    CGPDFContextBeginPage(pdfContext, NULL);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 600, 795), NULL);
    UIGraphicsPushContext(pdfContext);

    CGRect bounds = CGContextGetClipBoundingBox(pdfContext);
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    CGContextTranslateCTM(pdfContext, 0.0, -bounds.size.height);
    
    UIFont * titleFont = [UIFont fontWithName:@"Times" size:10];
    UIFont * moduleFont = [UIFont fontWithName:@"Times" size:10];
    UIFont * bodyFont = [UIFont fontWithName:@"Times" size:10];
//    UIFont * smallBody = [UIFont fontWithName:@"Times" size:8];
    
    // Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    // Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    // Set text alignment
    paragraphStyle.alignment = NSTextAlignmentRight;
    
    //Set attributes based type of data
    NSDictionary * titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys: titleFont, NSFontAttributeName, [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
    NSDictionary * moduleAttributes = [NSDictionary dictionaryWithObjectsAndKeys: moduleFont, NSFontAttributeName, [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
    NSDictionary * bodyAttributes = [NSDictionary dictionaryWithObjectsAndKeys: bodyFont, NSFontAttributeName, [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
//    NSDictionary * smallBodyAttributes = [NSDictionary dictionaryWithObjectsAndKeys: smallBody, NSFontAttributeName, [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
    
    //Variables to store origin
    int originX = 20;
    int originY = 15;
    
    //Images to use for Quick Grades
    UIImage * minusQG = [UIImage imageNamed:@"minusQuickGrade.png"];
    UIImage * okQG = [UIImage imageNamed:@"okQuickGrade.png"];
    UIImage * plusQG = [UIImage imageNamed:@"plusQuickGrade.png"];
    
    //Draw Student Name at top of document
    [[NSString stringWithFormat:@"%@ Presentation - %@ %@",self.currentStudentSpeech.speech.speechType, self.currentStudent.firstName, self.currentStudent.lastName] drawAtPoint:CGPointMake(originX, originY) withAttributes:titleAttributes];
    
    //Go to a new line
    originY += 20;
    
    //Get the modules from current speech and organize them so they are in order
    NSArray * Modules = [self.currentStudentSpeech.speech.modules allObjects];
    NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"orderIndex" ascending:YES];
    NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
    Modules = [NSMutableArray arrayWithArray:[Modules sortedArrayUsingDescriptors:descriptors]];
    
    //Iterate through each module to print out coresponding data
    for(int i = 0; i < [Modules count]; i ++)
    {
        //Current Module to print data from
        Module * currentModule = [Modules objectAtIndex:i];
        
        //Draw Module Name along with points earned out of total possible points
        [[NSString stringWithFormat:@"%@ - %d/%d pts",currentModule.moduleName, [currentModule.pointsPossible intValue], [currentModule.points intValue] ] drawAtPoint:CGPointMake(originX, originY) withAttributes:moduleAttributes];
    
        //Increment Origins to a new line and indent
        originY += 20;
        originX += 15;

        //Get quick grades from current module and organize them so they are in order
        self.QuickGrades = [currentModule.quickGrade allObjects];
        NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"quickGradeDescription" ascending:YES];
        NSArray * descriptors = [NSArray arrayWithObject:valueDescriptor];
        self.QuickGrades = [NSMutableArray arrayWithArray:[self.QuickGrades sortedArrayUsingDescriptors:descriptors]];
        
        //Split quickGrades into two arrays
        [self splitQuickGradesArray];
        
        //Iterate through the leftQuickGrades array to print quickGrades on left of page
        for(int j = 0; j < [self.leftQuickGrades count]; j ++)
        {
            //Sets current QuickGrade
            QuickGrade * currentQuickGrade = [self.leftQuickGrades objectAtIndex:j];

            //Print QuickGrade Description
            [currentQuickGrade.quickGradeDescription drawInRect:CGRectMake(originX, originY, 200, 22) withAttributes:bodyAttributes];
            
            //Print QuickGrade Score image
            switch([currentQuickGrade.score intValue])
            {
                case 0: [minusQG drawInRect:CGRectMake(originX + 225, originY + 3, 40, 15)];
                    break;
                case 1: [okQG drawInRect:CGRectMake(originX + 225, originY + 3, 40, 15)];
                    break;
                case 2: [plusQG drawInRect:CGRectMake(originX + 225, originY + 3, 40, 15)];
                    break;
            }
            //Go to a new line
            originY += 20;
        }
        originY -= (20*[self.leftQuickGrades count]);
        //Iterate through the rightQuickGrades array to print quickgrades on right of page
        for(int j = 0; j < [self.rightQuickGrades count]; j ++)
        {
            //Sets current QuickGrade
            QuickGrade * currentQuickGrade = [self.rightQuickGrades objectAtIndex:j];
            
            //Print QuickGrade Description
            [currentQuickGrade.quickGradeDescription drawInRect:CGRectMake(originX + 300, originY, 200, 22) withAttributes:bodyAttributes];
            
            //Print QuickGrade Score image
            switch([currentQuickGrade.score intValue])
            {
                case 0: [minusQG drawInRect:CGRectMake(originX + 500, originY + 3, 40, 15)];
                    break;
                case 1: [okQG drawInRect:CGRectMake(originX + 500, originY + 3, 40, 15)];
                    break;
                case 2: [plusQG drawInRect:CGRectMake(originX + 500, originY + 3, 40, 15)];
                    break;
            }
            //Go to new line
            originY += 20;
        }
        
        //Get preDefinedComments from current module and organize them so that they are in order
        NSArray * preDefinedComments = [currentModule.preDefinedComments allObjects];
        valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"comment" ascending:YES];
        descriptors = [NSArray arrayWithObject:valueDescriptor];
        preDefinedComments = [NSMutableArray arrayWithArray:[preDefinedComments sortedArrayUsingDescriptors:descriptors]];
        
        //Iterate through the PredefinedComments and print on to page
        for(int a = 0; a < [preDefinedComments count]; a ++)
        {
            //Current PreDefinedComment to Print
            PreDefinedComments * currentComment = [preDefinedComments objectAtIndex:a];
            
            [currentComment.comment drawAtPoint:CGPointMake(originX, originY) withAttributes:bodyAttributes];
            
        }
        
        //Go to a new line and bring indention inward
        originY += 25;
        originX -= 15;
    }

    //Close PDF context and save
    UIGraphicsPopContext();
    CGPDFContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);
    
}

-(void) splitQuickGradesArray
{
    NSRange someRange;
    
    someRange.location = 0;
    someRange.length = [self.QuickGrades count] / 2;
    self. rightQuickGrades = [NSMutableArray arrayWithArray:[self.QuickGrades subarrayWithRange:someRange]];
    
    
    someRange.location = someRange.length;
    someRange.length = [self.QuickGrades count] - someRange.length;
    self.leftQuickGrades = [NSMutableArray arrayWithArray:[self.QuickGrades subarrayWithRange:someRange]];
}


@end
