//
//  MoMamCalendarDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 22..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamCalendarDetailViewController.h"
#import "MoMamMainViewController.h"
#import "MoMamAddButtonDetailViewController.h"
#import "FSCalendar.h"
#import "MoMamReceiptDetailViewController.h"
@interface MoMamCalendarDetailViewController () <FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *addButtonTapped;

@property (weak, nonatomic) IBOutlet UITableView *calendarDetailTableView;

@end

@implementation MoMamCalendarDetailViewController
- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)addButtonTapped:(id)sender {
   
    MoMamAddButtonDetailViewController *addDetailViewController = [[MoMamAddButtonDetailViewController alloc] init];
    
    addDetailViewController.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:addDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
   
    addDetailViewController.selectCalendarDay.text = self.selectCalendarday.text;
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoMamReceiptDetailViewController *test =[[MoMamReceiptDetailViewController alloc] init];
    [self presentViewController:test animated:UIPopoverArrowDirectionRight completion:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addButtonTapped.layer.cornerRadius = 20.0f;
    self.calendarDetailTableView.delegate = self;
    self.calendarDetailTableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MoMamCalendarDetailViewController" owner:self options:nil];
    }
    return self;
}

@end
