//
//  GDSlider.m
//  Grado
//
//  Created by Joe Barbour on 20/04/2016.
//  Copyright © 2016 NorthernSpark. All rights reserved.
//

#import "GDSlider.h"

@implementation GDSlider

-(CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0.0, 0.0, self.bounds.size.width, 8.0);
    
}

@end
