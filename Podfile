source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
inhibit_all_warnings!
xcodeproj 'DecorationChain'

target 'DecorationChain' do
    
    # reuse
    pod 'XXNibBridge', '~> 2.0'
    pod 'A2StoryboardSegueContext', '~> 1.0.1'
    pod 'AFBlurSegue', '~> 1.2'
    pod 'AFDynamicTableHelper', '0.1.0'
    #pod 'ACReuseQueue', '~> 0.0.1'
    
    # shorthand
    pod 'XPKit', :git => 'https://coding.net/huangxinping/XPKit.git', :tag => 'v1.0.0'
    pod 'RXCollections', '~>1.0'
    pod 'BlocksKit', '~> 2.2.5'
    pod 'NSObject-Tap', '~> 1.0.1'
    pod 'NSObject+AutoDescription', '~> 0.1'
    pod 'NSObject-NSCoding', '~> 1.0'
    pod 'NSObject+AssociatedDictionary', '~> 1.0'
    pod 'CLLocationManager-blocks', '~> 1.3.2'
    pod 'LMGeocoder', '~> 1.0.1'
    pod 'CSNNotificationObserver', '~> 0.9.2'
    pod 'FCUUID', '~> 1.1.4'
     
    # FRP & MVVM
    pod 'ReactiveCocoa', '~>2.4.2'
    pod 'ReactiveViewModel', '~>0.3'
    pod 'libextobjc', '~>0.4.1'
    pod 'ReactiveCocoaLayout', '~>0.4'
    pod 'NSString-HTML', '~> 0.0.1'
    
    # Network
    pod 'AFNetworking-RACExtensions', '~> 0.1.6'
    pod 'AFNetworking-RACRetryExtensions', '~> 0.1.1'
    
    # Model & CoreData
    pod 'MagicalRecord', '~> 2.2'
    pod 'JSONModel', '~> 1.0.1'
    
    # UI control
    pod 'RESideMenu', '~> 4.0.7'
    pod 'MJRefresh', '~> 0.0.1'
    pod 'SVProgressHUD', '~> 1.1.2'
    pod 'BTInfiniteScrollView', '~> 1.0.0'
    pod 'MarkupLabel', '~> 0.0.1'
    pod 'UIFolderTableView', :git => 'https://coding.net/huangxinping/UIFolderTableView.git', :tag => 'v1.0.0'
    pod 'XPToast', :git => 'https://coding.net/huangxinping/XPToast.git', :tag => 'v1.0.2'
    pod 'ICViewPager', '~> 1.5.1'
    pod 'LASIImageView', :git => 'https://github.com/lukagabric/LASIImageView.git', :commit => 'b8a6187b4bb205a01da0497c5bf414f6c163379e'
    pod 'DOPDropDownMenu', :git => 'https://coding.net/huangxinping/DOPDropDownMenu.git', :tag => '0.0.1'
    pod 'RatingBar', :git => 'https://coding.net/huangxinping/RatingBar.git', :tag => '0.0.2'
    pod 'JKCountDownButton', :git => 'https://coding.net/huangxinping/JKCountDownButton.git', :tag => '0.0.1'
    pod 'UIView+MGBadgeView', '~> 0.0.1'
    pod 'UITextView+Placeholder', '~> 1.0.9'

    # Unitile tool
    pod 'Masonry', '~> 0.5.3'
    pod 'IQKeyboardManager', '~> 3.2.1.0'
    pod 'MAThemeKit', '~>1.0'
    pod 'MZAppearance', '~> 1.1.3'

    # Animate
    pod 'Canvas', '~> 0.1.2'
    pod 'FastAnimationWithPOP', '~> 0.0.2'
    pod 'INTUAnimationEngine', '~> 1.2.0'
    pod 'Pgyer'

end

target :DecorationChainTests, :exclusive => true do
    pod 'Kiwi', '~>2.3.1'
    pod 'Expecta', '~> 0.3.1'
    pod 'OCMockito', '~> 1.3.1'
    pod 'OCHamcrest', '~> 4.1.1'
end

post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['FRAMEWORK_SEARCH_PATHS'] = [ '$(PLATFORM_DIR)/Developer/Library/Frameworks' ]
        end
    end
end