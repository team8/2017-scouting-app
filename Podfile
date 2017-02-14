# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

target '2017 Scouter' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for scouter
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Alamofire', '~> 4.0'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'QRCodeReader.swift', '~> 7.2.0'
  pod 'SwiftyDropbox'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
