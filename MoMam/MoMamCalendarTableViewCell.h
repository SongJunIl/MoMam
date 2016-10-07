//
//  MoMamCalendarTableViewCell.h
//  MoMam
//
//  Created by 송준일 on 2016. 10. 6..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoMamCalendarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *classification;
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
