Pod::Spec.new do |s|
s.name             = 'CammentSDK'
s.version          = '3.0.3'
s.summary          = 'iOS SDK for camment.tv'
s.platform = :ios

s.description      = <<-DESC
Camment is disrupting the second screen experience, replacing it with a patent pending first screen technology.
Our technology is a simple SDK that allows broadcasters, and anyone with video, whether its streaming or clips, to add a social layer to their streams.
DESC

s.homepage         = 'https://github.com/alexfedosov/CammentSDK'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Alexander Fedosov' => 'alex@camment.tv' }
s.source           = { :git => 'https://github.com/camment/sdk-ios.git', :tag => '3.0.2' }

s.ios.deployment_target = '9'

s.prefix_header_file = 'CammentSDK/Classes/Prefix.h'
s.resources = 'CammentSDK/Assets/**/*'
s.source_files = 'CammentSDK/Classes/**/*.{h,m,mm,cpp}'
s.public_header_files = 'CammentSDK/Classes/**/*.{h}'

s.library = 'sqlite3', 'z'
s.frameworks = [
  'Foundation',
  'SystemConfiguration',
  'MobileCoreServices',
  'QuartzCore',
  'Accelerate',
  'CoreData',
  'AVFoundation',
  'UIKit',
  'ImageIO',
  'VideoToolbox',
  'MessageUI',
  'AssetsLibrary',
  'CoreImage',
  'CoreGraphics',
  'CoreText'
]

s.dependency  'AMPopTip', '~> 1.5'
s.dependency  'Texture', '~> 2.7'
s.dependency  'FLAnimatedImage', '~> 1.0'
s.dependency  'AWSCognito', '~> 2.6'
s.dependency  'AWSCognitoIdentityProvider', '~> 2.6'
s.dependency  'AWSIoT', '~> 2.6'
s.dependency  'AWSMobileAnalytics', '~> 2.6'
s.dependency  'AWSS3', '~> 2.6'
s.dependency  'AWSAPIGateway', '~> 2.6'
s.dependency  'ReactiveObjC', '~> 3.1'
s.dependency  'pop', '~> 1.0'
s.dependency  'MBProgressHUD', '~> 1.1'
s.dependency  'Tweaks', '~> 2.2'
s.dependency  'DateTools', '~> 2.0'
s.dependency  'CocoaLumberjack', '~> 3.4'
s.dependency  'GVUserDefaults', '~> 1.0'
s.dependency  'TLIndexPathTools', '~> 0.4'
s.dependency  'Mixpanel', '~> 3.2'
s.dependency  'TBStateMachine', '~> 6.7'
s.dependency  'TBStateMachine/DebugSupport'
s.dependency  'FBSDKCoreKit', '~> 4.29'
s.dependency  'FBSDKLoginKit', '~> 4.29'
s.dependency  'YapDatabase', '3.1.1'
s.dependency  'Bolts'
s.dependency  'CammentAds'

end
