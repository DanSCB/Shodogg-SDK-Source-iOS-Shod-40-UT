ShodoggMIDKit
=============

This library allows you to integrate ShodoggMIDKit into your iOS app.

#### Installation
ShodoggMIDKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ShodoggMIDKit"
```

#### Create an application
To use ShodoggMIDKit, we need some information about you and the application you're building. 
Register your application to get your app public key.
	
 * [Shodogg MID portal](https://mid-pilot-dev.shodogg.com/mco-admin/html/index.html#/login)
 * [Register your application](http://shodogg.com)

#### Include umbrella header
Include the ShodoggMIDKit umbrella header in your app `Prefix.pch` file
```obj-c
#import "ShodoggMIDKit.h"
```

#### Initializing MID Client
MID Client can be initialized by adding following lines of code to `- (BOOL)application:didFinishLaunchingWithOptions:` delegate method.
###### YourAppDelegate.m
```obj-c
SHMIDClient *client = 
	[SHMIDClient clientWithAppKey:@"YOUR_APP_PUBLIC_KEY"
						 metadata:@"YOUR_APP_METADATA"
                  completionBlock:^(BOOL done, NSError *error) {
                  	//Your code here
                  }];
[SHMIDClient setSharedClient:client];
```

#### Registering URL scheme
The ShodoggMIDKit coordinates with the Shodogg APIs to simplify the auth process. But in order to smoothly hand the user back to your app, you need to add a unique URL scheme that Shodogg can call. You'll need to configure your project to add one:

 * Click on your target in the Project Navigator, choose the Info tab, expand the URL Types section at the bottom, and finally, press the `+` button.
 * In the URL Schemes enter `mid-APP_ID` (replacing APP_ID with the ID generated when you created your app).

 Now that your app is registered for correct scheme, you need to app following code to your app delegate

###### YourAppDelegate.m
 ```obj-c
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
         	 options:(nonnull NSDictionary<NSString *,id> *)options {
    
    if ([[SHMIDClient sharedClient] handleOpenURL:url]) {
        return YES;
    }
    
    return NO;
}
```

#### Authentication
With ShodoggMIDKit you can login using credential or supported social provider(s)

**Login with Credentials:**
###### Your view controller
```obj-c
[[SHMIDClient sharedClient] loginWithUsername:@"username" 
			   password:@"password" 
	  	completionBlock:^(NSError *error) {
		//Your code here
	}];
```

**Login with social provider(s):**

The class authenticating via ShodoggMIDKit must implement the `<SHMIDClientDelegate>` protocol in order to perform a callback after asynchronous authentication. 
###### Your view controller
```obj-c
- (IBAction)didPressFacebookButton {
	[[SHMIDClient sharedClient] loginWithFacebookFromController:self];
}
```

Above code presents a authorization view to complete the login process. `- (void)didFinishAuthentication` is called, in case of a success, 
otherwise, `- (void)didFinishAuthenticationWithError:` delegate method is called with error information.

**NOTE:** Similarly, `- (void)loginWithGoogleFromController:` method initiates authentication with Google account.

### Tracking
After the authentication has completed with success. Your app can start logging event tracking data via `SHMIDClient` instance.

**Content Requested**
###### Your view controller
```obj-c
SHMIDEventMetadata *event = [[SHMIDEventMetadata alloc] init];
event.assetId = @"YOUR_ASSET_ID";
[[SHMIDClient sharedClient] logContentRequested:event 
								completionBlock:nil];
```

Player **Played** a video
###### Your view controller
```obj-c
SHMIDEventMetadata *metadata = [[SHMIDEventMetadata alloc] init];
metadata.eventType = SHEventTypeContentPlay;
metadata.assetId   = @"YOUR_ASSET_ID";
   
[[SHMIDClient sharedClient] logContentEvent:metadata
	completionBlock:^(id data, NSError *error) {
	//Your code here
}];
```

Player **Seeked** a video
###### Your view controller
```obj-c
SHMIDEventMetadata *metadata = [[SHMIDEventMetadata alloc] init];
metadata.eventType     = SHEventTypeContentSeek;
metadata.assetId       = @"YOUR_ASSET_ID";
metadata.eventValue    = @"Seek_began_at";
metadata.eventValueOld = @"Seek_ended_at";
   
[[SHMIDClient sharedClient] logContentEvent:metadata
	completionBlock:^(id data, NSError *error) {
	//Your code here
}];
```

#### Example App
To run the example app, clone the repo, and run `pod install` from the `ShodoggMIDKit-Example` directory first.

#### Author
Shodogg, info@shodogg.com

#### License
ShodoggMIDKit is available under the BSD license. See the LICENSE file for more info.