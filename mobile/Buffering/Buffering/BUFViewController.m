//
//  BUFViewController.m
//  Buffering
//
//  Created by Nikil Viswanathan on 5/8/14.
//  Copyright (c) 2014 Nikil Viswanathan. All rights reserved.
//

#import "BUFViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#define SERVER_URL @"http://192.168.1.55:8080"

@interface BUFViewController ()<UIAccelerometerDelegate>

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) NSNumber *numReadingsForCurrentState;
@end


@implementation BUFViewController

@synthesize motionManager;

- (IBAction)pushupButtonClicked:(id)sender {
 
    NSLog(@"Button Clicked");
    [self logPushup];
}

/*
    Log Pushup
    ----------
 
 */
- (void)logPushup
{
    NSLog(@"\n\n\n---Did pushup!---\n\n\n");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"foo": @"bar"};
    
    [manager GET:SERVER_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
/*
    State machine for detecting pushups
 
    State 0 - Pushup STARTING to go DOWN (negative accelaration)
    State 1 - Pushup ENDING going DOWN (positive accelaration)
        wait a second here?
    State 2 - Pushup STARTING to go UP (positive accelaration)
    State 3 - Pushup ENDING going UP (negative accelaration)
 
    Finished (not really a state)
 
    Start in state 0
    
    Keep a count of the number of negative values seen (with threshold)
    Once we hit 3 negative values, switch to state 1
    
    Keep a count of the number of positive values seen (with threshold)
    Once we hit 3 positive values, increment pushup switch to state 0
 */

//Parameters (tweak)
#define NUM_READINGS_NEEDED 5
#define ACCELERATION_THRESHOLD 0.15

//States
#define NUM_STATES 4
#define STATE_DOWN_1_NEGATIVE 0
#define STATE_DOWN_2_POSITIVE 1
#define STATE_UP_1_POSITIVE 2
#define STATE_UP_2_NEGATIVE 3

- (void)viewDidLoad{
    [super viewDidLoad];

    self.state = [NSNumber numberWithInt:STATE_DOWN_1_NEGATIVE];
    self.numReadingsForCurrentState = [NSNumber numberWithInt:0];
    [self detectPushups];
}

/*
    Update State
 */
- (void)updateState:(double)userZAcceleration
{
    //If we have a valid acceleration for this state increment
    if(![self validAccelerationForState:userZAcceleration]) return;
    
    NSLog(@"Valid acceleration.  State: %@  Acceleration: %f", self.state, userZAcceleration);
    
    //Increment
    int newNumReadings = [self.numReadingsForCurrentState intValue] + 1;
    self.numReadingsForCurrentState = [NSNumber numberWithInt:newNumReadings];
    
    //If we have all of the necessary readings, update the state
    if([self.numReadingsForCurrentState intValue] >= NUM_READINGS_NEEDED)
        [self goToNextState];
    
    NSLog(@"%f", userZAcceleration);

}

/*
    Valid Accleration For State
    ---------------------------
 */
- (BOOL)validAccelerationForState:(double)acceleration
{
    //Convert to int for brevity
    int stateIntVal = [self.state intValue];
    
    //State 0 and 3 want negative acceleration
    if(stateIntVal == STATE_DOWN_1_NEGATIVE || stateIntVal == STATE_UP_2_NEGATIVE)
        return acceleration < 0;
    
    //State 1 and 2 want positive acceleration
    if(stateIntVal == STATE_DOWN_2_POSITIVE || stateIntVal == STATE_UP_1_POSITIVE)
        return acceleration > 0;
    
    //Should not get here (should be one of the previous states)
    NSLog(@"INVALID STATE---");
    return NO;
}

/*
    Go To Next State
    ----------------
 
 */
- (void)goToNextState
{
    //Get int value
    int currentState = [self.state intValue];
    
    //Increment the state
    int nextState = (currentState + 1) % NUM_STATES;
    self.state = [NSNumber numberWithInt:nextState];
    NSLog(@"Moved from state %d to state %d", currentState, nextState);

    //Clear the readings count value
    self.numReadingsForCurrentState = [NSNumber numberWithInt:0];
    
    //If we are back to zero, log pushup
    if(nextState == STATE_DOWN_1_NEGATIVE)
        [self logPushup];
}

/*
    Detect Pushups
    --------------
 
 */
- (void)detectPushups
{
    //Init the motion manager
    self.motionManager = [[CMMotionManager alloc] init];
    
    //If we have an accelerometer
    if ([self.motionManager isAccelerometerAvailable]){
  
        //Create a queue to do this
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        //Watch for the device updates
        //http://stackoverflow.com/questions/5214197/simple-iphone-motion-detect/5220796#5220796
        [self.motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
            float accelerationThreshold = ACCELERATION_THRESHOLD; // or whatever is appropriate - play around with different values
            CMAcceleration userAcceleration = motion.userAcceleration;
            if (fabs(userAcceleration.z) > accelerationThreshold)
                [self updateState:userAcceleration.z];
        }];
        
    } else {
        NSLog(@"Accelerometer is ...");
    };

}
@end
