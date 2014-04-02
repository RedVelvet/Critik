//
//  PDFHelper.h
//  Critik
//
//  Created by Dalton Decker on 3/30/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDFHelper : NSObject{
}
@property(nonatomic, readwrite) CGSize size;
@property(nonatomic, strong) NSMutableArray *headerRect;

@property(nonatomic, strong) NSMutableArray *header;

@property(nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic, strong) NSMutableArray *imageRectArray;

@property(nonatomic, strong) NSMutableArray *textArray;
@property(nonatomic, strong) NSMutableArray *textRectArray;

@property(nonatomic, strong)  NSMutableData *data;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
// i metodi vanno invocati nel seguente ordine:
-(void)initContent;
-(void)addImageWithRect:(UIImage*)image inRect:(CGRect)rect;
-(void)addTextWithRect:(NSString*)text inRect:(CGRect)rect;
-(void)addHeadertWithRect:(NSString *)text inRect:(CGRect)rect;

- (void) drawText;
- (void) drawHeader;
- (void) drawImage;
- (NSMutableData*) generatePdfWithFilePath: (NSString *)thefilePath;
@end
