Pod::Spec.new do |s|
s.name             = 'CammentSDK'
s.version          = '1.0.0'
s.summary          = 'iOS SDK for camment.tv'
s.platform = :ios

s.description      = <<-DESC
Camment is disrupting the second screen experience, replacing it with a patent pending first screen technology.
Our technology is a simple SDK that allows broadcasters, and anyone with video, whether its streaming or clips, to add a social layer to their streams.
DESC

s.homepage         = 'https://github.com/alexfedosov/CammentSDK'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Alexander Fedosov' => 'alex@camment.tv' }
s.source           = { :git => 'https://github.com/camment/sdk-ios.git', :tag => '1.0.0' }

s.ios.deployment_target = '8.1'

s.prefix_header_file = 'CammentSDK/Classes/Prefix.h'

s.subspec 'FacebookAuthProvider' do |ss|
   ss.public_header_files = 'CammentSDK/AuthProviders/Facebook/**/*.h'
   ss.source_files = 'CammentSDK/AuthProviders/Facebook/**/*.{h,m,mm,cpp}'
   ss.dependency  'FBSDKCoreKit'
   ss.dependency  'FBSDKLoginKit'
end

s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'CammentSDK/Tests/**/*.{h,m,mm,cpp}'
    test_spec.dependency  'Specta'
    test_spec.dependency  'Expecta'
    test_spec.dependency  'OCMock'
    test_spec.requires_app_host = true
end

s.resources = 'CammentSDK/Assets/**/*'
s.public_header_files = 'CammentSDK/Classes/Public/*.{h}', 'CammentSDK/Classes/Internal/*.{h}'
s.source_files = 'CammentSDK/Classes/**/*.{h,m,mm,cpp}'

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

s.dependency  'AMPopTip', '1.5'
s.dependency  'Texture', '2.5.1'
s.dependency  'FLAnimatedImage'
s.dependency  'AWSCognito'
s.dependency  'AWSCognitoIdentityProvider'
s.dependency  'AWSIoT'
s.dependency  'AWSMobileAnalytics'
s.dependency  'AWSS3'
s.dependency  'AWSAPIGateway'
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
