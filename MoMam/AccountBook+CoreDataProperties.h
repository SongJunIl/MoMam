//
//  AccountBook+CoreDataProperties.h
//  MoMam
//
//  Created by 송준일 on 2016. 10. 8..
//  Copyright © 2016년 Song Jun Il. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AccountBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountBook (CoreDataProperties)

@property (nullable, nonatomic, strong) NSString *selectCalendarDay;
@property (nullable, nonatomic, strong) NSNumber *price;
@property (nullable, nonatomic, strong) NSString *incomeText;
@property (nullable, nonatomic, strong) NSString *outlayText;
@property (nullable, nonatomic, strong) NSString *incomeHistory;
@property (nullable, nonatomic, strong) NSString *outlayHistory;
@property (nullable, nonatomic, strong) NSNumber *outlayKinds;
@property (nullable, nonatomic, strong) NSString *note;
@property (nullable, nonatomic, strong) NSNumber *useKinds;
@property (nonatomic) double accountBookNumber;
@end

NS_ASSUME_NONNULL_END
