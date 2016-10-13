//
//  MoMamAddButtonDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 22..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamAddButtonDetailViewController.h"
#import "MoMamOutlayDetailViewController.h"
#import "MoMamMainViewController.h"
#import "AccountBook.h"
#import "MoMamCalendarDetailViewController.h"

@import CoreData;

@interface MoMamAddButtonDetailViewController ()

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
    
    self.price.delegate=self;
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
    
    [self initCoreData];
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
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
    
    outlayDetailViewController.selectCalendarDay.text = self.selectCalendarDay.text;
    outlayDetailViewController.price.text=self.price.text;
    outlayDetailViewController.outlayText.text=self.outlayText.text;
    outlayDetailViewController.outlayHistroy.text =self.outlayHistory.text;
    
}

- (IBAction)incomeBtn:(id)sender {
    
    NSError *error;
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"AccountBook" inManagedObjectContext:self.context];
    
    AccountBook *acc = [[AccountBook alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:self.context];
    
    acc.selectCalendarDay = self.selectCalendarDay.text;
    acc.price = @([self.price.text stringByReplacingOccurrencesOfString:@"," withString:@""].intValue);
    acc.incomeText = self.incomeText.text;
    acc.incomeHistory = self.incomeHistory.text;
    acc.useKinds = [NSNumber numberWithInt:1];
    
    [self.context save:&error];
    
    if(error != nil)
    {
        NSLog(@"Error :%@",[error localizedFailureReason]);
    }else{
         NSLog(@"성공");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self documentPath];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)initCoreData
{
    NSError *error;
    // Path to data file.
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/accountBook.db"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
        NSLog(@"Error: %@", [error localizedFailureReason]);
    else
    {
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    
}

-(void)documentPath{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDir = [paths objectAtIndex:0];
    NSLog(@"%@", documentDir);
}

@end
