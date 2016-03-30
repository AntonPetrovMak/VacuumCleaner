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
    [self createLabelsOnMap];
    [self.mapView bringSubviewToFront:self.vacuumCleaner];
    self.vacuumCleaner.beginPosition = self.vacuumCleaner.frame;
    //NSLog(@"%@",self.mapRoom.mapRoomMatrix);
}

- (void)createLabelsOnMap {
    [self.mapRoom clearLabel];
    for (int i = 1; i <= self.mapRoom.mapLabelMatrix.numberOfColumns; i++) {
        for (int j = 1; j <= self.mapRoom.mapLabelMatrix.numberOfRows; j++) {
            UILabel *lable = [self.mapRoom.mapLabelMatrix elementAtRow:i column:j];
            [self.mapView addSubview:lable];
        }
    }
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
}

- (void)modeVacuumCleanerWorks:(BOOL) work{
    self.barrierButton.userInteractionEnabled = work;
    self.dityButton.userInteractionEnabled = work;
    self.energySlider.userInteractionEnabled = work;
    self.speedSlider.userInteractionEnabled = work;
    self.startButton.userInteractionEnabled = work;
    self.isSmartVCSwitch.userInteractionEnabled = work;
}


- (void)moveVacuumCleaner {
    self.time --;
    if(!self.time) {
        [self actionStopButton:self.stopButton];
    } else {
        if(self.isSmartVCSwitch.isOn) {
            [self.vacuumCleaner startSmartVacuumCleanerBy:self.mapRoom];
        } else {
            [self.vacuumCleaner startVacuumCleanerBy:self.mapRoom];
        }
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
    [self modeVacuumCleanerWorks: NO];
    [self.mapRoom clearLabel];
    self.time = self.energySlider.value;
    self.vacuumCleaner.virtualMapRoom = [[PVAlgebraMatrix alloc]initWithRows:3 columns:3 setDefaultValueForAllElements:0];
    self.vacuumCleaner.lastPoint = CGPointMake(2, 2);
    self.vacuumCleaner.currentPoint = CGPointMake(2, 2);
    self.vacuumCleaner.degreeDirt = 0;
    self.vacuumCleaner.energy = self.energySlider.value;
    self.vacuumCleaner.speed = self.speedSlider.value;
    [self.vacuumCleaner setBackgroundColor:[UIColor blackColor]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.vacuumCleaner.speed * 2
                                                  target:self
                                                selector:@selector(moveVacuumCleaner)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (IBAction)actionStopButton:(UIButton *)sender {
    [self.vacuumCleaner setBackgroundColor:[UIColor blackColor]];
    [self modeVacuumCleanerWorks:YES];
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
    [self createLabelsOnMap];
    [self.mapView bringSubviewToFront:self.vacuumCleaner];
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

- (IBAction)actionShowVirtualMap:(UISwitch *)sender {
    [self.mapRoom labelIsHidden:!sender.on];
}

#pragma mark - PAMVacuumCleanerInfo
- (void) vacuumCleanerEnergy:(NSNumber *) energy degreeDirt:(NSNumber *) degreeDirt {
    self.residualEnergyLabel.text = [NSString stringWithFormat:@"Residual energy: %ld", (long)[energy integerValue]];
    int percentDiry = (int)([degreeDirt integerValue] * 100)/self.mapRoom.degreeDirt;
    self.degreeDirtLabel.text = [NSString stringWithFormat:@"Degree dirt: %ld/%ld (%d %%)", [degreeDirt integerValue], self.mapRoom.degreeDirt, percentDiry];
}

@end
