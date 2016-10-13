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
@end

@implementation MoMamCalendarDetailViewController 
{
   AccountBook *accountBook;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addButtonTapped.layer.cornerRadius = 20.0f;
    self.calendarDetailTableView.delegate = self;
    self.calendarDetailTableView.dataSource = self;
    
    UIView *header = self.headerView;
    [self.calendarDetailTableView setTableHeaderView:header];
    
    UINib *nib = [UINib nibWithNibName:@"MoMamCalendarTableViewCell" bundle:nil];
    [self.calendarDetailTableView registerNib:nib forCellReuseIdentifier:@"MoMamCalendarTableViewCell"];
     self.accountBookArray = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initCoreData];
    [self.calendarDetailTableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MoMamCalendarDetailViewController" owner:self options:nil];
    }
    return self;
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
    }else{
        cell.classification.text = accountBook.outlayText;
        cell.history.text = accountBook.outlayHistory;
        cell.classification.textColor=[UIColor redColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoMamReceiptDetailViewController *receiptDetailViewController = [[MoMamReceiptDetailViewController alloc] init];
    [self presentViewController:receiptDetailViewController animated:UIPopoverArrowDirectionRight completion:nil];
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



@end
