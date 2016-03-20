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

- (NSArray *)checkArea:(PAMMapRoom*) environmentMap {
    NSInteger degreeDirt = [[environmentMap.mapRoomMatrix elementAtRow:self.currentPoint.x - 1 column:self.currentPoint.y - 1] integerValue];
    if (degreeDirt > 0) {
        if(!(degreeDirt - 1)) {
            for (UIView *view in [environmentMap.mapView subviews]) {
                UIView *dirtView = (UIView *)[environmentMap.mapDirtMatrix elementAtRow: self.currentPoint.x - 1 column:self.currentPoint.y - 1];
                if([view isEqual:dirtView]) {
                    [dirtView setBackgroundColor:[UIColor colorWithRed:157/255.f green:215/255.f blue:255/255.f alpha:1]];
                }
            }
        }
        [environmentMap.mapRoomMatrix replaceElementAtRow:self.currentPoint.x - 1 column:self.currentPoint.y - 1 withElement:@(degreeDirt - 1)];
        return nil;
    } else {
        NSMutableArray *array = [NSMutableArray new];
        for (int i = 1; i < 5; i++) {
            if([self isMoveToSide:i byMapRoom:environmentMap]) {
                [array addObject:@(i)];
            }
        }
        return array;
    }
    
}

-(void)insertRowToVirtualMatrix:(NSInteger) value position:(NSInteger) position {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < value; i++) {
        [array addObject:@0];
    }

    if(position == 1) {
        self.lastPoint = CGPointMake(self.currentPoint.x, self.currentPoint.y + 1);
        self.currentPoint = CGPointMake(self.currentPoint.x, self.currentPoint.y + 1);
        [self.virtualMapRoom insertNewRow:array atRow:position];
    } else {
        [self.virtualMapRoom addRowFromArray:array];
    }
    
}

-(void)insertColumnVirtualMatrix:(NSInteger) value position:(NSInteger) position {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < value; i++) {
        [array addObject:@0];
    }
    
    if(position == 1) {
        self.lastPoint = CGPointMake(self.currentPoint.x + 1, self.currentPoint.y);
        self.currentPoint = CGPointMake(self.currentPoint.x + 1, self.currentPoint.y);
        [self.virtualMapRoom insertNewColumn:array atColumn:position];
    } else {
        [self.virtualMapRoom addColumnFromArray:array];
    }
}

