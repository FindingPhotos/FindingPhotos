# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FindingPhotosProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FindingPhotosProject
    pod 'NMapsMap'
    pod 'SnapKit', '~> 5.6.0'
    pod 'IQKeyboardManagerSwift'
    pod 'FirebaseCore'
    pod 'FirebaseDatabase'
    pod 'FirebaseFirestore'
    pod 'FirebaseStorage'
    pod 'FirebaseMessaging'
    pod 'FirebaseAuth'
    pod 'RxSwift', '6.5.0'
    pod 'RxCocoa', '6.5.0'
    pod "RxGesture"
    pod 'RxViewController'
    pod 'RxDataSources', '~> 5.0'
    pod 'RealmSwift', '~>10'
    pod "RxRealm"

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end

end
