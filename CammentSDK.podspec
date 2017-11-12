Pod::Spec.new do |s|
  s.name = "CammentSDK"
  s.version = "1.0.3"
  s.summary = "iOS SDK for camment.tv"
  s.authors = {"Alexander Fedosov"=>"alex@camment.tv"}
  s.homepage = "https://github.com/camment/sdk-ios.git"
  s.description = "Camment is disrupting the second screen experience, replacing it with a patent pending first screen technology.\nOur technology is a simple SDK that allows broadcasters, and anyone with video, whether its streaming or clips, to add a social layer to their streams."

  s.libraries = ["sqlite3", "z"]
  s.source = { :git => 'https://github.com/camment/sdk-ios.git', :tag => '1.0.3' }

  s.ios.deployment_target    = '8.1'
  s.ios.vendored_framework   = 'ios/CammentSDK.framework'

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

  s.dependency  'AMPopTip', '1.5'
  s.dependency  'Texture', '2.5.1'
  s.dependency  'FLAnimatedImage'
  s.dependency  'AWSCognito'
  s.dependency  'AWSCognitoIdentityProvider'
  s.dependency  'AWSIoT'
  s.dependency  'AWSMobileAnalytics'
  s.dependency  'AWSS3'
  s.dependency  'AWSAPIGateway'
  s.dependency  'FBSDKCoreKit'
  s.dependency  'FBSDKLoginKit'
  s.dependency  'FBSDKMessengerShareKit'
  s.dependency  'ReactiveObjC'
  s.dependency  'pop'
  s.dependency  'MBProgressHUD'
  s.dependency  'Tweaks'
  s.dependency  'DateTools'
  s.dependency  'CocoaLumberjack'
  s.dependency  'GVUserDefaults'
  s.dependency  'TLIndexPathTools'
  s.dependency  'Mixpanel'
  s.dependency  'TCBlobDownload'
end
