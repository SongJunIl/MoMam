//
//  MoMamMainViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 12..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamMainViewController.h"
#import "MoMamDeTail.h"
#import "MoMamCalendarView.h"
#import "FSCalendar.h"
#import "MoMamAddButtonDetailViewController.h"
#import "MoMamCalendarDetailViewController.h"

@interface MoMamMainViewController () <FSCalendarDelegate,FSCalendarDataSource>


@property (weak, nonatomic) IBOutlet MoMamCalendarView *calendarView;


@end

@implementation MoMamMainViewController
- (IBAction)addButtonTapped:(id)sender {
    
    MoMamAddButtonDetailViewController *addDetailViewController = [[MoMamAddButtonDetailViewController alloc] init];
    
    
    addDetailViewController.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:addDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
    
    FSCalendar *calendar = [[FSCalendar alloc] init];
    NSDate *today = [[NSDate alloc] init];
    today = calendar.today;
   
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                                    NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    addDetailViewController.selectCalendarDay.text = [NSString stringWithFormat:@"%ld월 %ld일", (long)components.month,(long)components.day];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.calendarView.calendarViewc.dataSource = self;
    self.calendarView.calendarViewc.delegate = self;
    self.calendarView.calendarViewc.appearance.cellShape = FSCalendarCellShapeRectangle;
    self.calendarTitle.text = @"MoMom";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//캘린더 날짜 선택시 event
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    MoMamCalendarDetailViewController *calendarDetailViewController = [[MoMamCalendarDetailViewController alloc] init];
    calendarDetailViewController.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:calendarDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];

//    MoMamAddButtonDetailViewController *addDetailViewController = [[MoMamAddButtonDetailViewController alloc] init];
    
    //선택한 날짜
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                            NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    calendarDetailViewController.selectCalendarday.text = [NSString stringWithFormat:@"%ld/%ld/%ld", components.year,(long)components.month,(long)components.day];
}

@end
