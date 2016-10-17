//
//  MoMamMyWalletViewController.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 30..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamMyWalletViewController.h"

@interface MoMamMyWalletViewController ()



@end

@implementation MoMamMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"MoMamMyWalletViewController" owner:self options:nil];
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
        UITabBarItem *myWallet  = self.tabBarItem;
        
        myWallet.title = @"내 지갑";
        UIImage *myWalletImg = [UIImage imageNamed:@"piggy_bank@2x.png"];
        myWallet.image =myWalletImg;
    }
    return self;
}


@end