- (BOOL)isMoveToSide:(PAMVacuumCleanerState) status byMapRoom:(PAMMapRoom*) environmentMap {
    switch (status) {
        case PAMVacuumCleanerBack:
            if((self.currentPoint.x - 1) == 0) {
                [self insertRowToVirtualMatrix:self.virtualMapRoom.numberOfRows position: 1];
            }

            if((self.center.y - CGRectGetMaxY(self.bounds)) >= CGRectGetMaxY(self.bounds) / 2) {
                int i = (int)((CGRectGetMaxY(self.frame) - self.bounds.size.height) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                if(![[environmentMap.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                    return YES;
                } else {
                    [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x - 1 column:self.currentPoint.y withElement:@(-1)];
                }
            } else {
                [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x - 1 column:self.currentPoint.y withElement:@(-1)];
            }
            break;
        case PAMVacuumCleanerFront:
            if((self.currentPoint.x + 1) > self.virtualMapRoom.numberOfRows) {
                [self insertRowToVirtualMatrix:self.virtualMapRoom.numberOfColumns position: self.virtualMapRoom.numberOfRows];
            }
            
            if((self.center.y + CGRectGetMaxY(self.bounds)) <= environmentMap.mapRoomMatrix.numberOfColumns * 60 - CGRectGetMaxY(self.bounds) / 2) {
                int i = (int)((CGRectGetMaxY(self.frame) + self.bounds.size.height) / 60);
                int j = (int)(CGRectGetMaxX(self.frame) / 60);
                if(![[environmentMap.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                    return YES;
                } else {
                    [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x + 1 column:self.currentPoint.y withElement:@(-1)];
                }
            } else {
                [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x + 1 column:self.currentPoint.y withElement:@(-1)];
            }
            break;
        case PAMVacuumCleanerLeft:
            
            if((self.currentPoint.y - 1) == 0) {
                [self insertColumnVirtualMatrix:self.virtualMapRoom.numberOfColumns position:1];
            }
            if((self.center.x - CGRectGetMaxX(self.bounds)) >= CGRectGetMaxX(self.bounds) / 2) {
                int i = (int)(CGRectGetMaxY(self.frame) / 60);
                int j = (int)((CGRectGetMaxX(self.frame) - self.bounds.size.width) / 60);
                if(![[environmentMap.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                    return YES;
                } else {
                    [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x column:self.currentPoint.y - 1 withElement:@(-1)];
                }
            } else {
                [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x column:self.currentPoint.y - 1 withElement:@(-1)];
            }
            break;
        case PAMVacuumCleanerRight:
            if((self.currentPoint.y + 1) > self.virtualMapRoom.numberOfColumns) {
                [self insertColumnVirtualMatrix:self.virtualMapRoom.numberOfRows position:self.virtualMapRoom.numberOfColumns];
            }
            if((self.center.x + CGRectGetMaxX(self.bounds)) <= environmentMap.mapRoomMatrix.numberOfColumns * 60  - CGRectGetMaxX(self.bounds) / 2) {
                int i = (int)(CGRectGetMaxY(self.frame)/ 60);
                int j = (int)((CGRectGetMaxX(self.frame) + self.bounds.size.width) / 60);
                if(![[environmentMap.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                    return YES;
                } else {
                    [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x column:self.currentPoint.y + 1 withElement:@(-1)];
                }
            } else {
                [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x column:self.currentPoint.y + 1 withElement:@(-1)];
            }
            break;
        default:
            return NO;
            break;
    }
    return NO;
}

- (void)moveTo:(CGPoint) point {
    CGPoint newCenter = self.center;
    int sizeBot = CGRectGetMaxX(self.bounds);
    newCenter.x += sizeBot * point.x;
    newCenter.y += sizeBot * point.y;
    self.center = newCenter;
}

- (void)turnTo:(CGPoint) point {
    CGPoint lastPont = CGPointMake(self.currentPoint.y - self.lastPoint.y , self.currentPoint.x - self.lastPoint.x);
    double angle = [self whatIsTheSide:point] - [self whatIsTheSide:lastPont];
    CGAffineTransform currenttransform = self.transform;
    self.transform = CGAffineTransformRotate(currenttransform, angle);
}

- (double) whatIsTheSide: (CGPoint) point{
    if(point.x == 0 && point.y == 1) {
        return 0;
    } else if (point.x == 0 && point.y == -1) {
        return -M_PI;
    } else if (point.x == 1 && point.y == 0) {
        return -M_PI_2;
    } else if (point.x == -1 && point.y == 0) {
        return M_PI_2;
    } else {
        NSLog(@"no side");
        return 0;
    }
}



- (void)startSmartVacuumCleanerBy:(PAMMapRoom*) mapRoom {
    NSArray *arrayWihtSide = [self checkArea:mapRoom];
    if(arrayWihtSide.count) {
        int numberElement= (int)arc4random_uniform((int)arrayWihtSide.count);
        int move = [[arrayWihtSide objectAtIndex:numberElement] intValue];
        switch (move) {
            case PAMVacuumCleanerBack: {
                [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x column:self.currentPoint.y withElement:@(1)];
                
                CGPoint point = CGPointMake(0, -1);
                [UIView animateWithDuration:0.2 animations:^{
                    [self turnTo:point];
                    self.lastPoint = self.currentPoint;
                    self.currentPoint = CGPointMake(self.currentPoint.x - 1, self.currentPoint.y);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                        [self moveTo:point];
                    }];
                }];
            } break;
            case PAMVacuumCleanerFront: {
                [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x column:self.currentPoint.y withElement:@(1)];
                
                CGPoint point = CGPointMake(0, 1);
                [UIView animateWithDuration:0.2 animations:^{
                    [self turnTo:point];
                    self.lastPoint = self.currentPoint;
                    self.currentPoint = CGPointMake(self.currentPoint.x + 1, self.currentPoint.y);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         [self moveTo:point];
                                     }];
                }];
            } break;
            case PAMVacuumCleanerLeft: {
                [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x column:self.currentPoint.y withElement:@(1)];
                
                CGPoint point = CGPointMake(-1, 0);
                [UIView animateWithDuration:0.2 animations:^{
                    [self turnTo:point];
                    self.lastPoint = self.currentPoint;
                    self.currentPoint = CGPointMake(self.currentPoint.x, self.currentPoint.y - 1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         [self moveTo:point];
                                     }];
                }];
            } break;
            case PAMVacuumCleanerRight: {
                [self.virtualMapRoom replaceElementAtRow:self.currentPoint.x column:self.currentPoint.y withElement:@(1)];
                
                CGPoint point = CGPointMake(1, 0);
                [UIView animateWithDuration:0.2 animations:^{
                    [self turnTo:point];
                    self.lastPoint = self.currentPoint;
                    self.currentPoint = CGPointMake(self.currentPoint.x, self.currentPoint.y + 1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2
                                     animations:^{
                                         [self moveTo:point];
                                     }];
                }];
            } break;
            default:
                NSLog(@"PAMVacuumCleanerNoOp");
                break;
        }
        NSLog(@"Virtual Matrix: %@", self.virtualMapRoom);
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
