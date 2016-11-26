//
//  tacocatView.h
//  tacocat
//
//  Created by Vinay Tota on 7/5/11.
//

#import <ScreenSaver/ScreenSaver.h>

@interface tacocatView : ScreenSaverView {
    NSImage *tacocatImage;
    NSMutableArray * gifFrames;
    
    int shiftRainbow;
    int gifFrameNumber;
}

- (void)drawTacocatRainbowSection: (NSPoint)origin;
- (void)drawBackground;
- (void)drawGround;

@end
