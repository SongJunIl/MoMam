//
//  MoMamAddButtonDetailViewController.h
//  MoMam
//
//  Created by 송준일 on 2016. 9. 22..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountBook.h"

@interface MoMamAddButtonDetailViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>



@property (weak, nonatomic) IBOutlet UILabel *selectCalendarDay;

@property (weak, nonatomic) IBOutlet UITextField *price;

@property (weak, nonatomic) IBOutlet UITextField *incomeHistory;

@property (weak, nonatomic) IBOutlet UIPickerView *incomePicker;

@property (weak, nonatomic) IBOutlet UIPickerView *outlayPicker;

@property (weak, nonatomic) IBOutlet UITextField *incomeText;

@property (weak, nonatomic) IBOutlet UITextField *outlayText;

@property (weak, nonatomic) IBOutlet UITextField *outlayHistory;

-(IBAction)incomeBtn:(id)sender;
- (void)initCoreData;
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSArray *object;
@end
