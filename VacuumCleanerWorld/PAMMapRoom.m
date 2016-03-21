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
        self.mapRoomMatrix = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
        self.mapDirtMatrix = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
        //[self standrtMapRoomMatrix];
        [self randomMatrixWithBarrier];
    }
    return self;
}


- (void)standrtMapRoomMatrix {
    self.mapRoomMatrix = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
    self.mapDirtMatrix = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
    [self.mapRoomMatrix replaceElementAtRow:1  column:2 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:3   column:2 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:4   column:2 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:4   column:1 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:6   column:4 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:10  column:3 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:5   column:10 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:3   column:11 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:10  column:11 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:6   column:2 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:11  column:11 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:10  column:1 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:11  column:6 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:2   column:11 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:10  column:2 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:11  column:2 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:4 column:3 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:7 column:11 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:4 column:10 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:3 column:10 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:6 column:1 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:6 column:6 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:4 column:11 withElement:@(-1)];
    [self.mapRoomMatrix replaceElementAtRow:8 column:7 withElement:@(-1)];
    
//    [self.mapRoomMatrix replaceElementAtRow:3 column:1 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:3 column:2 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:2 column:12 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:3 column:9 withElement:@(1)];
//    [self.mapRoomMatrix replaceElementAtRow:12 column:4 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:12 column:8 withElement:@(5)];
//    [self.mapRoomMatrix replaceElementAtRow:4 column:8 withElement:@(5)];
//    [self.mapRoomMatrix replaceElementAtRow:4 column:12 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:1 column:4 withElement:@(1)];
//    [self.mapRoomMatrix replaceElementAtRow:5 column:3 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:5 column:4 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:8 column:8 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:6 column:8 withElement:@(3)];
//    [self.mapRoomMatrix replaceElementAtRow:5 column:8 withElement:@(5)];
//    [self.mapRoomMatrix replaceElementAtRow:6 column:3 withElement:@(1)];
//    [self.mapRoomMatrix replaceElementAtRow:7 column:8 withElement:@(2)];
//    [self.mapRoomMatrix replaceElementAtRow:3 column:8 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:12 column:5 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:2 column:5 withElement:@(4)];
//    [self.mapRoomMatrix replaceElementAtRow:11 column:9 withElement:@(2)];
//    [self.mapRoomMatrix replaceElementAtRow:7 column:4 withElement:@(3)];
//    [self.mapRoomMatrix replaceElementAtRow:12 column:2 withElement:@(2)];
    //[self randomMatrixWithDirt];
}

- (void)randomMatrixWithBarrier {
    self.mapRoomMatrix = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
    NSInteger row;
    NSInteger column;
    NSString *str = @"";
    int i = 40;
    while (i > 0) {
        row = (NSInteger)arc4random_uniform(12) + 1;
        column = (NSInteger)arc4random_uniform(12) + 1;
        NSLog(@"%d %d",row, column);
        if ([[self.mapRoomMatrix elementAtRow:row column:column]isEqualToNumber:@(0)] && !(row == 1 && column == 1)) {
            i --;
            str = [NSString stringWithFormat:@"%@ \n [self.mapRoomMatrix replaceElementAtRow:%ld column:%ld withElement:@(-1)];", str, (long)row, (long)column];
            [self.mapRoomMatrix replaceElementAtRow:row column:column withElement:@(-1)];
        }
    }
    [self randomMatrixWithDirt];
    NSLog(@"\n%@", str);
}

- (void)clearDirtInRoom {
    for (int i = 1; i <= self.mapRoomMatrix.numberOfColumns; i++) {
        for (int j = 1; j <= self.mapRoomMatrix.numberOfRows; j++) {
            if ([[self.mapRoomMatrix elementAtRow:i column:j] intValue] > 0) {
                [self.mapRoomMatrix replaceElementAtRow:i column:j withElement:@0];
            }
        }
    }
}

- (void)randomMatrixWithDirt {
    [self clearDirtInRoom];
    self.mapDirtMatrix = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
    NSInteger row;
    NSInteger column;
    NSInteger dirt;
    NSString *str = @"";
    int i = 40;
    while (i > 0) {
        row = (NSInteger)arc4random_uniform(12) + 1;
        column = (NSInteger)arc4random_uniform(12) + 1;
        dirt = (NSInteger)arc4random_uniform(5) + 1;
        if([[self.mapRoomMatrix elementAtRow:row column:column]isEqualToNumber:@(0)] && !(row == 1 && column == 1)) {
            i--;
            str = [NSString stringWithFormat:@"%@ \n [self.mapRoomMatrix replaceElementAtRow:%ld column:%ld withElement:@(%d)];", str, (long)row, (long)column, dirt];
            [self.mapRoomMatrix replaceElementAtRow:row column:column withElement:@(dirt)];
        }
    }
    NSLog(@"\n%@", str);
}

@end
