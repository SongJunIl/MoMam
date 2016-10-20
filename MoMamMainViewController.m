//
//  MoMamMainViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 12..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamMainViewController.h"
#import "MoMamDeTail.h"
#import "FSCalendar.h"
#import "MoMamAddButtonDetailViewController.h"
#import "MoMamCalendarDetailViewController.h"
#import "MoMamCalendarTableViewCell.h"
#import "MoMamMyWalletViewController.h"
@import CoreData;

@interface MoMamMainViewController () 
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSMutableArray *accountBookArray;
@property (nonatomic,strong) NSNumber *incomeTotal;
@property (nonatomic,strong) NSNumber *outlayTotal;
@property (nonatomic,strong) NSNumber *moneyOutlay;
@property (nonatomic,strong) NSNumber *cardOutlay;
@property (nonatomic,strong) NSNumber *incomeMoney;
@property (nonatomic,strong) NSMutableDictionary *dictinoary;
@end

@implementation MoMamMainViewController{
    AccountBook *accountBook;
    MoMamCalendarTableViewCell *cell;
    int incomePrice;
    int incomeMoneys;
    int moneyOutlays;
    int outlayPrice;
    int cardOutlays;
}

- (IBAction)addButtonTapped:(id)sender {
    MoMamAddButtonDetailViewController *addDetailViewController = [[MoMamAddButtonDetailViewController alloc] initWithNibName:@"MoMamAddButtonDetailViewController" bundle:nil];
    addDetailViewController.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:addDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
    FSCalendar *calendar = [[FSCalendar alloc] init];
    NSDate *today = [[NSDate alloc] init];
    today = calendar.today;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                                    NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    addDetailViewController.selectCalendarDay.text = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)components.year,(long)components.month,(long)components.day];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.tabBarItem.title = @"홈";
        UIImage *home = [UIImage imageNamed:@"house@2x.png"];
        self.tabBarItem.image = home;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self initCoreData];
    [self.mainTableView reloadData];
    [self setupLabelDataInit];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self setupLabelTextSetting];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self delegateAndDataSourceSetting];
    
    
    self.calendarTitle.text = @"MoMam";
    UINib *nib = [UINib nibWithNibName:@"MoMamCalendarTableViewCell" bundle:nil];
    [self.mainTableView registerNib:nib forCellReuseIdentifier:@"MoMamCalendarTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accountBookArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [tableView dequeueReusableCellWithIdentifier:@"MoMamCalendarTableViewCell" forIndexPath:indexPath];
    accountBook = [self.accountBookArray objectAtIndex:indexPath.row];
    cell.price.text = [self labelTextStyle:accountBook.price];
    
    if(accountBook.useKinds.intValue == 1){
        cell.classification.text = accountBook.incomeText;
        cell.history.text = accountBook.selectCalendarDay;
    }else if(accountBook.useKinds.intValue == 2){
        cell.classification.text = accountBook.outlayText;
        cell.history.text = accountBook.selectCalendarDay;
        cell.classification.textColor = [UIColor redColor];
    }
    return cell;
}


//캘린더 날짜 선택시 event
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    MoMamCalendarDetailViewController *calendarDetailViewController = [[MoMamCalendarDetailViewController alloc] init];
    
    calendarDetailViewController.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:calendarDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
    
    //선택한 날짜
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                            NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    calendarDetailViewController.selectCalendarDay.text = [NSString stringWithFormat:@"%ld/%ld/%ld", components.year,(long)components.month,(long)components.day];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.dictinoary =(NSMutableDictionary*)[self.accountBookArray objectAtIndex:indexPath.row];
   
    if([[self.dictinoary valueForKey:@"useKinds"] intValue] == 1){
            incomePrice += [[self.dictinoary valueForKey:@"price"]intValue];
            self.incomeTotal = @(incomePrice);
            NSLog(@"총 수입 : %d",incomePrice);
    }else if([[self.dictinoary valueForKey:@"useKinds"] intValue] == 2 ){
            outlayPrice += [[self.dictinoary valueForKey:@"price"] intValue];
            self.outlayTotal = @(outlayPrice);
            NSLog(@"총 소비 : %d",outlayPrice);
        if([[self.dictinoary valueForKey:@"outlayKinds"] intValue] == 1 ){
            moneyOutlays += [[self.dictinoary valueForKey:@"price"]intValue];
            self.moneyOutlay =@(moneyOutlays);
            NSLog(@"현금 총소비 %d",moneyOutlays);
        }else{
            cardOutlays += [[self.dictinoary valueForKey:@"price"]intValue];
            self.cardOutlay =@(cardOutlays);
            NSLog(@"카드 총소비 %d",cardOutlays);
        }
    }
    incomeMoneys = incomePrice - outlayPrice;
    self.incomeMoney =@(incomeMoneys);
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
    FSCalendar *fs = [[FSCalendar alloc] init];
    NSDate *today = [fs today];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                                    NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    NSString *day = [NSString stringWithFormat:@"%ld/%ld", components.year,(long)components.month];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.selectCalendarDay CONTAINS %@",day];
    [fetch setPredicate:predicate];
    
    NSArray *reuslt = [self.context executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Failed to fetch objects: %@", [error description]);
    }
    self.accountBookArray = [reuslt mutableCopy];
   
}
-(void)setupLabelDataInit{
    incomePrice = 0;
    outlayPrice = 0;
    moneyOutlays = 0;
    cardOutlays = 0;
    incomeMoneys =0;
    self.incomeMoney =@(0);
    self.incomeTotal =@(0);
    self.outlayTotal =@(0);
    self.moneyOutlay =@(0);
    self.cardOutlay  =@(0);
}
-(void)setupLabelTextSetting{
//    NSString *test = [NSNumberFormatter localizedStringFromNumber:@(self.incomeTotal.intValue) numberStyle:NSNumberFormatterDecimalStyle];
    self.detailView.income.text = [self labelTextStyle:self.incomeTotal];
    self.detailView.totalOutlay.text =[self labelTextStyle:self.outlayTotal];
    self.detailView.moneyOutlay.text = [self labelTextStyle:self.self.moneyOutlay];
    self.detailView.cardOutlay.text = [self labelTextStyle:self.self.cardOutlay];
    self.detailView.money.text = [self labelTextStyle:self.incomeMoney];
}
- (void)delegateAndDataSourceSetting{
    self.calendarView.calendarViewc.dataSource = self;
    self.calendarView.calendarViewc.delegate = self;
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
}
-(NSString *)labelTextStyle:(NSNumber*)labelText{
    NSString *label = [NSNumberFormatter localizedStringFromNumber:labelText numberStyle:NSNumberFormatterDecimalStyle];
    return label;
}
@end
