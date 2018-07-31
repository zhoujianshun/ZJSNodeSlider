#
#  Be sure to run `pod spec lint ZJSNodeSlider.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name             = "ZJSNodeSlider"
  s.version          = "1.0.0"
  s.summary          = "A slider that can set nodes."
  s.description      = "A slider, similar in style to UISlider, but can set nodes."
  s.homepage         = "https://github.com/zhoujianshun/ZJSNodeSlider"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "zhoujianshun" => "https://github.com/zhoujianshun" }
  s.source           = { :git => "https://github.com/zhoujianshun/ZJSNodeSlider.git", :tag => s.version  }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = "ZJSNodeSlider/*.{h,m}"


end
