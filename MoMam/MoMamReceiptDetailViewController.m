//
//  MoMamReceiptDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 10. 3..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamReceiptDetailViewController.h"

@interface MoMamReceiptDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *receiptView;

@end

@implementation MoMamReceiptDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *receiptBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"woodImage.jpg"]];
    [self.view setBackgroundColor:receiptBackgroundColor];
    
    self.receiptView.backgroundColor= [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MoMamReceiptDetailViewController" owner:self options:nil];
    }
    return self;
}

@end
