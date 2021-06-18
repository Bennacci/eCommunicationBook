# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['LD_NO_PIE'] = 'NO'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end

target 'eCommunicationBook' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for eCommunicationBook

  pod 'Firebase/Firestore'
  pod 'FirebaseFirestoreSwift', '~> 7.0-beta'
  pod 'FirebaseStorage'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Analytics'
  pod 'FSCalendar'
  pod 'lottie-ios'
  pod 'Charts'
  pod 'SwiftyMenu', '~> 0.6.5'
  pod 'ChameleonFramework'
  pod 'FirebaseAuth'
  pod 'CollectionViewPagingLayout'
  pod 'EasyRefresher'
  pod 'Kingfisher'
  pod 'JGProgressHUD'
  pod 'MJRefresh'
  pod 'IQKeyboardManagerSwift'
  pod 'SwiftLint'
  

end

