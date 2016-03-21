//
//  PAMVacuumCleaner.h
//  VacuumCleanerWorld
//
//  Created by iMac309 on 05.03.16.
//  Copyright © 2016 iMac309. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMMapRoom.h"
#import "PVAlgebraMatrix.h"

typedef enum : NSUInteger {
    PAMVacuumCleanerNoOp    = 0,
    PAMVacuumCleanerFront   = 1,
    PAMVacuumCleanerBack    = 2,
    PAMVacuumCleanerLeft    = 3,
    PAMVacuumCleanerRight   = 4
} PAMVacuumCleanerState;

@protocol PAMVacuumCleanerDelegate <NSObject>
@optional
- (void) vacuumCleanerEnergy:(NSNumber *) energy degreeDirt:(NSNumber *) degreeDirt;
@end


@interface PAMVacuumCleaner : UIView

@property(weak, nonatomic) id <PAMVacuumCleanerDelegate> delegate;

@property(assign, nonatomic) double speed;
@property(assign, nonatomic) NSInteger degreeDirt;
@property(assign, nonatomic) NSInteger energy;

@property(assign, nonatomic) CGRect beginPosition;
@property(strong, nonatomic) PVAlgebraMatrix *virtualMapRoom;

@property(assign, nonatomic) CGPoint lastPoint;
@property(assign, nonatomic) CGPoint currentPoint;

- (int)randomMove;
- (void)startVacuumCleanerBy:(PAMMapRoom*) mapRoom;
- (void)startSmartVacuumCleanerBy:(PAMMapRoom*) mapRoom;
@end
