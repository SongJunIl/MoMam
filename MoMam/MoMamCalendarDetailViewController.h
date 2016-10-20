//
//  MoMamCalendarDetailViewController.h
//  MoMam
//
//  Created by 송준일 on 2016. 9. 22..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"

@interface MoMamCalendarDetailViewController : UIViewController <FSCalendarDelegate,FSCalendarDataSource,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *selectCalendarDay;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *totalOutlay;
@property (weak, nonatomic) IBOutlet UILabel *moneyOutlay;
@property (weak, nonatomic) IBOutlet UILabel *cardOutlay;
@end

