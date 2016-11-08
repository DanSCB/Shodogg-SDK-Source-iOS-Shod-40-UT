//
//  ShodoggSDK.h
//  ShodoggSDK
//
//  Created by stepukaa on 10/27/15.
//  Copyright © 2015 stepukaa. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ShodoggSDK.
FOUNDATION_EXPORT double ShodoggSDKVersionNumber;

//! Project version string for ShodoggSDK.
FOUNDATION_EXPORT const unsigned char ShodoggSDKVersionString[];

#import "SDRemoteReceiver.h"
#import "SDRemoteReceiverFireTV.h"
#import "SDRemoteReceiverLG.h"
#import "SDRemoteReceiverChromecast.h"
#import "SDRemoteReceiverSamsung.h"

#import "SDConnectableDevice.h"
#import "SDDeviceManager.h"
#import "SDErrorCode.h"

/**
 Preamble. 
 Sorry for English grammer.
 
 
 Overall information.
 
 The Shodogg SDK is the framework for mobile applications which allows the developer to 
 discover/connect to some particular devices (which are connected to the same LAN)  and perform 
 simple action with installed applications (launch with parameters /close). The devices are: LG on 
 WebOS platform, Chromecast, FireTV, Samsung Tizen (Cloude apps).
 
 
 Connect SDK connection.
 
 Current Shodogg SDK implementation is fully based on LG Connect SDK. Connect SDK is provide the
 abstraction for discovery and connectivity functionality. On current stage Shodogg SDK is wrapper
 for Connect SDK, which hides some Connect SDK features and simplify the interface. In plans is 
 usage of the ConnectSDK module approach to extend support for other devices.
 
 
 Connect SDK changes merge policies.
 
 Some functionality is require changes in Connect SDK sources (e.g trigger installation of the 
 application). Unfortunately we were not able to publish our changes to open source, so it was 
 decided to use the following development approach: The source code of Connect SDK is added to 
 Shodogg SDK project as a target dependency. Connect SDK repo is added as submodule in 
 Shodogg SDK repo.
 
 All our changes in Connect SDK are pushed to our local git repository. When we need to pull the 
 changes (some bug-fixes, etc...) from open source repository (which locates on github), the 
 developer need to add second remote for Connect SDK repository (the open source one) on his 
 workstation then pull changes from github and merge them with our local changes. After that push 
 changes to our local git repository. The final part is updated ConnectSDK submodule commit in 
 Shodogg SDK repository.
 
 
 Shodogg Integration instructions.
 
 Shodogg SDK is built as dynamic library target. The target library is compiled for armv7 and arm64 
 architectures.
 
 There are two approaches to use this framework:
 1. Copy the compiled framework to target project. Add it to Embedded binaries section in project 
    section. (it should be added to linked frameworks automatically). The shortcoming is that this 
    target will not be able to run on simulator (x86-64 architecture).
 
 2. Add Shodogg SDK project to target project as a dependency (drag and drop project to target 
    project). Add Shodogg SDK as a dependency target in targets Build Phases settings.
 
 Some additional info: We decided do not create fat dynamic library binary because iTunes connect 
 will reject the app if embedded binaries has i386 or x86-64 slices.
 
 The Samsung Multiscreen SDK is distributes as dynamic library as well. So this framework also 
 has to be embedded/linked with final product. (We are using this framework for communication with 
 Samsung devices).

 
 Fire TV communication implementation details.
 
 Fire TV Device communication is based on DIAL protocol. All other devices are working on 
 proprietary protocols. We've implemented a hack in ConnectSDK which finds dial only for FirTV 
 devices but not for others. That's required because DIAL protocol is not 100 % implemented on some 
 devices which leads to inconsistence in our code.
 
 To fix that we need to disable DIAL discovery and integrate Amazon Fling discovery and 
 communication module for FireTV devices. Default ConnectSDK module hasn't required functionality - 
 so Fling module should be developed.
 
 
 Samsung Multiscreen library implementation details.
 
 At the time of writing of this document iOS Samsung multiscreen library (officially distributed)
 was mulfunction (ServiceSearch class was not present in the interface). We've compiled our own 
 version of Multiscreen lib and used that. A couple of tiny changes has been done in SDK sources.
 The lib is present in repository.
 
*/