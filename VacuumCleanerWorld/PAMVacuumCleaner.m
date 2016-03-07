//
//  PAMVacuumCleaner.m
//  VacuumCleanerWorld
//
//  Created by iMac309 on 05.03.16.
//  Copyright © 2016 iMac309. All rights reserved.
//

#import "PAMVacuumCleaner.h"

@implementation PAMVacuumCleaner

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.matrixMapRoom = [[PVAlgebraMatrix alloc]initWithRows:144 columns:144 setDefaultValueForAllElements:0];
    }
    return self;
}

- (int)randomMove {
    int move = (int)arc4random_uniform(4) + 1;
    NSLog(@"Move: %d", move);
    switch (move) {
        case (PAMVacuumCleanerFront | PAMVacuumCleanerRight):
            return 1;
            break;
        case (PAMVacuumCleanerBack | PAMVacuumCleanerLeft):
            return -1;
            break;
        default:
            return 0;
            break;
    }
}

- (void)checkArea:(PAMMapRoom*) mapRoom {
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 1; i < 5; i++) {
        if([self isMoveToSide:i byMapRoom:mapRoom]) {
            [array addObject:@(i)];
        }
    }
}

- (BOOL) isMoveToSide:(PAMVacuumCleanerState) status byMapRoom:(PAMMapRoom*) mapRoom {
    switch (status) {
        case PAMVacuumCleanerBack:
            if((self.center.y + CGRectGetMaxY(self.bounds)) <= mapRoom.matrixWithBarrier.numberOfColumns * 60 - CGRectGetMaxY(self.bounds) / 2 ) {
                int i = (int)((CGRectGetMaxY(self.frame) + self.bounds.size.height) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                if([[mapRoom.matrixWithBarrier elementAtRow:i column:j] isEqualToNumber:@0]) {
                    return YES;
                }
            }
            break;
        case PAMVacuumCleanerFront:
            if((self.center.y - CGRectGetMaxY(self.bounds)) >= CGRectGetMaxY(self.bounds) / 2) {
                int i = (int)((CGRectGetMaxY(self.frame) - self.bounds.size.height) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                if([[mapRoom.matrixWithBarrier elementAtRow:i column:j] isEqualToNumber:@0]) {
                    return YES;
                }
            }
            break;
        case PAMVacuumCleanerLeft:
            if((self.center.x - CGRectGetMaxX(self.bounds)) >= CGRectGetMaxX(self.bounds) / 2) {
                int i = (int)(CGRectGetMaxY(self.frame) / 60);
                int j = (int)((CGRectGetMaxX(self.frame) - self.bounds.size.width) / 60);
                if([[mapRoom.matrixWithBarrier elementAtRow:i column:j] isEqualToNumber:@0]) {
                    return YES;
                }
            }
            break;
        case PAMVacuumCleanerRight:
            if((self.center.x + CGRectGetMaxX(self.bounds)) <= mapRoom.matrixWithBarrier.numberOfColumns * 60  - CGRectGetMaxX(self.bounds) / 2) {
                int i = (int)(CGRectGetMaxY(self.frame)/ 60);
                int j = (int)((CGRectGetMaxX(self.frame) + self.bounds.size.width) / 60);
                if([[mapRoom.matrixWithBarrier elementAtRow:i column:j] isEqualToNumber:@0]) {
                    return YES;
                }
            }
            
            break;
        default:
            return NO;
            break;
    }
    return NO;
}

- (void)startSmartVacuumCleanerBy:(PAMMapRoom*) mapRoom {
    [self checkArea:mapRoom];
    
    
    CGPoint newCenter = self.center;
    
    int move = (int)arc4random_uniform(4) + 1;
    switch (move) {
        case PAMVacuumCleanerBack:
            if([self isMoveToSide:PAMVacuumCleanerBack byMapRoom:mapRoom]) {
                newCenter.y += CGRectGetMaxY(self.bounds);
            } else {
                NSLog(@"limit y+");
            }
            break;
        case PAMVacuumCleanerFront:
            if([self isMoveToSide:PAMVacuumCleanerFront byMapRoom:mapRoom]) {
                newCenter.y -= CGRectGetMaxY(self.bounds);
            } else {
                NSLog(@"limit y-");
            }
            break;
        case PAMVacuumCleanerLeft:
            if([self isMoveToSide:PAMVacuumCleanerLeft byMapRoom:mapRoom]) {
                newCenter.x -= CGRectGetMaxX(self.bounds);
            } else {
                NSLog(@"limit x-");
            }
            
            break;
        case PAMVacuumCleanerRight:
            if([self isMoveToSide:PAMVacuumCleanerRight byMapRoom:mapRoom]) {
                newCenter.x += CGRectGetMaxX(self.bounds);
            } else {
                NSLog(@"limit x+");
            }
            
            break;
        default:
            
            break;
    }
    self.center = newCenter;
}

- (void)startVacuumCleanerBy:(PAMMapRoom*) mapRoom {
    CGPoint newCenter = self.center;
    
    int move = (int)arc4random_uniform(4) + 1;
    switch (move) {
        case PAMVacuumCleanerBack:
            if([self isMoveToSide:PAMVacuumCleanerBack byMapRoom:mapRoom]) {
                newCenter.y += CGRectGetMaxY(self.bounds);
            } else {
                NSLog(@"limit y+");
            }
            break;
        case PAMVacuumCleanerFront:
            if([self isMoveToSide:PAMVacuumCleanerFront byMapRoom:mapRoom]) {
                newCenter.y -= CGRectGetMaxY(self.bounds);
            } else {
                NSLog(@"limit y-");
            }
            break;
        case PAMVacuumCleanerLeft:
            if([self isMoveToSide:PAMVacuumCleanerLeft byMapRoom:mapRoom]) {
                newCenter.x -= CGRectGetMaxX(self.bounds);
            } else {
                NSLog(@"limit x-");
            }
            
            break;
        case PAMVacuumCleanerRight:
            if([self isMoveToSide:PAMVacuumCleanerRight byMapRoom:mapRoom]) {
                newCenter.x += CGRectGetMaxX(self.bounds);
            } else {
                NSLog(@"limit x+");
            }
            
            break;
        default:
            
            break;
    }
    self.center = newCenter;
}

@end
