//
//  MoMamCalendarDetailViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 22..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamCalendarDetailViewController.h"
#import "MoMamMainViewController.h"
#import "MoMamAddButtonDetailViewController.h"
#import "MoMamReceiptDetailViewController.h"
#import "MoMamCalendarTableViewCell.h"
#import "AccountBook.h"
@import CoreData;
@interface MoMamCalendarDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addButtonTapped;
@property (weak, nonatomic) IBOutlet UITableView *calendarDetailTableView;
@property (nonatomic,strong) IBOutlet UIView *headerView;
@property (nonatomic,strong) NSMutableArray *accountBookArray;
@property (nonatomic,strong) NSMutableDictionary *dictinoary;
@property (nonatomic,strong) NSNumber *incomeTotal;
@property (nonatomic,strong) NSNumber *outlayTotal;
@property (nonatomic,strong) NSNumber *moneyOutlayInfo;
@property (nonatomic,strong) NSNumber *cardOutlayInfo;
@property (nonatomic,strong) NSManagedObjectContext *context;
@end

@implementation MoMamCalendarDetailViewController {
   AccountBook *accountBook;
    int incomePrice;
    int moneyOutlays;
    int outlayPrice;
    int cardOutlays;
}
- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addButtonTapped:(id)sender {
    MoMamAddButtonDetailViewController *addDetailViewController = [[MoMamAddButtonDetailViewController alloc] init];
    addDetailViewController.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:addDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
    addDetailViewController.selectCalendarDay.text = self.selectCalendarDay.text;
}

- (IBAction)toggleEditingMode:(id)sender{
    if(self.calendarDetailTableView.isEditing){
        [sender setTitle:@"수정" forState:UIControlStateNormal];
        [self.calendarDetailTableView setEditing:NO animated:YES];
    }else{
        [sender setTitle:@"닫기" forState:UIControlStateNormal];
        [self.calendarDetailTableView setEditing:YES animated:YES];
    }
}

- (UIView *)headerView{
    if(!_headerView){
        [[NSBundle mainBundle] loadNibNamed:@"MoMamCalendarDetailHeaderView" owner:self options:nil];
    }
    return _headerView;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        accountBook = [self.accountBookArray objectAtIndex:indexPath.row];
        [self.context deleteObject:accountBook];
        [self dataSave];
        [self.accountBookArray removeObjectAtIndex:indexPath.row];
        [self.calendarDetailTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDelegateAndDataSource];
    [self setupTableCellorHeader];
    self.addButtonTapped.layer.cornerRadius = 20.0f;
}

-(void)viewWillAppear:(BOOL)animated{
    [self initCoreData];
    [self setupLabelDataInit];
    [self.calendarDetailTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [self setupLabelTextSetting];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MoMamCalendarDetailViewController" owner:self options:nil];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.accountBookArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoMamCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoMamCalendarTableViewCell" forIndexPath:indexPath];
    accountBook = [self.accountBookArray objectAtIndex:indexPath.row];
    
    cell.price.text = [self labelTextStyle:accountBook.price];
   
    if(accountBook.useKinds.intValue == 1){
        cell.classification.text = accountBook.incomeText;
        cell.history.text = accountBook.incomeHistory;
    }else if(accountBook.useKinds.intValue ==2 ){
        cell.classification.text = accountBook.outlayText;
        cell.history.text = accountBook.outlayHistory;
        cell.classification.textColor=[UIColor redColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoMamReceiptDetailViewController *receiptDetailViewController = [[MoMamReceiptDetailViewController alloc] init];
    [self presentViewController:receiptDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
    receiptDetailViewController.selectCalendarDay.text = accountBook.selectCalendarDay;
    NSMutableDictionary *dictinoary=(NSMutableDictionary*)[self.accountBookArray objectAtIndex:indexPath.row];
    receiptDetailViewController.priceText.text =[self labelTextStyle:[dictinoary valueForKey:@"price"]];
    receiptDetailViewController.orderNumber.text = [[dictinoary valueForKey:@"accountBookNumber"] stringValue];
    if([dictinoary valueForKey:@"outlayHistory"]==nil){
    receiptDetailViewController.history.text =[dictinoary valueForKey:@"incomeHistory"];
    receiptDetailViewController.classification.text = [dictinoary valueForKey:@"incomeText"];
    receiptDetailViewController.note.text = [dictinoary valueForKey:@"note"];
    }else{
    receiptDetailViewController.history.text =[dictinoary valueForKey:@"outlayHistory"];
    receiptDetailViewController.classification.text = [dictinoary valueForKey:@"outlayText"];
    receiptDetailViewController.note.text = [dictinoary valueForKey:@"note"];
    }

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
            self.moneyOutlayInfo =@(moneyOutlays);
            NSLog(@"현금 총소비 %d",moneyOutlays);
        }else{
            cardOutlays += [[self.dictinoary valueForKey:@"price"]intValue];
            self.cardOutlayInfo =@(cardOutlays);
            NSLog(@"카드 총소비 %d",cardOutlays);
        }
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

-(void)setupLabelDataInit{
    incomePrice = 0;
    outlayPrice = 0;
    moneyOutlays = 0;
    cardOutlays = 0;
    self.incomeTotal =@(0);
    self.outlayTotal =@(0);
    self.moneyOutlayInfo =@(0);
    self.cardOutlayInfo  =@(0);

}
-(void)setupTableCellorHeader{
    UIView *header = self.headerView;
    [self.calendarDetailTableView setTableHeaderView:header];
    
    UINib *nib = [UINib nibWithNibName:@"MoMamCalendarTableViewCell" bundle:nil];
    [self.calendarDetailTableView registerNib:nib forCellReuseIdentifier:@"MoMamCalendarTableViewCell"];
    self.accountBookArray = [[NSMutableArray alloc] init];
}
-(void)setupDelegateAndDataSource{
    self.calendarDetailTableView.delegate = self;
    self.calendarDetailTableView.dataSource = self;
}
-(void)setupLabelTextSetting{
    self.income.text = [self labelTextStyle:self.incomeTotal];
    self.totalOutlay.text =[self labelTextStyle:self.outlayTotal];
    self.moneyOutlay.text = [self labelTextStyle:self.moneyOutlayInfo];
    self.cardOutlay.text = [self labelTextStyle:self.cardOutlayInfo];
}
-(NSString *)labelTextStyle:(NSNumber*)labelText{
    NSString *label = [NSNumberFormatter localizedStringFromNumber:labelText numberStyle:NSNumberFormatterDecimalStyle];
    return label;
}

@end
