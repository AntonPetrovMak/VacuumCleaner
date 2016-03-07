//
//  ViewController.m
//  VacuumCleanerWorld
//
//  Created by iMac309 on 05.03.16.
//  Copyright © 2016 iMac309. All rights reserved.
//

#import "ViewController.h"
#import "PVAlgebraMatrix.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapRoom =[PAMMapRoom new];
    NSLog(@"%@",self.mapRoom.matrixWithBarrier);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.vacuumCleaner.beginPosition = self.vacuumCleaner.frame;
    [self createMapWithBarrier];
}

- (void)createMapWithBarrier {
    for (int i = 1; i <= self.mapRoom.matrixWithBarrier.numberOfColumns; i++) {
        for (int j = 1; j <= self.mapRoom.matrixWithBarrier.numberOfRows; j++) {
            if([[self.mapRoom.matrixWithBarrier elementAtRow:i column:j] isEqualToNumber:@1]) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60*(j-1), 60*(i-1), 60, 60)];
                [view setBackgroundColor:[UIColor brownColor]];
                [self.mapView addSubview:view];
            }
        }
    }
}

- (void)createMapWithDirt {
    for (int i = 1; i <= self.mapRoom.matrixWithBarrier.numberOfColumns; i++) {
        for (int j = 1; j <= self.mapRoom.matrixWithBarrier.numberOfRows; j++) {
            if([[self.mapRoom.matrixWithBarrier elementAtRow:i column:j] isEqualToNumber:@1]) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60*(j-1), 60*(i-1), 60, 60)];
                [view setBackgroundColor:[UIColor brownColor]];
                [self.mapView addSubview:view];
            }
        }
    }
}

- (void)moveVacuumCleaner {
    __weak ViewController *weakSelf = self;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         //[weakSelf.vacuumCleaner startVacuumCleanerBy:weakSelf.mapRoom];
                         [weakSelf.vacuumCleaner startSmartVacuumCleanerBy:weakSelf.mapRoom];
                     }
                     completion:^(BOOL finished) {
                         if(finished) {
                             [weakSelf moveVacuumCleaner];
                         }
                     }];
}


#pragma makr - Action
- (IBAction)actionStartButton:(UIButton *)sender {
    [self moveVacuumCleaner];
}

- (IBAction)actionStopButton:(UIButton *)sender {
    [self.vacuumCleaner.layer removeAllAnimations];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.vacuumCleaner.frame = self.vacuumCleaner.beginPosition;
                     }
                     completion:nil];
}
@end
