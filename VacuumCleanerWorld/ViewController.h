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

- (IBAction)actionStartButton:(UIButton *)sender;
- (IBAction)actionStopButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet PAMVacuumCleaner *vacuumCleaner;

@end

