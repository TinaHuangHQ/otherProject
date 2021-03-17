//
//  KVOOper.h
//  KCVDemo
//
//  Created by macbook pro on 2021/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOOper : NSObject

@property(nonatomic, strong) NSArray* transactions;
@property(nonatomic, strong) NSArray* moreTransactions;
@property(nonatomic, strong) NSArray* arrayOfArrays;

- (void)testAvg;
- (void)testCount;
- (void)testMax;
- (void)testMin;
- (void)testSum;
- (void)testDistinctUnionOfObjects;
- (void)testUnionOfObjects;

- (void)testDistinctUnionOfArrays;
- (void)testUnionOfArrays;
- (void)testDistinctUnionOfSets;

@end

NS_ASSUME_NONNULL_END
