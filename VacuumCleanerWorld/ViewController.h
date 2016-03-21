//
//  ViewController.h
//  VacuumCleanerWorld
//
//  Created by iMac309 on 05.03.16.
//  Copyright © 2016 iMac309. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMVacuumCleaner.h"
#import "PAMMapRoom.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) PAMMapRoom *mapRoom;

@property (strong, nonatomic) IBOutlet UISwitch *isSmartVCSwitch;

@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UILabel *initialEnergyLabel;
@property (strong, nonatomic) IBOutlet UILabel *spentEnergyLabel;
@property (strong, nonatomic) IBOutlet UILabel *degreeDirtLabel;

@property (strong, nonatomic) IBOutlet UISlider *speedSlider;
@property (strong, nonatomic) IBOutlet UISlider *energySlider;

- (IBAction)actionChangeEnergy:(UISlider *)sender;
- (IBAction)actionChangeSpeed:(UISlider *)sender;

- (IBAction)actionStartButton:(UIButton *)sender;
- (IBAction)actionStopButton:(UIButton *)sender;
- (IBAction)actionRandomBarrier:(id)sender;
- (IBAction)actionRandomDirt:(id)sender;


@property (strong, nonatomic) IBOutlet PAMVacuumCleaner *vacuumCleaner;

@end

