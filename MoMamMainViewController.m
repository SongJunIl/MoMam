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
@property (nonatomic,strong) NSString *day;
@property (nonatomic,strong) NSString *realday;
@property (nonatomic,strong) NSMutableDictionary *dictinoary;
@end

@implementation MoMamMainViewController{
    AccountBook *accountBook;
    MoMamCalendarTableViewCell *cells;
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
    [self setupLabelDataInit];
    [self setupMainLabelValueSetting];
    [self.mainTableView reloadData];
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
    cells = [tableView dequeueReusableCellWithIdentifier:@"MoMamCalendarTableViewCell" forIndexPath:indexPath];
    accountBook = [self.accountBookArray objectAtIndex:indexPath.row];
    cells.price.text = [self labelTextStyle:accountBook.price];
    if(accountBook.incomeText != nil){
        cells.classification.text = accountBook.incomeText;
        cells.history.text = accountBook.selectCalendarDay;
        if(cells.classification.textColor == [UIColor redColor]){
            cells.classification.textColor = [UIColor grayColor];
        }
    }else {
        cells.classification.text = accountBook.outlayText;
        cells.history.text = accountBook.selectCalendarDay;
        if(accountBook.outlayKinds >0){
            cells.classification.textColor = [UIColor redColor];
        }
    }
  
    return cells;
    
}


//캘린더 날짜 선택시 event
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    MoMamCalendarDetailViewController *calendarDetailViewController = [[MoMamCalendarDetailViewController alloc] init];
    
    calendarDetailViewController.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:calendarDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
    
    //선택한 날짜
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                            NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    calendarDetailViewController.selectCalendarDay.text = [NSString stringWithFormat:@"%ld/%ld/%ld", (long)components.year,(long)components.month,(long)components.day];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
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
    self.realday = [NSString stringWithFormat:@"%ld/%ld", (long)components.year,(long)components.month];
    NSPredicate *predicate;
    if(self.day != nil){
    predicate =[NSPredicate predicateWithFormat:@"SELF.selectCalendarDay CONTAINS %@",self.day];
    [fetch setPredicate:predicate];
    }else{
    predicate =[NSPredicate predicateWithFormat:@"SELF.selectCalendarDay CONTAINS %@",self.realday];
    [fetch setPredicate:predicate];
    }
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
    self.detailView.incomeValueLabel.text = [self labelTextStyle:self.incomeTotal];
    self.detailView.outlayTotalValueLabel.text =[self labelTextStyle:self.outlayTotal];
    self.detailView.outlayCashValueLabel.text = [self labelTextStyle:self.moneyOutlay];
    self.detailView.outlayCardValueLabel.text = [self labelTextStyle:self.cardOutlay];
    self.detailView.remainedCashValueLabel.text = [self labelTextStyle:self.incomeMoney];
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
- (void)calendarCurrentMonthDidChange:(FSCalendar *)calendar FSCalendarDeprecated(-calendarCurrentPageDidChange:){
    NSError *error = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"AccountBook"
                               inManagedObjectContext:self.context];
   
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                                    NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[calendar currentPage]];
     self.day = [NSString stringWithFormat:@"%ld/%ld", (long)components.year,(long)components.month];
NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.selectCalendarDay CONTAINS %@",self.day];
    [fetch setPredicate:predicate];
    NSLog(@"날짜 바뀜%@",self.day);
    NSArray *reuslt = [self.context executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Failed to fetch objects: %@", [error description]);
    }
    self.accountBookArray = [reuslt mutableCopy];
    
    [self setupLabelDataInit];
    [self setupMainLabelValueSetting];
    [self setupLabelTextSetting];
    [self.mainTableView reloadData];
}
- (void)setupMainLabelValueSetting{
    for(int i=0; i<self.accountBookArray.count; i++){
    self.dictinoary =(NSMutableDictionary*)[self.accountBookArray objectAtIndex:i];
    
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
}
    incomeMoneys = incomePrice - outlayPrice;
    self.incomeMoney =@(incomeMoneys);
}
@end
