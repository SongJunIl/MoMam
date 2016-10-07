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
#import "MoMamCalendarTableViewCell.h"
@interface MoMamMainViewController () 
@property (weak, nonatomic) IBOutlet MoMamCalendarView *calendarView;
@end

@implementation MoMamMainViewController{
    NSArray *array;
}



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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        self.tabBarItem.title = @"홈";
        
        UIImage *home = [UIImage imageNamed:@"house@2x.png"];
        self.tabBarItem.image = home;
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.calendarView.calendarViewc.dataSource = self;
    self.calendarView.calendarViewc.delegate = self;
    self.calendarView.calendarViewc.appearance.cellShape = FSCalendarCellShapeRectangle;
    self.calendarTitle.text = @"MoMam";
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    UINib *nib = [UINib nibWithNibName:@"MoMamCalendarTableViewCell" bundle:nil];
    [self.mainTableView registerNib:nib forCellReuseIdentifier:@"MoMamCalendarTableViewCell"];
    
    array = [NSArray arrayWithObjects:@"Apple", @"Banana", @"Car", @"Dog", @"Elephant", nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MoMamCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoMamCalendarTableViewCell" forIndexPath:indexPath];
    cell.classification.text = [array objectAtIndex:indexPath.row];
    return cell;
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
