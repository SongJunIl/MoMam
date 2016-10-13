//
//  MoMamOutlayDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 10. 6..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamOutlayDetailViewController.h"
#import "AccountBook.h"
@import CoreData;
@interface MoMamOutlayDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cashBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation MoMamOutlayDetailViewController{
    AccountBook *acc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.cashBtn.layer.cornerRadius = 10.0f;
    self.checkCardBtn.layer.cornerRadius = 10.0f;
    self.cardBtn.layer.cornerRadius = 10.0f;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initCoreData];
}

- (IBAction)cashBtn:(id)sender {
    [self outlayInfo];
    acc.outlayKinds = [NSNumber numberWithInt:1];
    [self dataSave];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)checkCardBtn:(id)sender {
    [self outlayInfo];
    acc.outlayKinds = [NSNumber numberWithInt:2];
    [self dataSave];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cardBtn:(id)sender {
    [self outlayInfo];
    acc.outlayKinds = [NSNumber numberWithInt:3];
    [self dataSave];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)outlayInfo{
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"AccountBook" inManagedObjectContext:self.context];
    acc = [[AccountBook alloc]initWithEntity:entitydesc insertIntoManagedObjectContext:self.context];
    acc.selectCalendarDay = self.selectCalendarDay.text;
    acc.price = @([self.price.text stringByReplacingOccurrencesOfString:@"," withString:@""].intValue);
    acc.outlayText = self.outlayText.text;
    acc.outlayHistory = self.outlayHistroy.text;
    acc.useKinds = [NSNumber numberWithInt:2];
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
@end
