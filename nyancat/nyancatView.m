//
//  nyancatView.m
//  nyancat
//
//  Created by Vinay Tota on 7/5/11.
//

#import "nyancatView.h"
#import "NyanStarData.h"

@implementation nyancatView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:0.07F];
        
        /**
         *
         * Init image
         *
         **/
        
        NSBundle* bundle = [NSBundle bundleForClass:[self class]];
        NSString* envsPListPath = [bundle pathForResource:@"cat" ofType:@"gif"];
        displayImage = [[[NSImage alloc] initWithContentsOfFile:envsPListPath] autorelease];
        
        // Thanks to http://blog.pcitron.fr/2010/12/14/play-an-animated-gif-with-an-ikimageview/
        // for example code on how to do this
        NSArray * reps = [displayImage representations];
        for (NSImageRep * rep in reps)
        {
            // find the bitmap representation
            if ([rep isKindOfClass:[NSBitmapImageRep class]] == YES)
            {
                // get the bitmap representation
                NSBitmapImageRep * bitmapRep = (NSBitmapImageRep *)rep;
                int numFrame = [[bitmapRep valueForProperty:NSImageFrameCount] intValue];
                
                // create a value array which will contains the frames of the animation
                gifFrames = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < numFrame; ++i)
                {
                    // set the current frame
                    [bitmapRep setProperty:NSImageCurrentFrame withValue:[NSNumber numberWithInt:i]];
                    CGImageRef img = [bitmapRep CGImage];
                    [gifFrames addObject:(id)img];
                }
                
                // stops at the first valid representation
                break;
            }
        }
        
        gifFrameNumber = 0;
        shiftRainbow = 0;
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    // Draw background
    [self drawBackground];
    
    // Draw ground
    [self drawGround];
    
    
    //Figure out where to draw nyancat
    CGImageRef imageRef = (CGImageRef) gifFrames[gifFrameNumber];
    
    NSImage* currentFrame = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    NSSize viewSize  = [self bounds].size;
    NSSize imageSize = NSMakeSize(200, 140);
    
    NSPoint viewCenter;
    viewCenter.x = viewSize.width  * 0.50;
    viewCenter.y = viewSize.height * 0.50;
    
    NSPoint imageOrigin = viewCenter;
    imageOrigin.x -= imageSize.width  * 0.50;
    imageOrigin.y -= imageSize.height * 0.50;
    
    NSRect destRect;
    destRect.origin = imageOrigin;
    destRect.size = imageSize;
    
    // Use NyanCat position to figure out where to draw rainbow
    int lastNyanRainbowEndX = destRect.origin.x + 6;
    int shiftY = 5;
    BOOL shift = NO;
    if(shiftRainbow == 2 || shiftRainbow == 3) {
        shift = YES;
        
    }
    
    int nyanRainbowX = lastNyanRainbowEndX;
    int nyanRainBowY = destRect.origin.y + 2;
    shift = !shift;
    
    // draw rainbow
    while(nyanRainbowX + 46 > 0 ) {
        if(shift) {
            [self drawNyanRainbowSection:NSMakePoint(nyanRainbowX, nyanRainBowY + shiftY)];
        } else {
            [self drawNyanRainbowSection:NSMakePoint(nyanRainbowX, nyanRainBowY)];
        }
        shift = !shift;
        nyanRainbowX -= 46;
    }
    
    // draw kitty
    [currentFrame drawInRect: destRect
                    fromRect: NSZeroRect
                   operation: NSCompositeSourceOver
                    fraction: 1.0];
    
    [currentFrame release];
}

- (void)drawBackground {
    
    // Background color
    float red = 251.0/255.0f;
    float green = 219.0/255.0f;
    float blue = 139.0/255.0f;
    float alpha = 1.0f;
    
    NSColor *color= [NSColor colorWithDeviceRed: red green: green blue: blue alpha: alpha];
    
    [color set];
    NSRectFill([self bounds]);
}

- (void)drawGround {
    
    NSSize viewSize  = [self bounds].size;
    
    NSColor *lineColor= [NSColor colorWithDeviceRed: 0.0f green: 0.0f blue: 0.0f alpha: 1.0f];
    
    [lineColor set];
    NSRectFill(NSMakeRect(0.0f, viewSize.height/5.0f, viewSize.width, 10.0f));
    
    // Ground color
    float red = 187.0/255.0f;
    float green = 164.0/255.0f;
    float blue = 3.0/255.0f;
    float alpha = 1.0f;
    
    NSColor *groundColor= [NSColor colorWithDeviceRed: red green: green blue: blue alpha: alpha];
    
    [groundColor set];
    NSRectFill(NSMakeRect(0.0f, 0.0f, viewSize.width, viewSize.height/5.0f));
}


- (void) drawNyanRainbowSection: (NSPoint)origin {
    int rainbowSectionLength = 46;
    int rainbowSectionHeight = 30;
    
    [[NSColor colorWithDeviceRed: 249.0/255.0f green: 1.0/255.0f blue: 2.0/255.0f alpha: 1.0f] set];
    NSRectFill(NSMakeRect(origin.x,origin.y + 0*rainbowSectionHeight,rainbowSectionLength,rainbowSectionHeight));
    
    [[NSColor colorWithDeviceRed: 1.0f green: 1.0f blue: 1.0f alpha: 1.0f] set];
    NSRectFill(NSMakeRect(origin.x,origin.y + 1*rainbowSectionHeight,rainbowSectionLength,rainbowSectionHeight));
    
    [[NSColor colorWithDeviceRed: 6.0/255.0f green: 167.0/255.0f blue: 6.0/255.0f alpha: 1.0f] set];
    NSRectFill(NSMakeRect(origin.x,origin.y + 2*rainbowSectionHeight,rainbowSectionLength,rainbowSectionHeight));
}

- (void)animateOneFrame
{
    shiftRainbow = (shiftRainbow + 1) % 4;
    gifFrameNumber = (gifFrameNumber + 1) % (int) [gifFrames count];
    [self setNeedsDisplay:YES];
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
