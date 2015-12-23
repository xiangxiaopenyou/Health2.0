//
//  RTTabbarItem.m
//  RTHealth
//
//  Created by cheng on 14-10-15.
//  Copyright (c) 2014年 realtech. All rights reserved.
//

#import "RTTabbarItem.h"

@interface RTTabbarItem (PrivateMethods)

- (CGFloat )horizontalLocationFor:(NSUInteger)tabIndex;
- (void) addTabBarArrowAtIndex:(NSUInteger)itemIndex;
- (UIButton*)buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
-(UIImage*) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
-(UIImage*) blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage;
-(UIImage*) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;

@end

@implementation RTTabbarItem

@synthesize labels,buttons,buttonsImage;

- (id) initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <RTTabbarItemDelegate> *)customTabBarDelegate
{
    self = [super init];
    if (self) {
        delegate = customTabBarDelegate;
        UIImage *backgroundImage         = [UIImage imageNamed:@"tabbar_background.png"];
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABBAR_HEIGHT)];
        backgroundImageView.image        = backgroundImage;
        
        [self addSubview:backgroundImageView];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, TABBAR_HEIGHT);
        
        self.buttons      = [[NSMutableArray alloc]initWithCapacity:itemCount];
        self.labels       = [[NSMutableArray alloc]initWithCapacity:itemCount];
        self.buttonsImage = [[NSMutableArray alloc]initWithCapacity:itemCount];
        
        CGFloat horizaontalOffset = 0;
        
        for (NSUInteger i = 0; i < itemCount ; i ++ ) {
            UIButton *buttonImage       = [UIButton buttonWithType: UIButtonTypeCustom];
            buttonImage.backgroundColor = [UIColor clearColor];
            buttonImage.frame           = CGRectMake(horizaontalOffset, 0, itemSize.width, itemSize.height);
            [buttonImage addTarget:self action:@selector(touchUpInsideActionImage:) forControlEvents:UIControlEventTouchUpInside];
            [buttonsImage addObject:buttonImage];
            
            
            UIButton* button = [self buttonAtIndex:i width:itemSize.width];
            // Register for touch events
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
            button.alpha = 1.0;
            // Add the button to our buttons array
            [buttons addObject:button];
            
            UILabel *label        = [[UILabel alloc]initWithFrame:CGRectMake(0, 34,itemSize.width, 12) ];
            label.textAlignment   = NSTextAlignmentCenter;
            label.font            = [UIFont systemFontOfSize:10.0];
            label.textColor       = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            label.text            = [self titleAtIndex:i];
            [self.labels addObject:label];
            
            [self addSubview:buttonImage];
            [buttonImage addSubview:button];
            [buttonImage addSubview:label];
            horizaontalOffset = horizaontalOffset + itemSize.width;
            if (i == 1) {
                horizaontalOffset = horizaontalOffset + itemSize.width;
            }
        }
        
        UIButton *buttonImage       = [UIButton buttonWithType: UIButtonTypeCustom];
        buttonImage.backgroundColor = [UIColor clearColor];
        buttonImage.frame           = CGRectMake(itemSize.width*2, 0, itemSize.width, itemSize.height);
        [buttonImage addTarget:self action:@selector(touchUpInsideActionMidImage:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsImage addObject:buttonImage];
        
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        //    button.frame = CGRectMake(0.0, 0.0, width, self.frame.size.height);
        button.frame = CGRectMake((itemSize.width-40)/2 - 3, (TABBAR_HEIGHT-40)/2 - 3, 46, 46);
        UIImage* rawButtonImage = [UIImage imageNamed:@"center.png"];
        UIImage* buttonImageback = rawButtonImage;
        UIImage* buttonPressedImage = [UIImage imageNamed:@"center.png"];
        [button setImage:buttonImageback forState:UIControlStateNormal];
        [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
        [button setImage:buttonPressedImage forState:UIControlStateSelected];
        
        [button setBackgroundImage:[delegate selectedItemImage] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[delegate selectedItemImage] forState:UIControlStateSelected];
        
        button.adjustsImageWhenHighlighted = NO;
        // Register for touch events
        [button addTarget:self action:@selector(touchDownActionMid:) forControlEvents:UIControlEventTouchUpInside];
        button.alpha = 1.0;
        // Add the button to our buttons array
        [self addSubview:buttonImage];
        [buttonImage addSubview:button];

        
    }
    return self;
}
- (void)touchUpInsideActionMidImage:(UIButton*)btn{
    [delegate touchDownAtMidItem];
}
- (void)touchDownActionMid:(UIButton*)btn{
    [delegate touchDownAtMidItem];
}

