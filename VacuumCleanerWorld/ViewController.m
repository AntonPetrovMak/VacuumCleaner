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

@property(assign, nonatomic) int time;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapRoom = [PAMMapRoom new];
    self.mapRoom.mapView = self.mapView;
    self.vacuumCleaner.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self createMapWithBarrier];
    [self createMapWithDirty];
    self.vacuumCleaner.beginPosition = self.vacuumCleaner.frame;
    //NSLog(@"%@",self.mapRoom.mapRoomMatrix);
}

- (void)createMapWithBarrier {
    for (int i = 1; i <= self.mapRoom.mapRoomMatrix.numberOfColumns; i++) {
        for (int j = 1; j <= self.mapRoom.mapRoomMatrix.numberOfRows; j++) {
            if([[self.mapRoom.mapRoomMatrix elementAtRow:i column:j] isEqualToNumber:@(-1)]) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60*(j-1), 60*(i-1), 60, 60)];
                [view setBackgroundColor:[UIColor brownColor]];
                [self.mapView addSubview:view];
            } 
        }
    }
    [self.mapView bringSubviewToFront:self.vacuumCleaner];
}

- (void)createMapWithDirty {
    for (int i = 1; i <= self.mapRoom.mapRoomMatrix.numberOfColumns; i++) {
        for (int j = 1; j <= self.mapRoom.mapRoomMatrix.numberOfRows; j++) {
            if ([[self.mapRoom.mapRoomMatrix elementAtRow:i column:j] intValue] > 0) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60*(j-1), 60*(i-1), 60, 60)];
                float alpha = [[self.mapRoom.mapRoomMatrix elementAtRow:i column:j] floatValue]/10;
                [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha: alpha]];
                [self.mapRoom.mapDirtMatrix replaceElementAtRow:i column:j withElement:view];
                [self.mapView addSubview:view];
            }
        }
    }
    [self.mapView bringSubviewToFront:self.vacuumCleaner];
}

- (void)modeVacuumCleanerWorks{
    self.barrierButton.userInteractionEnabled = !self.barrierButton.userInteractionEnabled;
    self.dityButton.userInteractionEnabled = !self.dityButton.userInteractionEnabled;
    self.energySlider.userInteractionEnabled = !self.energySlider.userInteractionEnabled;
    self.speedSlider.userInteractionEnabled = !self.speedSlider.userInteractionEnabled;
    self.startButton.userInteractionEnabled = !self.startButton.userInteractionEnabled;
}


- (void)moveVacuumCleaner {
    self.time --;
    if(!self.time) {
        [self actionStopButton:self.stopButton];
    } else {
        __weak ViewController *weakSelf = self;
        [weakSelf.vacuumCleaner startSmartVacuumCleanerBy:weakSelf.mapRoom];
    }
}


#pragma makr - Action
- (IBAction)actionChangeEnergy:(UISlider *)sender {
    self.vacuumCleaner.energy = sender.value;
    self.initialEnergyLabel.text = [NSString stringWithFormat:@"Energy: %.0f",sender.value];
    self.residualEnergyLabel.text = [NSString stringWithFormat:@"Residual energy: %.0f",sender.value];
}

- (IBAction)actionChangeSpeed:(UISlider *)sender {
    self.vacuumCleaner.speed = sender.value/2;
    self.speedLabel.text = [NSString stringWithFormat:@"Speed: %f c", sender.value];
}

- (IBAction)actionStartButton:(UIButton *)sender {
    [self modeVacuumCleanerWorks];
    self.time = self.energySlider.value;
    self.vacuumCleaner.virtualMapRoom = [[PVAlgebraMatrix alloc]initWithRows:3 columns:3 setDefaultValueForAllElements:0];
    self.vacuumCleaner.lastPoint = CGPointMake(2, 2);
    self.vacuumCleaner.currentPoint = CGPointMake(2, 2);
    self.vacuumCleaner.degreeDirt = 0;
    self.vacuumCleaner.energy = self.energySlider.value;
    self.vacuumCleaner.speed = self.speedSlider.value;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.vacuumCleaner.speed * 2
                                                  target:self
                                                selector:@selector(moveVacuumCleaner)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (IBAction)actionStopButton:(UIButton *)sender {
    [self modeVacuumCleanerWorks];
    [self.timer invalidate];
    [self.vacuumCleaner.layer removeAllAnimations];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.vacuumCleaner.transform = CGAffineTransformIdentity;
                         self.vacuumCleaner.frame = self.vacuumCleaner.beginPosition;
                     }
                     completion:nil];
}

- (IBAction)actionRandomBarrier:(id)sender {
    for (UIView *view in self.mapView.subviews) {
        if(![view isEqual:self.vacuumCleaner]){
            [view removeFromSuperview];
        }
    }
    [self.mapRoom randomMatrixWithBarrier];
    [self createMapWithBarrier];
    [self createMapWithDirty];
}

- (IBAction)actionRandomDirt:(id)sender {
    //NSLog(@"%@",self.mapRoom.mapDirtMatrix);
    for (int i = 1; i <= self.mapRoom.mapRoomMatrix.numberOfColumns; i++) {
        for (int j = 1; j <= self.mapRoom.mapRoomMatrix.numberOfRows; j++) {
            id dirtView = [self.mapRoom.mapDirtMatrix elementAtRow:i column:j];
            if([dirtView isKindOfClass:[UIView class]]) {
                [dirtView removeFromSuperview];
            }
        }
    }
    [self.mapRoom randomMatrixWithDirt];
    [self createMapWithDirty];
    
}

#pragma mark - PAMVacuumCleanerInfo
- (void) vacuumCleanerEnergy:(NSNumber *) energy degreeDirt:(NSNumber *) degreeDirt {
    self.residualEnergyLabel.text = [NSString stringWithFormat:@"Residual energy: %d", [energy integerValue]];
    self.degreeDirtLabel.text = [NSString stringWithFormat:@"Degree dirt: %d", [degreeDirt integerValue]];
}

@end
