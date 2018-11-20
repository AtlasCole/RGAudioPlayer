#
# Be sure to run `pod lib lint RGAudioPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RGAudioPlayer'
  s.version          = '0.1.0'
  s.summary          = 'RGAudioPlayer play audio.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
 RGAudioPlayer  播放音频组件基于Superpowered
                       DESC

  s.homepage         = 'https://github.com/sherlockmm/RGAudioPlayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sherlockmm' => 'sherlock_zms@163.com' }
  s.source           = { :git => 'https://github.com/sherlockmm/RGAudioPlayer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'


  s.source_files = 'RGAudioPlayer/Classes/Core/*.{h,m}'
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  s.vendored_frameworks = "RGAudioPlayer/Classes/FXAudio/FXAudio.framework"
  s.frameworks         = "MediaPlayer", "AVFoundation", "AudioToolbox","CoreMedia","VideoToolbox","GLKit","Accelerate"
  s.libraries          = "stdc++"
  
  # s.resource_bundles = {
  #   'RGAudioPlayer' => ['RGAudioPlayer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
