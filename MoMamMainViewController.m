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
@import CoreData;
@interface MoMamMainViewController () 
@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSMutableArray *accountBookArray;

@end

@implementation MoMamMainViewController{
    AccountBook *accountBook;
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
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.mainTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.calendarView.calendarViewc.dataSource = self;
    self.calendarView.calendarViewc.delegate = self;
    self.calendarView.calendarViewc.appearance.cellShape = FSCalendarCellShapeRectangle;
    self.calendarTitle.text = @"MoMam";
    self.mainTableView.delegate=self;
    self.mainTableView.dataSource=self;
    
    UINib *nib = [UINib nibWithNibName:@"MoMamCalendarTableViewCell" bundle:nil];
    [self.mainTableView registerNib:nib forCellReuseIdentifier:@"MoMamCalendarTableViewCell"];
    [self.mainTableView reloadData];
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
    MoMamCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoMamCalendarTableViewCell" forIndexPath:indexPath];
    accountBook = [self.accountBookArray objectAtIndex:indexPath.row];
    cell.price.text = [accountBook.price stringValue];
    if(accountBook.useKinds.intValue == 1){
        cell.classification.text = accountBook.incomeText;
        cell.history.text = accountBook.incomeHistory;
    }else if(accountBook.useKinds.intValue == 2){
        cell.classification.text = accountBook.outlayText;
        cell.history.text = accountBook.outlayHistory;
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
    [self loadAccountBookData];
}

- (void)loadAccountBookData{
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"AccountBook"
                               inManagedObjectContext:self.context];
    FSCalendar *fs = [[FSCalendar alloc] init];
    NSDate *today = [fs today];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay |
                                    NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    NSString *day = [NSString stringWithFormat:@"%ld/%ld", components.year,(long)components.month];
    NSLog(@"%@",day);
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"SELF.selectCalendarDay CONTAINS %@",day];
    [fetch setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *reuslt = [self.context executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Failed to fetch objects: %@", [error description]);
    }
    self.accountBookArray = [reuslt mutableCopy];
}



@end
