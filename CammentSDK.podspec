Pod::Spec.new do |s|
  s.name = "CammentSDK"
  s.version = "2.1.6"
  s.summary = "iOS SDK for camment.tv"
  s.authors = {"Alexander Fedosov"=>"alex@camment.tv"}
  s.homepage = "https://github.com/camment/sdk-ios.git"
  s.description = "Camment is disrupting the second screen experience, replacing it with a patent pending first screen technology.\nOur technology is a simple SDK that allows broadcasters, and anyone with video, whether its streaming or clips, to add a social layer to their streams."
  s.source = { :git => 'https://github.com/camment/sdk-ios.git', :tag => '2.1.6' }

  s.ios.deployment_target    = '8.1'

  s.ios.vendored_framework   = 'ios/CammentSDK.framework'
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
  s.dependency  'Texture', '~> 2.5'
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
  s.dependency  'TCBlobDownload', '~> 2.1'
  s.dependency  'FBSDKCoreKit', '~> 4.29'
  s.dependency  'FBSDKLoginKit', '~> 4.29'
  s.dependency  'TBStateMachine', '6.7.2'
end
