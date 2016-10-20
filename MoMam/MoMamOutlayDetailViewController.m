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
@property (nonatomic,strong) NSMutableArray *accountBookArray;
@end

@implementation MoMamOutlayDetailViewController{
    AccountBook *acc;
    double order;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBtnsCornerRadius];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if([self.accountBookArray count] == 0){
        order = 1.0;
    }else{
        order = [[self.accountBookArray lastObject] accountBookNumber] + 1.0;
    }
    acc.accountBookNumber = order;
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
-(void)initCoreData{
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
    [self loadAccountBookData];
}
- (void)loadAccountBookData{
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"AccountBook"
                               inManagedObjectContext:self.context];
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.selectCalendarDay LIKE %@",self.selectCalendarDay.text];
    [fetch setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *reuslt = [self.context executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Failed to fetch objects: %@", [error description]);
    }
    self.accountBookArray = [reuslt mutableCopy];
}
-(void)setupBtnsCornerRadius{
    self.cashBtn.layer.cornerRadius = 10.0f;
    self.checkCardBtn.layer.cornerRadius = 10.0f;
    self.cardBtn.layer.cornerRadius = 10.0f;
}

@end
