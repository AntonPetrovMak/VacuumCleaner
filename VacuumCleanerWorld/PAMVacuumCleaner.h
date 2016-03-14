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
    PAMVacuumCleanerRight   = 4,
    PAMVacuumCleanerSuck    = 5
} PAMVacuumCleanerState;

@interface PAMVacuumCleaner : UIView

@property(assign, nonatomic) CGRect beginPosition;
@property(strong, nonatomic) PVAlgebraMatrix *virtualMapRoom;

- (int)randomMove;
- (void)startVacuumCleanerBy:(PAMMapRoom*) mapRoom;
- (void)startSmartVacuumCleanerBy:(PAMMapRoom*) mapRoom;
@end
