# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'Pecomy' do
    pod 'R.swift', '~> 2'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'MDCSwipeToChoose'
    pod 'SDWebImage'
    pod 'Alamofire', '~> 3.5.0'
    pod 'SwiftyJSON', '~> 2'
    pod 'SnapKit', '~> 0.22.0'
    pod 'Google/Analytics'
    pod 'GoogleMaps'
    pod 'ObjectMapper', '~> 1.4.0'
    pod 'FBSDKLoginKit'
    pod 'KeychainAccess', '~> 2.4.0'
end

target 'PecomyTests' do

end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Pecomy/Pods-Pecomy-Acknowledgements.plist', 'Pecomy/Supporting Files/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
