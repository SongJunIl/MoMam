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

@property (nullable, nonatomic, retain) NSNumber *selectCalendarDay;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *incomeText;
@property (nullable, nonatomic, retain) NSString *outlayText;
@property (nullable, nonatomic, retain) NSString *incomeHistory;
@property (nullable, nonatomic, retain) NSString *outlayHistory;
@property (nullable, nonatomic, retain) NSNumber *outlayKinds;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *useKinds;

@end

NS_ASSUME_NONNULL_END
