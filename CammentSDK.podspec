#
# Be sure to run `pod lib lint CammentSDKLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'CammentSDK'
s.version          = '0.1.1'
s.summary          = 'A short description of CammentSDK'
s.platform = :ios

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/alexfedosov/CammentSDK'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'alexfedosov' => 'alexander.a.fedosov@gmail.com' }
s.source           = { :git => 'https://bitbucket.org/sportacam/sportacam-ios-sdk', :branch => 'develop' }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '8.1'

s.prefix_header_file = 'CammentSDK/Classes/Prefix.h'

s.source_files = 'CammentSDK/Classes/**/*.{h,m,mm,cpp}'

s.resource_bundles = {
'CammentSDK' => ['CammentSDK/Assets/**/*']
}

s.public_header_files = 'CammentSDK/Classes/Public/**/*', 'CammentSDK/Classes/Internal/**/*'

s.frameworks = [
  'Foundation',
  'AVFoundation',
  'UIKit',
  'ImageIO',
  'VideoToolbox',
  'MessageUI',
  'AssetsLibrary',
  'CoreImage'
]

s.dependency  'AMPopTip', '1.5'
s.dependency  'Texture'
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
end
