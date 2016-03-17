# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'Karuta' do
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
end

target 'KarutaTests' do

end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Karuta/Pods-Karuta-Acknowledgements.plist', 'Karuta/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

end