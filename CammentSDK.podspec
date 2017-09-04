#
#  Be sure to run `pod spec lint CammentSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CammentSDK"
  s.version      = "0.0.1"
  s.summary      = "The SDK for camment.tv"

  s.description  = <<-DESC
  		            The SDK for camment.tv
                   DESC

  s.homepage     = "https://camment.tv"
  s.license      = 'Apache License, Version 2.0'
  s.author       = { "Alexander Fedosov" => "alex@sportacam.com" }
  s.platform     = :ios, '8.1'
  s.source       = { :git => "https://github.com/camment/CammentSDK.git", :tag => "v0.0.1" }
  s.source_files  = 'CammentSDK/**/*.{h,m}', 'SCRecorder-2.7.0/Library/Sources/**/*.{h,m}'
  s.resources     = 'CammentSDK/Assets/*'
  s.requires_arc = true
  s.frameworks = 'AVFoundation', 'UIKit', 'ImageIO', 'VideoToolbox'
  s.dependency  'PINRemoteImage', '= 3.0.0-beta.9'
  s.dependency  'AMPopTip', '1.5'
  s.dependency  'PINCache'
  s.dependency  'FLAnimatedImage'
  s.dependency  'Texture'
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
  s.dependency  'Fabric'
  s.dependency  'Crashlytics'
  s.dependency  'DateTools'
  s.dependency  'CocoaLumberjack'
  s.dependency  'GVUserDefaults'
  s.dependency  'TLIndexPathTools'
end
