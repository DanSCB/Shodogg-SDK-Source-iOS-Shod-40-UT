ShodoggAPIKit
=============

### Installation

ShodoggAPIKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ShodoggAPIKit"
```

or link as **Static Library**

 1. Copy library files into your project

 ![Copy Files](https://www.dropbox.com/s/0dveewzt9nofa6a/copy_files.png?dl=1 "Copy Files")

 2. Make sure your app is linked with library
 
 *{your_app_target}>Build Phases>Link Binary with Libraries>libShodoggAPIKit.a*

 ![Build Phases](https://www.dropbox.com/s/vx42f1yg1vc0c0z/link_with_libraries.png?dl=1 "Build Phases")
 
 3. Import `ShodoggAPIKit.h` in your app `Prefix.pch` file

 ![Import Header](https://www.dropbox.com/s/0p9xveax42gnk5l/import_header.png?dl=1 "Import Header")

## Usage

**Initialization**

`SHUbeAPIClient` needs to be initialized before it can be used to make API calls

```obj-c
NSURL *serverURL = [NSURL URLWithString:@"shodogg_server_url"];
SHUbeAPIClient *client = [SHUbeAPIClient clientWithBaseBaseURL:serverURL];
[SHUbeAPIClient setSharedClient:client];
```
*After client is initialized you can start interacting with the API*

**Login**

```obj-c
[SHUser loginUserWithEmail:@"user_email_address" 
				  password:@"passsword" 
		   completionBlock:^(SHUser *user, NSError *error) {
    			//Your code here
		   }];
```

**Connecting to Receiving Screen**

There are two ways for establishing connection with Receiving Screen:
 * Connect with Sync Code
 * Connect with EventURL

**Connecting with Sync Code**

```obj-c
[SHScreen connectScreenWithCode:@"sync_code" 
  				completionBlock:^(id data, NSError *error) {
        			//NSString *screenSessionId = data[@"screenSessionId"];
	  				//screenSessionId is required for sending commands
    			}];
```
*Sync code can be retrieved by going to server url you are connected to in a web browser*

**Connect with EventURL**

```obj-c
[SHEventUrl connectEventURLWithId:@"eventurl_id" 
     				   enableLock:NO
				  completionBlock:^(NSDictionary *result, NSError *error) {
        			//You get back a dictionary with screen session data
					//SHScreenSesssion *session = result[@"session"];
 				}];
```
*A list of users event urls can be retrieved from `getUserEventURLsWithCompletionBlock:` class method on `SHEventUrl`*

####Sending Commands

**Play youtube video**

```obj-c
[SHScreen youtubeCommandPlayWithURL:@"video_url"
					completionBlock:^(BOOL success, NSError *error) {
                		//Your code here
            		}];
```

**Pause youtube video**

```obj-c
[SHScreen youtubeCommandPauseWithURL:@"video_url"
  					 completionBlock:^(BOOL success, NSError *error) {
                	 	//Your code here
        	  		 }];
```

**Volume**
	    
*level*: 0 - 100 (0 for mute)
```obj-c
[SHScreen youtubeCommandVolumeWithURL:@"video_url"
							   volume:@(level)
    		completionBlock:^(BOOL success, NSError *error) {
                //Your code here
            }];
```

**Seek**

*seek_value*: number of seconds to seek forward or back on timescale
e.g +30 seek forward by 30 seconds, -30 seek back by 30 seconds

```obj-c
[SHScreen youtubeCommandSeekWithURL:@"video_url"
							   seek:@(seek_value)
  					completionBlock:^(BOOL success, NSError *error) {
                		//Your code here
            		}];
```

**Toss an Image of type: `.png` `.jpg` `.gif`**

```obj-c
[SHScreen tossImageWithURL:@"image_url"
     	   completionBlock:^(BOOL success, NSError *error) {
        	   //Your code here
    		}];
```

**Toss a page of document type: `.xls` `.doc` `.pdf` `.ppt`**

```obj-c
[SHScreen tossAssetPageWithAssetId:@"asset_id"
                              page:@(page_number)
                   completionBlock:^(BOOL success, NSError *error) {
						//Your code here
					}];
```

### Dependencies

ShodoggAPIKit has dependency on following third-party libraries:
 * [AFNetworking](https://github.com/AFNetworking/AFNetworking)
 * [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)
 * [UIDevice-Hardware](https://github.com/erichoracek/UIDevice-Hardware)
 * [Reachability](https://github.com/tonymillion/Reachability)

These library can either be linked as [Static Libraries](https://developer.apple.com/library/ios/technotes/iOSStaticLibraries/Articles/configuration.html) or as [CocoaPods](http://cocoapods.org)

### Author

Shodogg, info@shodogg.com

## License

ShodoggAPIKit is available under the BSD license. See the LICENSE file for more info.