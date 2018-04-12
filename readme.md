### Requirements

To get started with the Camment Mobile SDK for iOS you can set up the SDK and build a new project, or you can integrate the SDK in an existing project
To use the SDK, install the following on your development machine:
 - Xcode 7 or later
 - iOS 8.1 or later
 - Cocoapods

### Add CammentSDK framework to your Xcode project

Open yout Podfile and add `pod 'CammentSDK'` there

```ruby
platform :ios, '8.1'

target 'Your target' do
    use_frameworks!
    pod 'CammentSDK', :branch => 'rtve'
end
```
then run `pod install`

### Configure CammentSDK in project's Info.plist
Add following code to your Info.plist to prevent any restrictions from iOS, configure CammentSDK and Facebook app:
```xml
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>fb272405646569362</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>camment</string>
			</array>
		</dict>
	</array>
	<key>FacebookAppID</key>
	<string>272405646569362</string>
	<key>FacebookDisplayName</key>
	<string>Camment</string>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>fbapi</string>
		<string>fb-messenger-api</string>
		<string>fbauth2</string>
		<string>fbshareextension</string>
	</array>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<false/>
		<key>NSExceptionDomains</key>
		<dict>
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
			<key>cloudfront.net</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
		</dict>
	</dict>
	<key>NSCameraUsageDescription</key>
	<string>To be able to analyse your singing our karaoke robot needs an access to your camera</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>To be able to analyse your singing our karaoke robot needs an access to your microphone</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Photo library is used to provide better user experience</string>
	<key>UIAppFonts</key>
	<array>
		<string>Nunito-Medium.ttf</string>
		<string>Nunito-Light.ttf</string>
		<string>Nunito-Bold.ttf</string>
	</array>
```

### Copy custom fonts to your Xcode project

Camment SDK uses custom fonts `Nunito-Medium.ttf`, `Nunito-Light.ttf` and `Nunito-Bold.ttf`.
Make sure you downloaded fonts from our github and added the files to your project.
You can download the fonts by the links
- https://github.com/camment/sdk-ios/blob/rtve/Nunito-Medium.ttf
- https://github.com/camment/sdk-ios/blob/rtve/Nunito-Light.ttf
- https://github.com/camment/sdk-ios/blob/rtve/Nunito-Bold.ttf

### Set up the Camment SDK and Facebook SDK in AppDelegate.m

Open `AppDelegate.m` and import CammentSDK header:
```obj-c
#import <CammentSDK/CammentSDK.h>
#import <CammentSDK/CMFacebookIdentityProvider.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
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

    self.facebookIdentityProvider = [CMFacebookIdentityProvider new];
    [[CammentSDK instance] configureWithApiKey:YOUR_API_KEY identityProvider:self.facebookIdentityProvider];

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

### Open Karaoke view
In order to present a karaoke view with a list of all available songs you should instantiate `CMKaraokeShowListModule` and use one of `pushInNavigationController:`, `presentInViewController:` or even `presentInWindow:` methods. Take a look at the example below
``` obj-c
- (void)openKaraokeView {
    CMKaraokeShowListModule *showsList = [CMKaraokeShowListModule new];
    [showsList pushInNavigationController:self.navigationController];
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
    ...
}

- (void)cammentSDKWantsPresentViewController:(UIViewController *_Nonnull)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}
```

### Setup CammentSDK Delegate
When user joins any group SDK will notify you via `CMCammentSDKDelegate` delegate.
Implement `CMCammentSDKDelegate` wherever it works better for your app. General idea is implement the delegate in an object which can manage internal navigation between screens. We would recommend to implement those methods in the currently visible view controller.
```obj-c
@interface YourVisibleViewController()<CMCammentSDKDelegate>
@end
```
```obj-c

- (void)viewWillAppear:(BOOL)animated {
    ...
    [CammentSDK instance].sdkDelegate = self;
    ...
}

- (void)didOpenInvitationToShow:(CMShowMetadata *)metadata {
    [self openKaraokeView];
}

- (void)didJoinToShow:(CMShowMetadata *)metadata {
    // CammentSDK will open view with a show automatically
}
```
