//
//  MoMamOutlayDetailViewController.h
//  MoMam
//
//  Created by 송준일 on 2016. 10. 6..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoMamOutlayDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *outlayHistroy;
@property (weak, nonatomic) IBOutlet UILabel *outlayText;
@property (weak, nonatomic) IBOutlet UILabel *selectCalendarDay;
@end
