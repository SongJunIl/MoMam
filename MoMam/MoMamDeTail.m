//
//  MoMamDeTail.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 12..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamDeTail.h"

@implementation MoMamDeTail
  
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MoMamDeTail" owner:self options:nil];
        [self addSubview:self.detailView];
    }
    return self;
}


@end
