//
//  PAMMap.m
//  VacuumCleanerWorld
//
//  Created by iMac309 on 07.03.16.
//  Copyright © 2016 iMac309. All rights reserved.
//

#import "PAMMapRoom.h"

@implementation PAMMapRoom

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self standrtMatrixWithBarrier];
    }
    return self;
}

- (void) standrtMatrixWithBarrier {
    self.matrixWithBarrier = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
        [self.matrixWithBarrier replaceElementAtRow:10  column:4 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:6   column:7 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:9   column:11 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:4   column:9 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:6   column:4 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:10  column:3 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:5   column:10 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:3   column:11 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:10  column:11 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:6   column:2 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:11  column:11 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:10  column:1 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:11  column:6 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:2   column:11 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:11  column:2 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:4 column:3 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:7 column:11 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:4 column:10 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:3 column:10 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:6 column:1 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:6 column:6 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:1 column:2 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:4 column:11 withElement:@1];
        [self.matrixWithBarrier replaceElementAtRow:8 column:7 withElement:@1];
    }

- (void) randomMatrixWithBarrier {
    self.matrixWithBarrier = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
    [self.matrixWithBarrier replaceElementAtRow:2 column:2 withElement:@1];
    NSInteger row;
    NSInteger column;
    NSString *str = @"";
    for (int i = 0; i < 30; i++) {
        row = (NSInteger)arc4random_uniform(11) + 1;
        column = (NSInteger)arc4random_uniform(11) + 1;
        if (![[self.matrixWithBarrier elementAtRow:row column:column]isEqualToNumber:@1]) {
            str = [NSString stringWithFormat:@"%@ \n [self.matrixWithBarrier replaceElementAtRow:%ld column:%ld withElement:@1];", str, (long)row, (long)column];
            [self.matrixWithBarrier replaceElementAtRow:row column:column withElement:@1];
        }
    }
    NSLog(@"\n%@", str);
}

- (void) randomMatrixWithDirt {
    self.matrixWithDirt = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
    [self.matrixWithBarrier replaceElementAtRow:2 column:2 withElement:@1];
    NSInteger row;
    NSInteger column;
    for (int i = 0; i < 50; i++) {
        row = (NSInteger)arc4random_uniform(11) + 1;
        column = (NSInteger)arc4random_uniform(11) + 1;
        [self.matrixWithBarrier replaceElementAtRow:row column:column withElement:@1];
    }
}

@end
