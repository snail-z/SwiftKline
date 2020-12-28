#
# Be sure to run `pod lib lint PKCategories.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PKCategories'
  s.version          = '0.3.1'
  s.summary          = 'A collection of category kit for iOS development.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#   s.description      = <<-DESC
# TODO: Add long description of the pod here.
#                        DESC

  s.homepage         = 'https://github.com/PsychokinesisTeam/PKCategories'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PsychokinesisTeam' => 'haozhang0770@163.com' }
  s.source           = { :git => 'https://github.com/PsychokinesisTeam/PKCategories.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PKCategories/Classes/PKCategories.h'
  
  # 添加子spec
  s.subspec 'Foundation' do |ss|
    ss.source_files = 'PKCategories/Classes/Foundation/**/*'
    ss.public_header_files = 'PKCategories/Classes/Foundation/**/*.h'
  end

  s.subspec 'UIKit' do |ss|
    ss.source_files = 'PKCategories/Classes/UIKit/**/*'
    ss.public_header_files = 'PKCategories/Classes/UIKit/**/*.h'
  end

  s.subspec 'Other' do |ss|
    ss.source_files = 'PKCategories/Classes/Other/**/*'
    ss.public_header_files = 'PKCategories/Classes/Other/**/*.h'
  end
  
end
