//
//  MoMamDeTail.m
//  MoMam
//
//  Created by 송준일 on 2016. 9. 12..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//

#import "MoMamDeTail.h"

@interface MoMamDeTail()

@property (nonatomic, strong) UIView *incomeContainer;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *remainedCashLabel;
@property (nonatomic, strong) UIView *outlayContainer;
@property (nonatomic, strong) UILabel *outlayTotalLabel;
@property (nonatomic, strong) UILabel *outlayCashLabel;
@property (nonatomic, strong) UILabel *outlayCardLabel;


@end

@implementation MoMamDeTail
  
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        [self setupContainers];
        [self setupIncomeContainer];
        [self setupOutlayContainer];
    }
    return self;
}

- (void)setupContainers {
    self.incomeContainer = [[UIView alloc] init];
    self.incomeContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.incomeContainer];
    
    self.outlayContainer = [[UIView alloc] init];
    self.outlayContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.outlayContainer];
    
    [self setupLayoutConstraints];
}

- (void)setupIncomeContainer {
    self.incomeLabel = [[UILabel alloc] init];
    self.incomeLabel.text = @"수입";
    self.incomeLabel.textColor =[UIColor grayColor];
    self.incomeLabel.font=[UIFont systemFontOfSize:15];
    self.incomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.incomeContainer addSubview:self.incomeLabel];
    
    self.incomeValueLabel = [[UILabel alloc] init];
    self.incomeValueLabel.textColor =[UIColor colorWithRed:107.0/255.0 green:223.0/255.0 blue:73.0/255.0 alpha:1.0];
    self.incomeValueLabel.font=[UIFont systemFontOfSize:17];
    self.incomeValueLabel.textAlignment = NSTextAlignmentRight;
    self.incomeValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.incomeContainer addSubview:self.incomeValueLabel];
    
    self.remainedCashLabel = [[UILabel alloc] init];
    self.remainedCashLabel.text = @"현금 잔액";
    self.remainedCashLabel.textColor =[UIColor grayColor];
    self.remainedCashLabel.font=[UIFont systemFontOfSize:15];
    self.remainedCashLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.incomeContainer addSubview:self.remainedCashLabel];
    
    self.remainedCashValueLabel = [[UILabel alloc] init];
    self.remainedCashValueLabel.textAlignment = NSTextAlignmentRight;
    self.remainedCashValueLabel.font=[UIFont systemFontOfSize:17];
    self.remainedCashValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.incomeContainer addSubview:self.remainedCashValueLabel];
    
    [self setupIncomeContainerConstraints];
}

- (void)setupOutlayContainer{
   
    self.outlayTotalLabel = [[UILabel alloc] init];
    self.outlayTotalLabel.text = @"지출 합계";
    self.outlayTotalLabel.textColor =[UIColor grayColor];
    self.outlayTotalLabel.font=[UIFont systemFontOfSize:15];
    self.outlayTotalLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.outlayContainer addSubview:self.outlayTotalLabel];
    
    self.outlayTotalValueLabel = [[UILabel alloc] init];
    self.outlayTotalValueLabel.textColor =[UIColor colorWithRed:198.0/255.0 green:51.0/255.0 blue:42.0/255.0 alpha:1.0];
    self.outlayTotalValueLabel.font=[UIFont systemFontOfSize:17];
    self.outlayTotalValueLabel.textAlignment = NSTextAlignmentRight;
    self.outlayTotalValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.outlayContainer addSubview:self.outlayTotalValueLabel];
    
    self.outlayCashLabel = [[UILabel alloc] init];
    self.outlayCashLabel.text = @"현금 지출";
    self.outlayCashLabel.textColor =[UIColor grayColor];
    self.outlayCashLabel.font=[UIFont systemFontOfSize:11];
    self.outlayCashLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.outlayContainer addSubview:self.outlayCashLabel];
    
    self.outlayCashValueLabel = [[UILabel alloc] init];
    self.outlayCashValueLabel.textColor =[UIColor colorWithRed:198.0/255.0 green:51.0/255.0 blue:42.0/255.0 alpha:1.0];
    self.outlayCashValueLabel.font=[UIFont systemFontOfSize:13];
    self.outlayCashValueLabel.textAlignment = NSTextAlignmentRight;
    self.outlayCashValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.outlayContainer addSubview:self.outlayCashValueLabel];
    
    self.outlayCardLabel = [[UILabel alloc] init];
    self.outlayCardLabel.text = @"카드 지출";
    self.outlayCardLabel.textColor =[UIColor grayColor];
    self.outlayCardLabel.font=[UIFont systemFontOfSize:11];
    self.outlayCardLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.outlayContainer addSubview:self.outlayCardLabel];
    
    self.outlayCardValueLabel = [[UILabel alloc] init];
    self.outlayCardValueLabel.textColor =[UIColor colorWithRed:198.0/255.0 green:51.0/255.0 blue:42.0/255.0 alpha:1.0];
    self.outlayCardValueLabel.font=[UIFont systemFontOfSize:13];
    self.outlayCardValueLabel.textAlignment = NSTextAlignmentRight;
    self.outlayCardValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.outlayContainer addSubview:self.outlayCardValueLabel];
    
    [self setupOutlayContainerConstraints];

}

