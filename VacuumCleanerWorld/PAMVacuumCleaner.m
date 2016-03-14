//
//  PAMVacuumCleaner.m
//  VacuumCleanerWorld
//
//  Created by iMac309 on 05.03.16.
//  Copyright © 2016 iMac309. All rights reserved.
//

#import "PAMVacuumCleaner.h"

@implementation PAMVacuumCleaner

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

- (NSArray *)checkArea:(PAMMapRoom*) mapRoom {
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 1; i < 5; i++) {
        if([self isMoveToSide:i byMapRoom:mapRoom]) {
            [array addObject:@(i)];
        }
    }
    return array;
}

- (BOOL)isMoveToSide:(PAMVacuumCleanerState) status byMapRoom:(PAMMapRoom*) mapRoom {
    switch (status) {
        case PAMVacuumCleanerBack:
            if((self.center.y + CGRectGetMaxY(self.bounds)) <= mapRoom.mapRoomMatrix.numberOfColumns * 60 - CGRectGetMaxY(self.bounds) / 2 ) {
                int i = (int)((CGRectGetMaxY(self.frame) + self.bounds.size.height) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                if(![[mapRoom.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                    return YES;
                } else {
                    [self.virtualMapRoom replaceElementAtRow:i column:j withElement:@(-1)];
                }
            }
            break;
        case PAMVacuumCleanerFront:
            if((self.center.y - CGRectGetMaxY(self.bounds)) >= CGRectGetMaxY(self.bounds) / 2) {
                int i = (int)((CGRectGetMaxY(self.frame) - self.bounds.size.height) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                if(![[mapRoom.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                    return YES;
                } else {
                    [self.virtualMapRoom replaceElementAtRow:i column:j withElement:@(-1)];
                }
            }
            break;
        case PAMVacuumCleanerLeft:
            if((self.center.x - CGRectGetMaxX(self.bounds)) >= CGRectGetMaxX(self.bounds) / 2) {
                int i = (int)(CGRectGetMaxY(self.frame) / 60);
                int j = (int)((CGRectGetMaxX(self.frame) - self.bounds.size.width) / 60);
                if(![[mapRoom.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                    return YES;
                } else {
                    [self.virtualMapRoom replaceElementAtRow:i column:j withElement:@(-1)];
                }
            }
            break;
        case PAMVacuumCleanerRight:
            if((self.center.x + CGRectGetMaxX(self.bounds)) <= mapRoom.mapRoomMatrix.numberOfColumns * 60  - CGRectGetMaxX(self.bounds) / 2) {
                int i = (int)(CGRectGetMaxY(self.frame)/ 60);
                int j = (int)((CGRectGetMaxX(self.frame) + self.bounds.size.width) / 60);
                if(![[mapRoom.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                    return YES;
                } else {
                    [self.virtualMapRoom replaceElementAtRow:i column:j withElement:@(-1)];
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
    NSArray *arrayWihtSide = [self checkArea:mapRoom];
    if(arrayWihtSide.count) {
        int numberElement= (int)arc4random_uniform((int)arrayWihtSide.count);
        int move = [[arrayWihtSide objectAtIndex:numberElement] intValue];
        CGPoint newCenter = self.center;
        
        switch (move) {
            case PAMVacuumCleanerBack: {
                int i = (int)(CGRectGetMaxY(self.frame) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                [self.virtualMapRoom replaceElementAtRow:i column:j withElement:@(1)];
                newCenter.y += CGRectGetMaxY(self.bounds);
                
            } break;
            case PAMVacuumCleanerFront: {
                int i = (int)(CGRectGetMaxY(self.frame) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                [self.virtualMapRoom replaceElementAtRow:i column:j withElement:@(1)];
                newCenter.y -= CGRectGetMaxY(self.bounds);
                
            } break;
            case PAMVacuumCleanerLeft: {
                int i = (int)(CGRectGetMaxY(self.frame) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                [self.virtualMapRoom replaceElementAtRow:i column:j withElement:@(1)];
                newCenter.x -= CGRectGetMaxX(self.bounds);
                
            } break;
            case PAMVacuumCleanerRight: {
                int i = (int)(CGRectGetMaxY(self.frame) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                [self.virtualMapRoom replaceElementAtRow:i column:j withElement:@(1)];
                newCenter.x += CGRectGetMaxX(self.bounds);
                
            } break;
            default:
                NSLog(@"PAMVacuumCleanerNoOp");
                break;
        }
        self.center = newCenter;

    }
    
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
