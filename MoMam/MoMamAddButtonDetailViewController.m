//
//  MoMamAddButtonDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 22..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamAddButtonDetailViewController.h"
#import "MoMamOutlayDetailViewController.h"

@interface MoMamAddButtonDetailViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *numberSize;

@property (weak, nonatomic) IBOutlet UIPickerView *incomePicker;

@property (weak, nonatomic) IBOutlet UIPickerView *outlayPicker;

@property (weak, nonatomic) IBOutlet UITextField *incomeText;

@property (weak, nonatomic) IBOutlet UITextField *outlayText;

@property (nonatomic,strong) NSMutableArray *incomeArray;

@property (nonatomic,strong) NSMutableArray *outlayArray;

@property (weak, nonatomic) IBOutlet UIButton *incomeBtn;

@property (weak, nonatomic) IBOutlet UIButton *outlayBtn;

@end



@implementation MoMamAddButtonDetailViewController


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (([string isEqualToString:@"0"] || [string isEqualToString:@""]) && [textField.text rangeOfString:@"."].location < range.location) {
        return YES;
    }
    
    // First check whether the replacement string's numeric...
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    bool isNumeric = [string isEqualToString:filtered];
    
    // Then if the replacement string's numeric, or if it's
    // a backspace, or if it's a decimal point and the text
    // field doesn't already contain a decimal point,
    // reformat the new complete number using
    // NSNumberFormatterDecimalStyle
    if (isNumeric ||
        [string isEqualToString:@""] ||
        ([string isEqualToString:@"."] &&
         [textField.text rangeOfString:@"."].location == NSNotFound)) {
            
            // Create the decimal style formatter
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setMaximumFractionDigits:10];
            
            // Combine the new text with the old; then remove any
            // commas from the textField before formatting
            NSString *combinedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSString *numberWithoutCommas = [combinedText stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSNumber *number = [formatter numberFromString:numberWithoutCommas];
            
            NSString *formattedString = [formatter stringFromNumber:number];
            
            // If the last entry was a decimal or a zero after a decimal,
            // re-add it here because the formatter will naturally remove
            // it.
            if ([string isEqualToString:@"."] &&
                range.location == textField.text.length) {
                formattedString = [formattedString stringByAppendingString:@"."];
            }
            
            textField.text = formattedString;
            
        }
    
    // Return no, because either the replacement string is not 
    // valid or it is and the textfield has already been updated
    // accordingly
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberSize.delegate=self;
    self.incomePicker.delegate=self;
    self.incomePicker.dataSource=self;
    self.outlayPicker.delegate=self;
    self.outlayPicker.dataSource=self;
    
    self.incomeArray = [[NSMutableArray alloc]initWithObjects:@"월급",@"용돈",@"이월",nil];
    self.incomeText.text = [self.incomeArray objectAtIndex:0];
    
    self.outlayArray = [[NSMutableArray alloc] initWithObjects:@"카드대금",@"저축",@"식비",@"교통비",@"문화생활",nil];
    self.outlayText.text = [self.outlayArray objectAtIndex:0];
    
    self.incomeBtn.layer.cornerRadius = 10.0f;
    self.outlayBtn.layer.cornerRadius = 10.0f;
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MoMamAddButtonDetailViewController" owner:self options:nil];
    }
    return self;
}


- (IBAction)backButton:(id)sender {
    
 [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //컴포넌트 수를 정해주는 메소드
    return 1;
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //피커뷰의 몇개의 줄로 할당 될것인지 정해주느 메소드
    
    if(pickerView == _incomePicker){
        return self.incomeArray.count;
    }else if(pickerView == _outlayPicker){
        return self.outlayArray.count;
    }

    return 0;
    
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //각 row에 출력해줄 이름을 반환
    
    if(pickerView == _incomePicker){
        return [self.incomeArray objectAtIndex:row];
              
    }else if(pickerView == _outlayPicker){
        return [self.outlayArray objectAtIndex:row];
    }

    return 0;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //피커뷰의 내용이 선택되었을 때 실행되는 델리게이트 메소드입니다.
    if(pickerView == _incomePicker){
    self.incomeText.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }else if(pickerView == _outlayPicker){
    self.outlayText.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
}
- (IBAction)outlayBtn:(id)sender {
    
    MoMamOutlayDetailViewController *outlayDetailViewController = [[MoMamOutlayDetailViewController alloc] init];
     [self presentViewController:outlayDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
    
}

- (IBAction)incomeBtn:(id)sender {
  
    
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
