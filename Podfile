platform :ios, '8.0'
target 'CHGank' do
pod 'AFNetworking'
pod 'MJRefresh'
pod 'SVProgressHUD'
pod 'TMCache'
pod 'SDWebImage'
pod 'DZNEmptyDataSet'
use_frameworks!
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
    end
end