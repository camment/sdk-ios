Pod::Spec.new do |s|
  s.name = "CammentSDK"
  s.version = "1.0.0"
  s.summary = "iOS SDK for camment.tv"
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"Alexander Fedosov"=>"alex@camment.tv"}
  s.homepage = "https://github.com/camment/sdk-ios.git"
  s.description = "Camment is disrupting the second screen experience, replacing it with a patent pending first screen technology.\nOur technology is a simple SDK that allows broadcasters, and anyone with video, whether its streaming or clips, to add a social layer to their streams."
  s.frameworks = ["Foundation", "SystemConfiguration", "MobileCoreServices", "QuartzCore", "Accelerate", "CoreData", "AVFoundation", "UIKit", "ImageIO", "VideoToolbox", "MessageUI", "AssetsLibrary", "CoreImage", "CoreGraphics"]
  s.libraries = ["sqlite3", "z"]
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.1'
  s.ios.vendored_framework   = 'ios/CammentSDK.framework'
end
