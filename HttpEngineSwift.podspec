#
# Be sure to run `pod lib lint HttpEngineSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HttpEngineSwift'
  s.version          = '0.1.0'
  s.summary          = 'A short description of HttpEngineSwift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/13162378587@163.com/HttpEngineSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '13162378587@163.com' => '13162378587@163.com' }
  s.source           = { :git => 'https://github.com/13162378587@163.com/HttpEngineSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'HttpEngineSwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HttpEngineSwift' => ['HttpEngineSwift/Assets/*.png']
  # }
  
  s.public_header_files = 'Pod/Classes/*.swift'
  s.dependency 'YYKit'
  s.dependency 'FMDB'
  s.dependency 'ISRemoveNull'
  s.dependency 'DateTools'
  s.dependency 'ReachabilitySwift'
  
  s.pod_target_xcconfig = {
        'VALID_ARCHS' => 'x86_64 armv7 arm64'
  }
  
  s.static_framework = true
  s.requires_arc = true
end