- (void)setupLayoutConstraints {
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[incomeContainer][outlayContainer]|"
                                              options:0
                                              metrics:nil
                                                views:@{@"incomeContainer" : self.incomeContainer,
                                                        @"outlayContainer" : self.outlayContainer}]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[incomeContainer]|"
                          options:0
                          metrics:nil
                          views:@{@"incomeContainer" : self.incomeContainer}]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[outlayContainer]|"
                          options:0
                          metrics:nil
                          views:@{@"outlayContainer" : self.outlayContainer}]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.incomeContainer
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:self.outlayContainer
                                                    attribute:NSLayoutAttributeWidth
                                                    multiplier:1 constant:0]];
}

- (void)setupIncomeContainerConstraints {
    NSDictionary *views = @{
                            @"incomeLabel" : self.incomeLabel,
                            @"remainedCashLabel" : self.remainedCashLabel,
                            @"incomeValueLabel" : self.incomeValueLabel,
                            @"remainedCashValueLabel" : self.remainedCashValueLabel
                            };
    
    [self.incomeContainer addConstraints:[NSLayoutConstraint
                        constraintsWithVisualFormat:@"V:|-5-[incomeLabel(25)]-5-[remainedCashLabel]-5-|"
                                    options:0
                                    metrics:nil
                                      views:views]];
    [self.incomeContainer addConstraints:[NSLayoutConstraint
                constraintsWithVisualFormat:@"V:|-5-[incomeValueLabel(25)]-5-[remainedCashValueLabel]-5-|"
                                    options:0
                                    metrics:nil
                                      views:views]];
    
    [self.incomeContainer addConstraints:[NSLayoutConstraint
                constraintsWithVisualFormat:@"H:|-5-[incomeLabel(40)]-5-[incomeValueLabel]-5-|"
                                          options:0
                                          metrics:nil
                                          views:views]];
    [self.incomeContainer addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|-5-[remainedCashLabel(60)]-5-[remainedCashValueLabel]-5-|"
                                          options:0
                                          metrics:nil
                                          views:views]];
    
}

- (void)setupOutlayContainerConstraints{
    NSDictionary *views = @{
                            @"outlayTotalLabel" : self.outlayTotalLabel,
                            @"outlayTotalValueLabel" : self.outlayTotalValueLabel,
                            @"outlayCashLabel" : self.outlayCashLabel,
                            @"outlayCashValueLabel" : self.outlayCashValueLabel,
                            @"outlayCardLabel":self.outlayCardLabel,
                            @"outlayCardValueLabel":self.outlayCardValueLabel
                            };
    
    [self.outlayContainer addConstraints:[NSLayoutConstraint
                constraintsWithVisualFormat:@"V:|-5-[outlayTotalLabel(25)]-2-[outlayCashLabel(10)]-2-[outlayCardLabel(10)]-7-|"
                                          options:0
                                          metrics:nil
                                          views:views]];
    [self.outlayContainer addConstraints:[NSLayoutConstraint
                constraintsWithVisualFormat:@"V:|-5-[outlayTotalValueLabel(25)]-2-[outlayCashValueLabel(10)]-2-[outlayCardValueLabel(10)]-7-|"
                                          options:0
                                          metrics:nil
                                          views:views]];
    [self.outlayContainer addConstraints:[NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|-5-[outlayTotalLabel(60)]-5-[outlayTotalValueLabel]-5-|"
                                          options:0
                                          metrics:nil
                                          views:views]];
    [self.outlayContainer addConstraints:[NSLayoutConstraint
                constraintsWithVisualFormat:@"H:|-5-[outlayCashLabel(50)]-5-[outlayCashValueLabel]-5-|"
                                          options:0
                                          metrics:nil
                                          views:views]];
    [self.outlayContainer addConstraints:[NSLayoutConstraint
                constraintsWithVisualFormat:@"H:|-5-[outlayCardLabel(50)]-5-[outlayCardValueLabel]-5-|"
                                          options:0
                                          metrics:nil
                                          views:views]];



    
}


@end
