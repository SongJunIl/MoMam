//
//  MoMamMainViewController.h
//  MoMam
//
//  Created by 송준일 on 2016. 9. 12..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "MoMamMainViewController.h"
#import "MoMamCalendarView.h"
#import "MoMamDetail.h"
@class MoMamAddButtonDetailViewController;

@interface MoMamMainViewController : UIViewController <FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
    
@property (weak, nonatomic) IBOutlet MoMamDeTail *detailView;

@property (weak, nonatomic) IBOutlet UILabel *calendarTitle;

@property (weak, nonatomic) IBOutlet UIButton *addButtonTapped;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet MoMamCalendarView *calendarView;

@end
