platform :ios, '10.3'
use_frameworks!
inhibit_all_warnings!

target 'Toremoro' do

  # Architecture
  pod 'ReactorKit'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxViewController'
  pod 'RxAlertController'
  pod 'RxOptional'
  pod 'RxFirebase/RemoteConfig'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxKeyboard'
  pod 'RxGesture'

  # Networking
  pod 'Moya/RxSwift', '~> 11.0'

  # Firebase
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Performance'
  pod 'Firebase/DynamicLinks'

  # Search
  pod 'InstantSearchClient', '~> 6.0'

  # Fabric
  pod 'Fabric'
  pod 'Crashlytics'

  # Misc
  pod 'SwiftLint'
  pod 'SwiftyBeaver'
  pod 'Instantiate'
  pod 'ReusableKit'
  pod 'URLNavigator'
  pod 'Spring', git: 'https://github.com/MengTo/Spring.git', branch: 'swift4'
  pod 'Player', git: 'https://github.com/ya-s-u/Player.git'
  pod 'KMPlaceholderTextView'
  pod 'ExtensionProperty'
  pod 'Nuke'
  pod 'SwiftyUserDefaults', '4.0.0-alpha.1'
  pod 'ActiveLabel'
  pod 'Validator', git: 'https://github.com/ya-s-u/Validator.git'
  pod 'lottie-ios'
  pod 'FDFullscreenPopGesture', '1.1'
  pod 'PanModal'
  pod 'PluggableAppDelegate'
end

# https://qiita.com/ko2ic/items/f3be99bc15019abe1433
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
    end
  end
end
