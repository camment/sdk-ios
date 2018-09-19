### Requirements

To get started with the Camment Mobile SDK for iOS you can set up the SDK and build a new project, or you can integrate the SDK in an existing project
To use the SDK, install the following on your development machine:
 - Xcode 7 or later
 - iOS 9.0 or later
 - Cocoapods

### Setup Facebook SDK
Skip this step if your ios app has Facebook SDK installed already, but if you don't use it yet please follow the guide: https://developers.facebook.com/docs/ios/getting-started/

### Add CammentSDK framework to your Xcode project

Open yout Podfile and add `pod 'CammentSDK'` there

```ruby
platform :ios, '9.0'

target 'Your target' do
    use_frameworks!
    pod 'CammentSDK', :git => 'https://github.com/camment/sdk-ios.git', :tag => '3.0.4'
end
```
then run `pod install`

### Configure CammentSDK in project's Info.plist
Add following code to your Info.plist to prevent any restrictions from iOS:
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
	<key>CFBundleURLTypes</key>
	<array>
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

### Copy custom font to your Xcode project

Camment SDK uses custom fonts `Nunito-Medium.ttf` and `Nunito-Light`.
Make sure you downloaded fonts from our github and added the files to your project.
You can download fonts by the links
https://github.com/camment/sdk-ios/blob/master/Nunito-Medium.ttf
https://github.com/camment/sdk-ios/blob/master/Nunito-Light.ttf

Declare custom font in Info.plist file

```xml
<key>UIAppFonts</key>
<array>
  <string>Nunito-Medium.ttf</string>
  <string>Nunito-Light.ttf</string>
</array>
```

### Set up the SDK in AppDelegate.m

Open `AppDelegate.m` and import CammentSDK header:
```obj-c
#import <CammentSDK/CammentSDK.h>
#import <CammentSDK/CMFacebookIdentityProvider.h>
```

Add following lines to AppDelegate
```obj-c

@interface AppDelegate ()
@property (nonatomic, strong) CMFacebookIdentityProvider *facebookIdentityProvider;
@end

...

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [[CammentSDK instance] application:application didFinishLaunchingWithOptions:launchOptions];
    ...
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    [[CammentSDK instance] application:application openURL:url options:options];
    return handled;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    [[CammentSDK instance] openURL:url sourceApplication:sourceApplication annotation:annotation];
    return handled;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [[CammentSDK instance] applicationDidBecomeActive:application];
}
```

Configure CammentSDK with an `API Key`
```obj-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ...
    NSString *apiKey = @"YOUR_API_KEY";
    self.facebookIdentityProvider = [CMFacebookIdentityProvider new];
    [[CammentSDK instance] configureWithApiKey:apiKey
                              identityProvider:self.facebookIdentityProvider];
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
Before creating Camment overlay we need to provide few configuration options. First of all, create show metadata object which holds identifier of your show:
```obj-c
CMShowMetadata *metadata = [CMShowMetadata new];
metadata.uuid = @"Any string unique identifier of your show";
```
Show identifier is any string which defines your show. Choose any uuid which is meaningfull for you.
After that we need to create an object describing visual configuration for overlay layout.
```obj-c
CMCammentOverlayLayoutConfig *overlayLayoutConfig = [CMCammentOverlayLayoutConfig new];
// Let's display camment button at bottom right corner
overlayLayoutConfig.cammentButtonLayoutPosition = CMCammentOverlayLayoutPositionBottomRight;
```

Now instantiate controller and add it's subview on your view controller's view:
```obj-c
self.cammentOverlayController = [[CMCammentOverlayController alloc] initWithShowMetadata:metadata overlayLayoutConfig:overlayLayoutConfig];
[self.cammentOverlayController addToParentViewController:self];
[self.view addSubview:[_cammentOverlayController cammentView]];
```

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
### Setup CammentSDK UI Delegate
Camment SDK uses UIAlertController to present important messages, like invitations from other users. In order to make UIAlertController will be presented at correct place in view controllers hierarchy we need to handle UI delegate events. UI delegate has a method which will be called when SDK wants to present a notification:
```obj-c
- (void)cammentSDKWantsPresentViewController:(UIViewController * _Nonnull)viewController;
```
Place where to handle it properly depends on your app architecture, but at very basic setup you can handle this method at visible view controller:

```obj-c
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CammentSDK instance].sdkUIDelegate = self;
}

