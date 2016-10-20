//
//  MoMamMyWalletViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 30..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamMyWalletViewController.h"
@import CoreData;
@interface MoMamMyWalletViewController ()
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSMutableDictionary *accountBookArray;
@property (nonatomic,strong) NSNumber *incomeTotalInfo;
@property (nonatomic,strong) NSNumber *outlayTotalInfo;
@property (nonatomic,strong) NSNumber *moneyOutlayInfo;
@property (nonatomic,strong) NSNumber *cardOutlayInfo;
@property (nonatomic,strong) NSNumber *incomeMoneyInfo;
@end

@implementation MoMamMyWalletViewController{
    int incomePrices;
    int incomeMoneys;
    int moneyOutlays;
    int outlayPrices;
    int cardOutlays;
}
-(void)viewDidAppear:(BOOL)animated{
    for(int i =0; i<self.accountBookArray.count; i++){
    if([[[self.accountBookArray valueForKey:@"useKinds"]objectAtIndex:i]intValue] == 1){
        incomeMoneys += [[[self.accountBookArray valueForKey:@"price"] objectAtIndex:i]intValue];
        self.incomeMoneyInfo = @(incomeMoneys);
    }else if([[[self.accountBookArray valueForKey:@"useKinds"]objectAtIndex:i ] intValue] == 2 ){
        outlayPrices += [[[self.accountBookArray valueForKey:@"price"]objectAtIndex:i ] intValue];
        self.outlayTotalInfo = @(outlayPrices);
        if([[[self.accountBookArray valueForKey:@"outlayKinds"]objectAtIndex:i ]intValue] == 1 ){
            moneyOutlays += [[[self.accountBookArray valueForKey:@"price"] objectAtIndex:i]intValue];
            self.moneyOutlayInfo =@(moneyOutlays);
        }else{
            cardOutlays += [[[self.accountBookArray valueForKey:@"price"] objectAtIndex:i]intValue];
            self.cardOutlayInfo =@(cardOutlays);
        }
    }
    incomePrices = incomeMoneys - outlayPrices;
    self.incomeTotalInfo =@(incomePrices);
    }
    [self setupLabelTextSetting];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self initCoreData];
    [self setupLabelDataInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MoMamMyWalletViewController" owner:self options:nil];
    }
    return self;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        UITabBarItem *myWallet  = self.tabBarItem;
        
        myWallet.title = @"내 지갑";
        UIImage *myWalletImg = [UIImage imageNamed:@"piggy_bank@2x.png"];
        myWallet.image =myWalletImg;
    }
    return self;
}

-(void)initCoreData{
    NSError *error;
    // Path to data file.
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/accountBook.db"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]){
        NSLog(@"Error: %@", [error localizedFailureReason]);
    }else{
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    [self loadAccountBookData];
}

- (void)loadAccountBookData{
    NSError *error = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"AccountBook"
                               inManagedObjectContext:self.context];
    NSArray *reuslt = [self.context executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Failed to fetch objects: %@", [error description]);
    }
    self.accountBookArray = [reuslt mutableCopy];
}

-(NSString *)labelTextStyle:(NSNumber*)labelText{
    NSString *label = [NSNumberFormatter localizedStringFromNumber:labelText numberStyle:NSNumberFormatterDecimalStyle];
    return label;
}

-(void)setupLabelDataInit{
    incomePrices = 0;
    outlayPrices = 0;
    moneyOutlays = 0;
    cardOutlays = 0;
    incomeMoneys =0;
    self.incomeMoneyInfo =@(0);
    self.incomeTotalInfo =@(0);
    self.outlayTotalInfo =@(0);
    self.moneyOutlayInfo =@(0);
    self.cardOutlayInfo  =@(0);
}
-(void)setupLabelTextSetting{
    self.assetsTotal.text = [self labelTextStyle:self.incomeTotalInfo];
    self.incomeTotal.text = [self labelTextStyle:self.incomeMoneyInfo];
    self.outlayTotal.text =[self labelTextStyle:self.outlayTotalInfo];
    self.moneyOutlayTotal.text = [self labelTextStyle:self.moneyOutlayInfo];
    self.cardOutlayTotal.text = [self labelTextStyle:self.cardOutlayInfo];
}
@end
