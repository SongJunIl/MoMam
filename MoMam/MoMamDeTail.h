//
//  MoMamDeTail.h
//  MoMam
//
//  Created by 송준일 on 2016. 9. 12..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoMamDeTail : UIView <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIView *detailView;
//수입
@property (weak, nonatomic) IBOutlet UILabel *income;
//현금잔액
@property (weak, nonatomic) IBOutlet UILabel *money;
//총소비
@property (weak, nonatomic) IBOutlet UILabel *totalOutlay;
//현금소비
@property (weak, nonatomic) IBOutlet UILabel *moneyOutlay;
//카드소비
@property (weak, nonatomic) IBOutlet UILabel *cardOutlay;


@end
