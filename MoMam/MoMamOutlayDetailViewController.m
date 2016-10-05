//
//  MoMamOutlayDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 10. 6..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamOutlayDetailViewController.h"

@interface MoMamOutlayDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;

@end

@implementation MoMamOutlayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cashBtn.layer.cornerRadius = 10.0f;
    self.checkCardBtn.layer.cornerRadius = 10.0f;
    self.cardBtn.layer.cornerRadius = 10.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
