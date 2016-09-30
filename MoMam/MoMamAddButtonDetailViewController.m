//
//  MoMamAddButtonDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 22..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamAddButtonDetailViewController.h"

@interface MoMamAddButtonDetailViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *numberSize;

@property (weak, nonatomic) IBOutlet UIPickerView *incomePicker;

@property (weak, nonatomic) IBOutlet UIPickerView *outlayPicker;

@property (weak, nonatomic) IBOutlet UISwitch *incomeSwitch;

@property (weak, nonatomic) IBOutlet UITextField *incomeText;

@property (nonatomic,strong) NSMutableArray *incomeArray;

@end



@implementation MoMamAddButtonDetailViewController

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if(textField == self.incomeText){
//        [textField resignFirstResponder];
//    }
//    return YES;
//}

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
        return 2;
    }


    return 0;
    
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //각 row에 출력해줄 이름을 반환
    
    if(pickerView == _incomePicker){
        return [self.incomeArray objectAtIndex:row];
              
    }else if(pickerView == _outlayPicker){
        return 0;
    }

    return 0;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //피커뷰의 내용이 선택되었을 때 실행되는 델리게이트 메소드입니다.
    self.incomeText.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
}

- (IBAction)incomeBtn:(id)sender {
    
    if(self.incomeSwitch.on == YES ){
        if( [self.incomeText.text isEqualToString:@""] == YES){
            NSLog(@"텍스트란을 확인해주세요");
            
        }else{
            NSLog(@"저장완료");
        }
    }else if(self.incomeSwitch.on == NO){
       
        NSLog(@"체크버튼을확인해주세요");
    }
    
}

- (IBAction)incomeSwitch:(id)sender {
    
    if([sender isOn]){
        NSLog(@"체크온");
        self.incomeSwitch.on = YES;
    }else {
        NSLog(@"체크오프");
        self.incomeSwitch.on = NO;
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
