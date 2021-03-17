//
//  KVOOper.m
//  KCVDemo
//
//  Created by macbook pro on 2021/3/17.
//

#import "KVOOper.h"
#import "Transaction.h"

@implementation KVOOper
- (instancetype)init{
    self = [super init];
    if (self) {
        NSDateFormatter* format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"YYYY-MM-dd"];
        Transaction* t1 = [Transaction new];
        t1.payee = @"Green Power";
        t1.amount = @120;
        t1.date = [format dateFromString:@"2021-01-01"];
        Transaction* t2 = [Transaction new];
        t2.payee = @"Green Power";
        t2.amount = @150;
        t2.date = [format dateFromString:@"2021-02-02"];
        Transaction* t3 = [Transaction new];
        t3.payee = @"Car Loan";
        t3.amount = @170;
        t3.date = [format dateFromString:@"2021-03-03"];
        Transaction* t4 = [Transaction new];
        t4.payee = @"Car Loan";
        t4.amount = @250;
        t4.date = [format dateFromString:@"2021-04-05"];
        Transaction* t5 = [Transaction new];
        t5.payee = @"Green Power";
        t5.amount = @1250;
        t5.date = [format dateFromString:@"2021-05-06"];
        Transaction* t6 = [Transaction new];
        t6.payee = @"Mortgage";
        t6.amount = @600;
        t6.date = [format dateFromString:@"2021-06-07"];
        self.transactions = @[t1, t2, t3, t4, t5, t6];
        Transaction* t7 = [Transaction new];
        t7.payee = @"General Cable - Cottage";
        t7.amount = @120;
        t7.date = [format dateFromString:@"2021-07-17"];
        Transaction* t8 = [Transaction new];
        t8.payee = @"Second Mortgage";
        t8.amount = @155;
        t8.date = [format dateFromString:@"2021-08-18"];
        Transaction* t9 = [Transaction new];
        t9.payee = @"Hobby Shop";
        t9.amount = @120;
        t9.date = [format dateFromString:@"2021-09-19"];
        Transaction* t10 = [Transaction new];
        t10.payee = @"Second Mortgage";
        t10.amount = @600;
        t10.date = [format dateFromString:@"2021-10-10"];
        self.moreTransactions = @[t7, t8, t9, t10];
        self.arrayOfArrays = @[self.transactions, self.moreTransactions];
    }
    return self;
}

- (void)testAvg{
    NSLog(@"avg---%@", [self.transactions valueForKeyPath:@"@avg.amount"]);
}

- (void)testCount{
    NSLog(@"count---%@", [self.transactions valueForKeyPath:@"@count"]);
}

- (void)testMax{
    NSLog(@"max amount---%@", [self.transactions valueForKeyPath:@"@max.amount"]);
    NSLog(@"max date---%@", [self.transactions valueForKeyPath:@"@max.date"]);
    NSLog(@"max payee---%@", [self.transactions valueForKeyPath:@"@max.payee"]);
}

- (void)testMin{
    NSLog(@"min amount---%@", [self.transactions valueForKeyPath:@"@min.amount"]);
    NSLog(@"min date---%@", [self.transactions valueForKeyPath:@"@min.date"]);
    NSLog(@"min payee---%@", [self.transactions valueForKeyPath:@"@min.payee"]);
}

- (void)testSum{
    NSLog(@"sum amount---%@", [self.transactions valueForKeyPath:@"@sum.amount"]);
}

- (void)testDistinctUnionOfObjects{
    NSLog(@"distinctUnionOfObjects amount---%@", [self.transactions valueForKeyPath:@"@distinctUnionOfObjects.amount"]);
    NSLog(@"distinctUnionOfObjects date---%@", [self.transactions valueForKeyPath:@"@distinctUnionOfObjects.date"]);
    NSLog(@"distinctUnionOfObjects payee---%@", [self.transactions valueForKeyPath:@"@distinctUnionOfObjects.payee"]);
}

- (void)testUnionOfObjects{
    NSLog(@"unionOfObjects amount---%@", [self.transactions valueForKeyPath:@"@unionOfObjects.amount"]);
    NSLog(@"unionOfObjects date---%@", [self.transactions valueForKeyPath:@"@unionOfObjects.date"]);
    NSLog(@"unionOfObjects payee---%@", [self.transactions valueForKeyPath:@"@unionOfObjects.payee"]);
}

- (void)testDistinctUnionOfArrays{
    NSLog(@"distinctUnionOfArrays amount---%@", [self.arrayOfArrays valueForKeyPath:@"@distinctUnionOfArrays.amount"]);
    NSLog(@"distinctUnionOfArrays date---%@", [self.arrayOfArrays valueForKeyPath:@"@distinctUnionOfArrays.date"]);
    NSLog(@"distinctUnionOfArrays payee---%@", [self.arrayOfArrays valueForKeyPath:@"@distinctUnionOfArrays.payee"]);
}

- (void)testUnionOfArrays{
    NSLog(@"unionOfArrays amount---%@", [self.arrayOfArrays valueForKeyPath:@"@unionOfArrays.amount"]);
    NSLog(@"unionOfArrays date---%@", [self.arrayOfArrays valueForKeyPath:@"@unionOfArrays.date"]);
    NSLog(@"unionOfArrays payee---%@", [self.arrayOfArrays valueForKeyPath:@"@unionOfArrays.payee"]);
}

- (void)testDistinctUnionOfSets{
    NSSet* transactionSet = [[NSSet alloc] initWithArray:self.transactions];
    NSSet* moreTransactionsSet = [[NSSet alloc] initWithArray:self.moreTransactions];
    NSSet* set = [[NSSet alloc] initWithArray:@[transactionSet, moreTransactionsSet]];
    NSLog(@"distinctUnionOfSets amount---%@", [set valueForKeyPath:@"@distinctUnionOfSets.amount"]);
    NSLog(@"distinctUnionOfSets date---%@", [set valueForKeyPath:@"@distinctUnionOfSets.date"]);
    NSLog(@"distinctUnionOfSets payee---%@", [set valueForKeyPath:@"@distinctUnionOfSets.payee"]);
}
@end
