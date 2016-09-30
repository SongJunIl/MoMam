//
//  MoMamAddButtonDetailViewController.h
//  MoMam
//
//  Created by 송준일 on 2016. 9. 22..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoMamAddButtonDetailViewController : UIViewController <UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectCalendarDay;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

- (IBAction)backButton:(id)sender;

@end