- (void)dimAllButtonExcept:(UIButton*)selectedButton
{
    for (UIButton *button in buttons) {
        if (button == selectedButton) {
            button.selected = YES;
            button.highlighted = button.selected ? NO : YES ;
            UILabel *label = [labels objectAtIndex:[buttons indexOfObject:button]];
            label.textColor = [UIColor whiteColor];
            UIImageView *tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
            NSUInteger selectedIndex = [buttons indexOfObjectIdenticalTo:button];
            if (tabBarArrow ) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                CGRect frame = tabBarArrow.frame;
                frame.origin.x = [self horizontalLocationFor:selectedIndex];
                tabBarArrow.frame = frame;
                [UIView commitAnimations];
            }else{
                [self addTabBarArrowAtIndex:selectedIndex];
            }
            
        }else{
            button.selected = NO;
            button.highlighted = NO;
            UILabel *label = [labels objectAtIndex:[buttons indexOfObject:button]];
            label.textColor = [UIColor grayColor];
        }
    }
}

- (void)touchUpInsideActionImage:(UIButton*)button{
    NSInteger index = 0;
    for (UIButton* buttontemp in buttonsImage) {
        if (buttontemp == button) {
            index = [buttonsImage indexOfObject:button];
        }
    }
    [self dimAllButtonExcept:[buttons objectAtIndex:index]];
    [delegate touchDownAtItemAtIndex:[buttons indexOfObject:[buttons objectAtIndex:index]]];
}

- (void)touchDownAction:(UIButton*)button{
    [self dimAllButtonExcept:button];
    if ([delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)]) {
        [delegate touchDownAtItemAtIndex:[buttons indexOfObject:button]];
    }
}

- (void)touchUpInsideAction:(UIButton*)button
{
    [self dimAllButtonExcept:button];
    
    if ([delegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
        [delegate touchUpInsideItemAtIndex:[buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{
    [self dimAllButtonExcept:button];
}

- (void) selectItemAtIndex:(NSInteger)index
{
    // Get the right button to select
    UIButton* button = [buttons objectAtIndex:index];
    
    [self dimAllButtonExcept:button];
}

// Add a glow at the bottom of the specified item
- (void) glowItemAtIndex:(NSInteger)index
{
}

// Remove the glow at the bottom of the specified item
- (void) removeGlowAtIndex:(NSInteger)index
{
}
- (void) addTabBarArrowAtIndex:(NSUInteger)itemIndex
{
}
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
    
    // A single tab item's width is the entire width of the tab bar divided by number of items
    CGFloat tabItemWidth = self.frame.size.width / buttons.count;
    // A half width is tabItemWidth divided by 2 minus half the width of the arrow
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
    
    // The horizontal location is the index times the width plus a half width
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

- (NSString*) titleAtIndex:(NSUInteger)itemIndex
{
    return [delegate titleFor:self atIndex:itemIndex];
}

// Create a button at the provided index
- (UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width
{
    // Create a new button with the right dimensions
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0.0, 0.0, width, self.frame.size.height);
    button.frame = CGRectMake((width-25)/2, 5, 25, 25);
    UIImage* rawButtonImage = [delegate imageFor:self atIndex:itemIndex];
    UIImage* buttonImage = rawButtonImage;
    UIImage* buttonPressedImage = [delegate imageforSelected:self atIndex:itemIndex];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setImage:buttonPressedImage forState:UIControlStateSelected];
    
    [button setBackgroundImage:[delegate selectedItemImage] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[delegate selectedItemImage] forState:UIControlStateSelected];
    
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

// Create a tab bar image
-(UIImage*) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource
{
    // The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
    UIImage* backgroundImage = [self tabBarBackgroundImageWithSize:startImage.size backgroundImage:backgroundImageSource];
    
    // Convert the passed in image to a white backround image with a black fill
    UIImage* bwImage = [self blackFilledImageWithWhiteBackgroundUsing:startImage];
    
    // Create an image mask
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
                                             CGImageGetHeight(bwImage.CGImage),
                                             CGImageGetBitsPerComponent(bwImage.CGImage),
                                             CGImageGetBitsPerPixel(bwImage.CGImage),
                                             CGImageGetBytesPerRow(bwImage.CGImage),
                                             CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
    
    // Using the mask create a new image
    CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);
    
    UIImage* tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGImageRelease(imageMask);
    CGImageRelease(tabBarImageRef);
    
    // Create a new context with the right size
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    
    // Draw the new tab bar image at the center
    [tabBarImage drawInRect:CGRectMake((targetSize.width/2.0) - (startImage.size.width/2.0), (targetSize.height/2.0) - (startImage.size.height/2.0), startImage.size.width, startImage.size.height)];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// Convert the image's fill color to black and background to white
-(UIImage*) blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage
{
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, imageRect);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color to black: R:0 G:0 B:0 alpha:1
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    // Fill with black
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

-(UIImage*) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage
{
    // The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    if (backgroundImage)
    {
        // Draw the background image centered
        [backgroundImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backgroundImage.CGImage)) / 2, (targetSize.height - CGImageGetHeight(backgroundImage.CGImage)) / 2, CGImageGetWidth(backgroundImage.CGImage), CGImageGetHeight(backgroundImage.CGImage))];
    }
    else
    {
        [[UIColor whiteColor] set];
        UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
    }
    
    UIImage* finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalBackgroundImage;
}

@end
