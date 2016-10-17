//
//  MoMamReceiptDetailViewController.h
//  MoMam
//
//  Created by 송준일 on 2016. 10. 3..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoMamReceiptDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *selectCalendarDay;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *classification;
@property (weak, nonatomic) IBOutlet UITextField *history;
@property (weak, nonatomic) IBOutlet UITextField *note;
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;

@end
