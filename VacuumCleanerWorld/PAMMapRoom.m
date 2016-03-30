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
        self.mapLabelMatrix = [[PVAlgebraMatrix alloc] initWithRows:12 columns:12 setDefaultValueForAllElements:0];
        self.degreeDirt = 0;
        //[self standrtMapRoomMatrix];
        [self createLabels];
        [self randomMatrixWithBarrier];
    }
    return self;
}

- (void)createLabels {
    for (int i = 1; i <= 12; i++) {
        for (int j = 1; j <= 12; j++) {
            CGRect rect = CGRectMake(((j-1)*60) + 10, ((i-1)*60) + 20, 40, 20);
            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            label.font = [UIFont fontWithName:@"Arial" size:18];
            label.hidden = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [self.mapLabelMatrix replaceElementAtRow:i column:j withElement:label];
        }
    }
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
    self.degreeDirt = 0;
    for (int i = 1; i <= self.mapRoomMatrix.numberOfColumns; i++) {
        for (int j = 1; j <= self.mapRoomMatrix.numberOfRows; j++) {
            if ([[self.mapRoomMatrix elementAtRow:i column:j] intValue] > 0) {
                [self.mapRoomMatrix replaceElementAtRow:i column:j withElement:@0];
            }
        }
    }
}

- (void)clearLabel {
    for (int i = 1; i <= 12; i++) {
        for (int j = 1; j <= 12; j++) {
            UILabel *label = [self.mapLabelMatrix elementAtRow:i column:j];
            label.text = @"";
        }
    }
}

- (void)labelIsHidden:(BOOL) hidden {
    for (int i = 1; i <= 12; i++) {
        for (int j = 1; j <= 12; j++) {
            UILabel *label = [self.mapLabelMatrix elementAtRow:i column:j];
            label.hidden = hidden;
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
            self.degreeDirt += dirt;
            i--;
            str = [NSString stringWithFormat:@"%@ \n [self.mapRoomMatrix replaceElementAtRow:%ld column:%ld withElement:@(%ld)];", str, (long)row, (long)column, dirt];
            [self.mapRoomMatrix replaceElementAtRow:row column:column withElement:@(dirt)];
        }
    }
    //NSLog(@"\n%@", str);
}


-(void)changeTextOnLabelsWithVirtualMap:(PVAlgebraMatrix *) virtualMap {
    for (int i = 1; i <= virtualMap.numberOfRows; i++) {
        for (int j = 1; j <= virtualMap.numberOfColumns; j++) {
            if(i <= 12 && j <= 12) {
                UILabel *label = [self.mapLabelMatrix elementAtRow:i column:j];
                label.text = [[virtualMap elementAtRow:i+1 column:j+1] stringValue];
            }
        }
    }
}

@end
