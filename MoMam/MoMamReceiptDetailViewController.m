//
//  MoMamReceiptDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 10. 3..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamReceiptDetailViewController.h"
#import "AccountBook.h"
@import CoreData;

@interface MoMamReceiptDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *receiptView;
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation MoMamReceiptDetailViewController
{
    AccountBook *accountBook;
}

-(void)viewWillAppear:(BOOL)animated{
       [self initCoreData];
}
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

- (IBAction)backButton:(id)sender {
    [self savechanges];
    [self dataSave];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dataSave{
    NSError *error;
    [self.context save:&error];
    if(error != nil)
    {
        NSLog(@"Error :%@",[error localizedFailureReason]);
    }else{
        NSLog(@"성공");
    }
}

-(void)savechanges{
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"AccountBook"];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"accountBookNumber==%f AND selectCalendarDay == %@",self.orderNumber.text.doubleValue,self.selectCalendarDay.text];
    [fetchRequest setPredicate:predicate];
    accountBook=[[self.context executeFetchRequest:fetchRequest error:nil]lastObject];
   
    [accountBook setPrice: @([self.priceText.text stringByReplacingOccurrencesOfString:@"," withString:@""].intValue)];
    if(accountBook.useKinds.intValue == 1){
    [accountBook setIncomeText:self.classification.text];
    [accountBook setIncomeHistory:self.history.text];
    [accountBook setNote:self.note.text];
    }else{
    [accountBook setOutlayText:self.classification.text];
    [accountBook setOutlayHistory:self.history.text];
    [accountBook setNote:self.note.text];
    }
    [self.context save:nil];
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
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(NSString *)labelTextStyle:(NSNumber*)labelText{
    NSString *label = [NSNumberFormatter localizedStringFromNumber:labelText numberStyle:NSNumberFormatterDecimalStyle];
    return label;
}
@end
