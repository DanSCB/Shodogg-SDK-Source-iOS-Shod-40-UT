//
//  StartViewController.m
//  Discovery Two
//
//  Created by Dan Schnabel on 2016-10-17.
//  Copyright © 2016 Clearbridge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"


@implementation StartViewController

DiscoveryManager *discoveryManager;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!discoveryManager) {
        discoveryManager = [DiscoveryManager sharedManager];
    }
    [discoveryManager startDiscovery];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(int)numberOfDevicesFound{
    int count = (int) [[discoveryManager allDevices] count];
    return count;
}

@end
