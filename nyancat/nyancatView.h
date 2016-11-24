//
//  nyancatView.h
//  nyancat
//
//  Created by Vinay Tota on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import "NyanStarData.h"

@interface nyancatView : ScreenSaverView {
    NSImage *displayImage;
    int shiftRainbow;
    int gifFrameNumber;
    NSMutableArray * gifFrames;
}

- (void)drawNyanRainbowSection: (NSPoint)origin;
- (void)drawBackground;
- (void)drawGround;

@end
