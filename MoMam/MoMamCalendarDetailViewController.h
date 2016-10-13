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
@property (nonatomic,strong) NSManagedObjectContext *context;
-(void)loadAccountBookData;
@end
