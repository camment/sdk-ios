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
  s.summary      = "The camera engine that is complete, for real."

  s.description  = <<-DESC
  		   Complete iOS camera engine with Vine-like tap to record, animated filters, slow motion, segments editing
                   DESC

  s.homepage     = "https://github.com/rFlex/SCRecorder"
  s.license      = 'Apache License, Version 2.0'
  s.author             = { "Simon CORSIN" => "simon@corsin.me" }
  s.platform     = :ios, '8.1'
  s.source       = { :git => "https://github.com/rFlex/SCRecorder.git", :tag => "v2.7.0" }
  s.source_files  = 'CammentSDK/**/*.{h,m}', 'SCRecorder-2.7.0/Library/Sources/**/*.{h,m}'
  s.resources     = 'CammentSDK/Assets/*'
  s.public_header_files = 'CammentSDK/Modules/CammentSDKFramework.h'
  s.requires_arc = true
  s.frameworks = 'AVFoundation', 'UIKit', 'ImageIO', 'VideoToolbox'
  s.ios.vendored_frameworks = 'Frameworks/*.framework'
  # s.dependency pod 'SCRecorder', :path => 'SCRecorder-2.7.0'

end
