### Requirements

To get started with the Camment Mobile SDK for iOS you can set up the SDK and build a new project, or you can integrate the SDK in an existing project
To use the SDK, install the following on your development machine:
 - Xcode 7 or later
 - iOS 8.1 or later
 - Cocoapods

### Setup Facebook SDK
Skip this step if your ios app has Facebook SDK installed already, but if you don't use it yet please follow the guide: https://developers.facebook.com/docs/ios/getting-started/

### Add CammentSDK framework to your Xcode project

Open yout Podfile and add `pod 'CammentSDK'` there

```ruby
platform :ios, '8.1'

target 'Your target' do
    use_frameworks!
    pod 'CammentSDK'
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

Camment SDK uses custom font `Nunito-Medium.ttf`.
Make sure you downloaded this font from our github and added the file to your project.
You can download the font by the link
https://github.com/camment/sdk-ios/blob/master/Nunito-Medium.ttf

Declare custom font in Info.plist file

```xml
<key>UIAppFonts</key>
<array>
  <string>Nunito-Medium.ttf</string>
</array>
```

### Set up the SDK in AppDelegate.m

Open `AppDelegate.m` and import CammentSDK header:
```obj-c
#import <CammentSDK/CammentSDK.h>
#import <CammentSDK/CMFacebookIdentityProvider.h>
```

Add following lines to AppDelegate
```objc

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
```objc
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
When user accepts an invitation to any show SDK will notify you by `CMCammentSDKDelegate` delegate.
This step is optional, but usefull if you want to open a proper show when someone invites user to a group chat.
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
