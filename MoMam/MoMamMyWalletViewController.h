//
//  MoMamMyWalletViewController.h
//  MoMam
//
//  Created by 송준일 on 2016. 9. 30..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoMamMyWalletViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *assetsTotal;
@property (weak, nonatomic) IBOutlet UILabel *incomeTotal;
@property (weak, nonatomic) IBOutlet UILabel *outlayTotal;
@property (weak, nonatomic) IBOutlet UILabel *moneyOutlayTotal;
@property (weak, nonatomic) IBOutlet UILabel *cardOutlayTotal;
@end
