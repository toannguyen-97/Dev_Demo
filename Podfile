# Uncomment the next line to define a global platform for your project
source 'https://github.com/LivePersonInc/iOSPodSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

def shared_pods
  use_frameworks!
  pod 'Alamofire'
  pod 'IQKeyboardManagerSwift', '~> 6.5'
  pod 'AlamofireNetworkActivityLogger'
  pod 'ACProgressHUD-Swift'
  pod 'SDWebImage', '~> 5.0'
  pod 'EasyTipView', '~> 2.1.0'
  pod 'KeychainAccess'
  pod 'ListPlaceholder'
  pod 'LPMessagingSDK'
  pod 'GooglePlaces'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Adyen'
end


target 'GMA' do
  shared_pods
end

target 'GMA-Production' do
  shared_pods
end

post_install do |installer|
  installer.aggregate_targets.each do |target|
    target.xcconfigs.each do |variant, xcconfig|
      xcconfig_path = target.client_root + target.xcconfig_relative_path(variant)
      IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
    end
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      if config.base_configuration_reference.is_a? Xcodeproj::Project::Object::PBXFileReference
        xcconfig_path = config.base_configuration_reference.real_path
        IO.write(xcconfig_path, IO.read(xcconfig_path).gsub("DT_TOOLCHAIN_DIR", "TOOLCHAIN_DIR"))
      end
    end
  end
end