- (void)cammentSDKWantsPresentViewController:(UIViewController *_Nonnull)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}
```

### Setup CammentSDK Delegate
When user joins any gorup SDK will notify you via `CMCammentSDKDelegate` delegate.
Implement `CMCammentSDKDelegate` wherever it works better for your app. General idea is implement the delegate in an object which can manage internal navigation between screens.
```obj-c
@interface YourRouterObject()<CMCammentSDKDelegate>
@end
```
```obj-c
- (void)didJoinToShow:(CMShowMetadata *)metadata {
  NSString *showUuid = metadata.uuid;
  // open video player for show with uuid
}
```

## Synchronizing video between group members
CammentSDK makes sure everyone is watching a show at the same time. All the synchronization happens automatically, you just have to make sure that your video player reacts properly to all the events coming from SDK.
The first step is providing SDK current playback state from your player. We would recommend to do it every second and immediately when a user presses play/pause buttons, so when playback state has changed you should call

```obj-c
    CMShowMetadata *metadata = [CMShowMetadata new];
    metadata.uuid = @"YOUR_SHOW_IDENTIFIER";
    [[CammentSDK instance] updateVideoStreamStateIsPlaying:isPlaying
                                                      show:metadata
                                                 timestamp:timeInterval];
```
`isPlaying` here indicates if your video player paused or not
`metadata` is your show metadata object, you use the same to configure camment overlay
`timeInterval` is current playing position in seconds starting from show beginning

Take a look on a few examples.

```obj-c
    // User watched your show for one minute
    [[CammentSDK instance] updateVideoStreamStateIsPlaying:YES
                                                      show:metadata
                                                 timestamp:60];

    // Then paused video
    [[CammentSDK instance] updateVideoStreamStateIsPlaying:NO
                                                      show:metadata
                                                 timestamp:60];
    // Then started  again
    [[CammentSDK instance] updateVideoStreamStateIsPlaying:YES
                                                      show:metadata
                                                 timestamp:60];
    // After 1 second
    [[CammentSDK instance] updateVideoStreamStateIsPlaying:YES
                                                      show:metadata
                                                 timestamp:61];
    // etc
```

Sometimes CammentSDK has to know your player state immediately, without waiting until you call the update method. In order to provide player state by request you should implement the required method of `CammentOverlayControllerDelegate` protocol:

```obj-c
- (void)cammentOverlayDidRequestPlayerState:(void (^)(BOOL isPlaying, NSTimeInterval timestamp))playerStateBlock {
    // call playerStateBlock with current player state
    // Notice that CammentSDK don't need metadata object at the moment
    playerStateBlock(YES, 62);
}
```

By this moment we have established one-way communication between your video player and CammentSDK, so it knows all about the player position and state. If we want to synchronize video between multiple client SDK should have a way to change player state. To do that your application should subscribe to notification about new timestamps from CammentSDK:

```obj-c

- (void)viewDidLoad {
    [super viewDidLoad];
    ...
    // here you setup CammentSDK overlay
    ...
    // Subscribe to notification about player state
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewTimestamp:) name:CMNewTimestampAvailableVideoPlayerNotification object:[CammentSDK instance]];
    }

- (void)didReceiveNewTimestamp:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    NSTimeInterval newTimestamp = [(NSNumber *)dict[CMNewTimestampKey] doubleValue];
    BOOL isPlaying = [(NSNumber *)dict[CMVideoIsPlayingKey] boolValue];

    // here you already know if player should be paused or not and the right timestamp
    // pass those values to your video player
}  

```
