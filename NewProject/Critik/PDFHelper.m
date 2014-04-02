////
////  PDFHelper.m
////  Critik
////
////  Created by Dalton Decker on 3/30/14.
////  Copyright (c) 2014 RedVelvet. All rights reserved.
////
//
//#import "PDFHelper.h"
//
//@implementation PDFHelper
//@synthesize size, imageArray, header, imageRectArray, textArray, textRectArray, data, headerRect;
//-(void)initContent{
//    imageArray = [[NSMutableArray alloc]init];
//    imageRectArray = [[NSMutableArray alloc]init];
//    
//    textArray = [[NSMutableArray alloc]init];
//    textRectArray = [[NSMutableArray alloc]init];
//    
//    header = [[NSMutableArray alloc]init];
//    headerRect = [[NSMutableArray alloc]init];
//    
//    data = [NSMutableData data];
//    //  data = [NSMutableData data];
//    
//}
//- (void) drawHeader
//{
//    for (int i = 0; i < [header count]; i++) {
//        
//        
//        CGContextRef    currentContext = UIGraphicsGetCurrentContext();
//        CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
//        
//        NSString *textToDraw = [header objectAtIndex:i];
//        
//        
//        NSLog(@"Text to draw: %@", textToDraw);
//        CGRect renderingRect = [[headerRect objectAtIndex:i]CGRectValue];
//        NSLog(@"x of rect is %f",  renderingRect.origin.x);
//        
//        
//        UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
//        
//        UIColor*color = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
//        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
//        NSStringDrawingContext *context = [NSStringDrawingContext new];
//        context.minimumScaleFactor = 0.1;
//        //        [textToDraw drawInRect:renderingRect withAttributes:att];
//        [textToDraw drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
//    }
//    
//}
//-(void)drawImage{
//    for (int i = 0; i < [imageArray count]; i++) {
//        [[imageArray objectAtIndex:i] drawInRect:[[imageRectArray objectAtIndex:i]CGRectValue]];
//        
//    }
//}
//- (void) drawText
//{
//    for (int i = 0; i < [textArray count]; i++) {
//        
//        
//        CGContextRef currentContext = UIGraphicsGetCurrentContext();
//        CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
//        
//        NSString * textToDraw = [textArray objectAtIndex:i];
//        
//        
//        NSLog(@"Text to draw: %@", textToDraw);
//        CGRect renderingRect = [[textRectArray objectAtIndex:i]CGRectValue];
//        NSLog(@"x of rect is %f",  renderingRect.origin.x);
//        
//        
//        UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
//        
//        UIColor*color = [UIColor blackColor];
//        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
//        
//        
//        [textToDraw drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
//    }
//    
//}
//+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    //UIGraphicsBeginImageContext(newSize);
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//-(void)addImageWithRect:(UIImage *)image inRect:(CGRect)rect{
////    UIImage *newImage = [PDF imageWithImage:image scaledToSize:CGSizeMake(rect.size.width, rect.size.height)];
//    
//    
//    [imageArray addObject:newImage];
//    [imageRectArray addObject:[NSValue valueWithCGRect:rect]];
//}
//-(void)addTextWithRect:(NSString *)text inRect:(CGRect)rect{
//    [textArray addObject:text];
//    [textRectArray addObject:[NSValue valueWithCGRect:rect]];
//}
//-(void)addHeadertWithRect:(NSString *)text inRect:(CGRect)rect{
//    [header addObject:text];
//    [headerRect addObject:[NSValue valueWithCGRect:rect]];
//}
//
//- (NSMutableData*) generatePdfWithFilePath: (NSString *)thefilePath
//{
//    
//    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
//    
//    
//    BOOL done = NO;
//    do
//    {
//        //Start a new page.
//        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, size.width, size.height), nil);
//        
//        //Draw Header
//        [self drawHeader];
//        //Draw Text
//        [self drawText];
//        //Draw an image
//        [self drawImage];
//        
//        done = YES;
//    }
//    while (!done);
//    
//    // Close the PDF context and write the contents out.
//    UIGraphicsEndPDFContext();
//    
//    
//    //For data
//    UIGraphicsBeginPDFContextToData(data, CGRectZero, nil);
//    
//    
//    BOOL done1 = NO;
//    do
//    {
//        //Start a new page.
//        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, size.width, size.height), nil);
//        
//        //Draw Header
//        [self drawHeader];
//        //Draw Text
//        [self drawText];
//        //Draw an image
//        [self drawImage];
//        
//        done1 = YES;
//    } 
//    while (!done1);
//    
//    // Close the PDF context and write the contents out.
//    UIGraphicsEndPDFContext();
//    return data;
//}
//@end
//
