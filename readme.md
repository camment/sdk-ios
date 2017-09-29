### Requirements

To get started with the Camment Mobile SDK for iOS you can set up the SDK and build a new project, or you can integrate the SDK in an existing project
To use the SDK, install the following on your development machine:
 - Xcode 7 or later
 - iOS 8.1 or later
 - Cocoapods

> Important:
> Use `com.camment.sdkdemo` bundle id if you are setting up demo app for CammentSDK.
> In other way login with Facebook account will not work


### Add CammentSDK framework to your Xcode project

Open yout Podfile and add 'CammentSDK' there

```ruby
platform :ios, '8.1'

target 'Your target' do
    use_frameworks!
    pod 'CammentSDK'
end
```
then run `pod install`

### Configure CammentSDK in project's Info.plist
The SDK requires access to Camment server as well as access to Facebook API. Add following code to your Info.plist to prevent any restrictions from iOS:
```xml
<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>cloudfront.net</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>amazonaws.com</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>amazonaws.com.cn</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
		</dict>
		<key>NSAllowsArbitraryLoads</key>
		<false/>
	</dict>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>fbapi</string>
		<string>fb-messenger-api</string>
		<string>fbauth2</string>
		<string>fbshareextension</string>
	</array>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>fb1630695620500234</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>camment</string>
			</array>
		</dict>
	</array>
	<key>NSCameraUsageDescription</key>
	<string>Camera is used to create camment chat and have discussions with short videos on your device</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>Microphone is used to create camment chat and have discussions with short videos on your device</string>
```

### Set up the SDK in AppDelegate.m

Open `AppDelegate.m` and import CammentSDK header:
```obj-c
#import <CammentSDK/CammentSDK.h>
```

Add following lines to AppDelegate's methods
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[CammentSDK instance] application:application didFinishLaunchingWithOptions:launchOptions];
    ...
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    ...
    return [[CammentSDK instance] application:application openURL:url options:options];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[CammentSDK instance] applicationDidBecomeActive:application];
    ...
}
```

Configure CammentSDK with an `API Key`
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...
    NSString *apiKey = @"YOUR_API_KEY";
    [[CammentSDK instance] configureWithApiKey:apiKey];
    ...
}
```
Now you are ready to use CammentSDK.

### Add CammentSDK overlay on top of your video player
Open a View Controller where you would like to use CammentSDK and import header
```obj-c
#import <CammentSDK/CammentSDK.h>
```
Create a new property with `CMCammentOverlayController` class. This class is a container for all camment overlay internal logic
```obj-c
@property (nonatomic, strong) CMCammentOverlayController *cammentOverlayController;
```
Instantiate controller and add it's subview on your view controller's view:
```obj-c
CMShowMetadata *metadata = [CMShowMetadata new];
metadata.uuid = @"Any string unique identifier of your show";
self.cammentOverlayController = [[CMCammentOverlayController alloc] initWithShowMetadata:metadata];
[self.cammentOverlayController addToParentViewController:self];
[self.view addSubview:[_cammentOverlayController cammentView]];
```

Notice that we ask you to provide identifier of your show:
```obj-c
CMShowMetadata *metadata = [CMShowMetadata new];
metadata.uuid = @"Any string unique identifier of your show";
```
Show identifier is any string which defines your show. Choose any uuid which is meaningfull for you.

Layout overlay subview properly:
```obj-c
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [[self.cammentOverlayController cammentView] setFrame:self.view.bounds];
}
```
Now add your player's view to camment overlay. Lets say that name of your player's variable is myPlayerView and it is subclass of UIView.
```obj-c
[self.cammentOverlayController setContentView:myPlayerView];
```
Check two important things:
 - myPlayerView doesn't have a superview, means you never add it like `[view addSubview: myPlayerView]`
 - you don't add myPlayerView on top of overlay view using default cocoa touch method `addSubview`. You should you `setContentView` instead.

Now we are almost done. There is one important thing left. For better user expierence we recommend to mute a video player when user starts recording camment and decrease volume at least by half when user plays camment. In order to do it - implement `CMCammentOverlayControllerDelegate` protocol:
```obj-c
self.cammentOverlayController.overlayDelegate = self;
```
The protocol provides four methods to notify your if camment is being recording or playing:
```obj-c
- (void)cammentOverlayDidStartRecording {
    // Mute your player here
}

- (void)cammentOverlayDidFinishRecording {
    // Restore normal volume
}

- (void)cammentOverlayDidStartPlaying {
    // Decrease volume level
}

- (void)cammentOverlayDidFinishPlaying {
    // Restore normal volume
}
```

### Setup CammentSDK Delegate (Optional)
When user accepts an invitation to any show SDK will notify you by `CMCammentSDKDelegate` delegate.
This step is optional, but usefull if you want to open a proper show when someone invites user to a group chat.
Implement `CMCammentSDKDelegate` wherever it works better for your app. General idea is implement the delegate in an object which can manage internal navigation between screens.
```obj-c
@interface YourRouterObject()<CMCammentSDKDelegate>
@end
```
```obj-c
- (void)didAcceptInvitationToShow:(CMShowMetadata *)metadata {
  NSString *showUuid = metadata.uuid;
  // open video player for show with uuid
}
```

