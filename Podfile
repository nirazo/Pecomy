# Uncomment this line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

target 'Pecomy' do
    pod 'R.swift', '~> 5.0.0.alpha.2'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'MDCSwipeToChoose'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'SnapKit'
    pod 'GoogleMaps'
    pod 'ObjectMapper'
    pod 'FBSDKLoginKit'
    pod 'KeychainAccess'
    pod 'Kingfisher'
end

target 'PecomyTests' do

end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Target Support Files/Pods-Pecomy/Pods-Pecomy-Acknowledgements.plist', 'Pecomy/Supporting Files/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
