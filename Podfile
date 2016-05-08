# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'Pecomy' do
    pod 'R.swift'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'MDCSwipeToChoose'
    pod 'SDWebImage'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'SnapKit'
    pod 'Google/Analytics'
    pod 'GoogleMaps'
    pod 'ObjectMapper'
    pod 'Bolts'
    pod 'FBSDKCoreKit'
    pod 'FBSDKShareKit'
    pod 'FBSDKLoginKit'
    pod 'KeychainAccess'
end

target 'PecomyTests' do

end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Pecomy/Pods-Pecomy-Acknowledgements.plist', 'Pecomy/Supporting Files/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

end
