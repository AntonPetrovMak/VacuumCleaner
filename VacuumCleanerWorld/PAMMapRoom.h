//
//  PAMMapRoom.h
//  VacuumCleanerWorld
//
//  Created by iMac309 on 07.03.16.
//  Copyright © 2016 iMac309. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PVAlgebraMatrix.h"

@interface PAMMapRoom : NSObject

@property(strong, nonatomic) UIView *mapView;
@property(strong, nonatomic) PVAlgebraMatrix *mapRoomMatrix;
@property(strong, nonatomic) PVAlgebraMatrix *mapDirtMatrix;

@end
