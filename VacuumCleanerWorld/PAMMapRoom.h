//
//  PAMMapRoom.h
//  VacuumCleanerWorld
//
//  Created by iMac309 on 07.03.16.
//  Copyright © 2016 iMac309. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVAlgebraMatrix.h"

@interface PAMMapRoom : NSObject

@property(strong, nonatomic) PVAlgebraMatrix *matrixWithBarrier;
@property(strong, nonatomic) PVAlgebraMatrix *matrixWithDirt;

@end
