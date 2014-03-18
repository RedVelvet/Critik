//
//  SpeechFinalizeVC.m
//  Critik
//
//  Created by Dalton Decker on 3/3/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "SpeechFinalizeVC.h"

@interface SpeechFinalizeVC ()

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
    NSString *unwindSegueIdentifier = @"unwindSegueToStudentSelection";
    UIViewController * selectStudents = [self.storyboard instantiateViewControllerWithIdentifier:@"Homepage"];
    UIStoryboardSegue *unwindSegue = [self.navigationController segueForUnwindingToViewController: selectStudents fromViewController: self identifier: unwindSegueIdentifier];
    
    [selectStudents prepareForSegue: unwindSegue sender: self];
    
    [unwindSegue perform];
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
-(void)generatePDF
{
    //Set Filename with Student first/last and speech type
    NSString* fileName = [NSString stringWithFormat:@"%@ %@ - %@",self.currentStudent.firstName,self.currentStudent.lastName,[self.currentStudentSpeech.speech speechType]];
    
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    NSString* textToDraw = @"Hello World";
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
    
    // Prepare the text using a Core Text Framesetter.
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    
    CGRect frameRect = CGRectMake(0, 0, 300, 50);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    CGContextTranslateCTM(currentContext, 0, 100);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // Draw the frame.
    CTFrameDraw(frameRef, currentContext);
    
    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(framesetter);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
}
@end
