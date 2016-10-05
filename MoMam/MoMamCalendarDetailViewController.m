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
#import "MoMamReceiptDetailViewController.h"


@interface MoMamCalendarDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addButtonTapped;
@property (weak, nonatomic) IBOutlet UITableView *calendarDetailTableView;
@property (nonatomic,strong) IBOutlet UIView *headerView;
@end

@implementation MoMamCalendarDetailViewController{
    NSArray *array;
}
- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)addButtonTapped:(id)sender {
   
    MoMamAddButtonDetailViewController *addDetailViewController = [[MoMamAddButtonDetailViewController alloc] init];
    
    addDetailViewController.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:addDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
   
    addDetailViewController.selectCalendarDay.text = self.selectCalendarday.text;
   
}

- (IBAction)toggleEditingMode:(id)sender{
    if(self.calendarDetailTableView.isEditing){
        [sender setTitle:@"수정" forState:UIControlStateNormal];
        [self.calendarDetailTableView setEditing:NO animated:YES];
    }else{
        [sender setTitle:@"닫기" forState:UIControlStateNormal];
        [self.calendarDetailTableView setEditing:YES animated:YES];
    }
}

- (UIView *)headerView{
    if(!_headerView){
        [[NSBundle mainBundle] loadNibNamed:@"MoMamCalendarDetailHeaderView" owner:self options:nil];
    }
    return _headerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addButtonTapped.layer.cornerRadius = 20.0f;
    self.calendarDetailTableView.delegate = self;
    self.calendarDetailTableView.dataSource = self;
    
    array = [NSArray arrayWithObjects:@"Apple", @"Banana", @"Car", @"Dog", @"Elephant", nil];
    
    UIView *header = self.headerView;
    [self.calendarDetailTableView setTableHeaderView:header];
    [self.calendarDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.calendarDetailTableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoMamReceiptDetailViewController *receiptDetailViewController = [[MoMamReceiptDetailViewController alloc] init];
    [self presentViewController:receiptDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
}


@end
