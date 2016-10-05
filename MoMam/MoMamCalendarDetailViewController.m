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
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *addButtonTapped;
@property (weak, nonatomic) IBOutlet UITableView *calendarDetailTableView;
@property (weak, nonatomic) IBOutlet UITableView *calendarDetailTable;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addButtonTapped.layer.cornerRadius = 20.0f;
    self.calendarDetailTableView.delegate = self;
    self.calendarDetailTableView.dataSource = self;
    
    array = [NSArray arrayWithObjects:@"Apple", @"Banana", @"Car", @"Dog", @"Elephant", nil];
    
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
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoMamReceiptDetailViewController *receiptDetailViewController = [[MoMamReceiptDetailViewController alloc] init];
    [self presentViewController:receiptDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
}

@end
