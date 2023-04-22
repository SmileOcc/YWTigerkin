source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

target ‘YWTigerkin’ do
#pod 'ReactiveCocoa', '~> 11.0.0'
#pod 'ReactiveObjC', '~> 3.1.1'
#pod 'ReactiveObjCBridge', '~> 6.0.0'

pod 'RxSwift'
pod 'RxCocoa'
pod 'RxGesture'
pod 'Reusable', '~> 4.1.1'
pod 'NSObject+Rx'


# 基于RxSwift的工作流
#pod 'RxFlow'

pod 'URLNavigator'

# 网络请求
pod 'Moya/RxSwift'

#pod 'Alamofire-Synchronous'

# 支持OC 和 Swift
#pod 'Bugly'

# 键盘管理类
pod 'IQKeyboardManagerSwift', '~> 6.5.5'

# Swift json
#pod 'SwiftyJSON', '~> 4.2.0'

# 图片缓存库，支持OC 和 Swift
#pod 'SDWebImage', '~> 5.0'

# 支持OC，对Swift支持度未知
#pod 'SDCycleScrollView', '~> 1.80'
#pod 'SDWebImageWebPCoder'

#pod 'mob_sharesdk'
#pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'
#pod 'mob_sharesdk/ShareSDKPlatforms/Twitter'
#pod 'mob_sharesdk/ShareSDKPlatforms/Facebook'
#pod 'mob_sharesdk/ShareSDKPlatforms/WhatsApp'
#pod 'mob_sharesdk/ShareSDKPlatforms/Messenger'
#pod 'mob_sharesdk/ShareSDKPlatforms/Line'
#pod 'mob_sharesdk/ShareSDKPlatforms/Instagram'
#pod 'mob_sharesdk/ShareSDKPlatforms/Telegram'
#pod 'mob_sharesdk/ShareSDKExtension'
#pod 'Firebase/Auth'
#pod 'GoogleSignIn'
#pod 'Firebase/Analytics'
#pod 'Firebase/Crashlytics'

pod 'MJRefresh', '3.2.0'
#pod 'CYLTabBarController/Lottie', '~> 1.28.0'
#pod 'MLeaksFinder'
pod 'SAMKeychain'
#pod 'YYText'
#pod 'UITableView+FDTemplateLayoutCell', '~> 1.6'
#pod 'Protobuf'
#pod 'CocoaAsyncSocket'
#pod 'PPSPing', '~> 0.3.0'
#pod 'SwiftProtobuf', '~> 1.10.2'
pod 'MMKV'
#pod 'DZNEmptyDataSet'

#AppDelegate瘦身类
#pod 'PluggableApplicationDelegate', :git => 'https://github.com/fmo91/PluggableApplicationDelegate.git'

#腾讯云COS库【精简版】
#pod 'QCloudCOSXML/Transfer'

#zip压缩和解压库
#pod 'SSZipArchive'

#WCDB是一个高效、完整、易用的移动数据库框架，基于SQLCipher，支持iOS, macOS和Android
#pod 'WCDB'

#Powerful, Easy to use alert view or popup view on controller and window, support blur effects,custom view and animation,for objective-c,support iphone, ipad
#pod 'TYAlertController'

#图表绘制软件
#pod 'Charts'

#神策数据分析
#pod 'SensorsAnalyticsSDK'

#SnapKit is a DSL to make Auto Layout easy on both iOS and OS X.
pod 'SnapKit'

pod 'Masonry'

#pod 'TXLiteAVSDK_Professional'
#pod 'TCBeautyPanel'

#pod 'TZImagePickerController'
# QMUI模块
#pod 'QMUIKit', '~> 4.4.3'

# Lottie动画
pod 'lottie-ios'

# 富文本处理框架
#pod 'DTCoreText'

# HUD模块
pod 'MBProgressHUD'

# R.swift 自动生成资源文件方法
#pod 'R.swift', '~> 5.2.2'

# swift版本的加密库
pod 'CryptoSwift'

pod 'YYModel'
pod 'YYWebImage'
pod 'YYImage/WebP'
pod 'YYText'

#pod 'RxDataSources'

# 私有库
#pod 'Kit', :git => 'ssh://git@xxx.com:222/YWPods/Kit.git'

pod 'SwifterSwift'

# collectionView框架
#pod 'IGListDiffKit', :path => 'IGListKit/IGListDiffKit.podspec'
#pod 'IGListKit', :path => 'IGListKit/IGListKit.podspec'
#pod 'IGListSwiftKit', :path => 'IGListKit/IGListSwiftKit.podspec'

#pod 'QQ_XGPush', '~> 3.3.7'

#pod 'AppsFlyerFramework'

#pod 'RSKGrowingTextView'

#pod 'FLAnimatedImage', :git => 'https://github.com/Flipboard/FLAnimatedImage', :branch => 'master'

#pod 'JumioMobileSDK/Netverify', '~>3.8.0' # Use full Netverify and Authentication functionality
#pod 'JumioMobileSDK/NetverifyBase', '~>3.8.0' # For Fastfill, Netverify basic functionality
#pod 'JumioMobileSDK/NetverifyNFC', '~>3.8.0' # For Fastfill, Netverify functionality with NFC extraction
#pod 'JumioMobileSDK/NetverifyBarcode', '~>3.8.0' # For Fastfill, Netverify functionality with barcode extraction
#pod 'JumioMobileSDK/NetverifyFace+iProov', '~>3.8.0' # For Fastfill, Netverify functionality with identity verification, Authentication
#pod 'iProov'

pod 'JXSegmentedView', '1.2.7'
pod 'JXPagingView/Paging'

#pod 'BRPickerView'

#pod 'Onfido'
#pod 'OnfidoExtended'

#轮播组件
pod 'FSPagerView'

pod 'Then'

pod 'SHFullscreenPopGestureSwift'

# post_install 是在pod install 执行之后执行
#【对应的pre_install 则是在pod install 执行之前】
# 以下代码的作用是在执行pod install 之后，对SIT、DEV、UAT、MOCK等build configuration执行一些build setting设置
# 其中
# 1、DEBUG_INFORMATION_FORMAT会影响到Bugly的使用
# 2、GCC_PREPROCESSOR_DEFINITIONS和SWIFT_ACTIVE_COMPILATION_CONDITIONS会影响到MLeaksFinder的使用
post_install do |installer|
    # 用于记录Debug模式下DEBUG_INFORMATION_FORMAT的值
    $D_DEBUG_INFORMATION_FORMAT = 'dwarf-with-dsym'

    # 用于记录Debug模式下ONLY_ACTIVE_ARCH的值
    $D_ONLY_ACTIVE_ARCH = 'YES'

    # 用于记录Debug模式下ENABLE_TESTABILITY的值
    $D_ENABLE_TESTABILITY = 'YES'

    # 用于记录Debug模式下GCC_OPTIMIZATION_LEVEL的值
    $D_GCC_OPTIMIZATION_LEVEL = 0

    # 用于记录Debug模式下SWIFT_ACTIVE_COMPILATION_CONDITIONS的值
    $D_SWIFT_ACTIVE_COMPILATION_CONDITIONS = 'DEBUG'

    # 用于记录Debug模式下MTL_ENABLE_DEBUG_INFO的值
    $D_MTL_ENABLE_DEBUG_INFO = 'INCLUDE_SOURCE'

    # 用于记录Debug模式下SWIFT_COMPILATION_MODE的值
    $D_SWIFT_COMPILATION_MODE = 'singlefile'

    # 用于记录Debug模式下SWIFT_OPTIMIZATION_LEVEL的值
    $D_SWIFT_OPTIMIZATION_LEVEL = '-Onone'

    installer.pods_project.build_configurations.each do |configuration|
        if configuration.name == 'Debug'
            $D_ONLY_ACTIVE_ARCH = configuration.build_settings['ONLY_ACTIVE_ARCH']
            $D_ENABLE_TESTABILITY = configuration.build_settings['ENABLE_TESTABILITY']
            $D_GCC_OPTIMIZATION_LEVEL = configuration.build_settings['GCC_OPTIMIZATION_LEVEL']
            $D_ENABLE_NS_ASSERTIONS = configuration.build_settings['ENABLE_NS_ASSERTIONS']
            $D_SWIFT_ACTIVE_COMPILATION_CONDITIONS = configuration.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS']
            $D_MTL_ENABLE_DEBUG_INFO = configuration.build_settings['MTL_ENABLE_DEBUG_INFO']
            $D_SWIFT_OPTIMIZATION_LEVEL = configuration.build_settings['SWIFT_OPTIMIZATION_LEVEL']
        end
    end

    installer.pods_project.build_configurations.each do |configuration|
        if configuration.name == 'DEV' || configuration.name == 'SIT' || configuration.name == 'MOCK' || configuration.name == 'UAT'
            configuration.build_settings['DEBUG_INFORMATION_FORMAT'] = $D_DEBUG_INFORMATION_FORMAT
            configuration.build_settings['ONLY_ACTIVE_ARCH'] = $D_ONLY_ACTIVE_ARCH
            configuration.build_settings['ENABLE_TESTABILITY'] = $D_ENABLE_TESTABILITY
            configuration.build_settings['GCC_OPTIMIZATION_LEVEL'] = $D_GCC_OPTIMIZATION_LEVEL

            # FIXME : 此处直接赋值，是因为不知道为什么用Debug中的值赋值后无效，暂时先使用直接赋值的方式
            configuration.build_settings['ENABLE_NS_ASSERTIONS'] = 'YES'

            # GCC_PREPROCESSOR_DEFINITIONS不采用Debug模式覆盖的模式，直接追加
            configuration.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << " DEBUG=1"
            configuration.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = $D_SWIFT_ACTIVE_COMPILATION_CONDITIONS
            configuration.build_settings['MTL_ENABLE_DEBUG_INFO'] = $D_MTL_ENABLE_DEBUG_INFO
            
            # FIXME : 此处直接赋值，是因为不知道为什么用Debug中的值赋值后无效，暂时先使用直接赋值的方式
            configuration.build_settings['SWIFT_COMPILATION_MODE'] = $D_SWIFT_COMPILATION_MODE
            
            configuration.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = $D_SWIFT_OPTIMIZATION_LEVEL
        end
    end
    
    
end


end


#target ‘AppWidgetExtension’ do
#  
#  pod 'AFNetworking/NSURLSession', '~> 4.0'
#  pod 'CCModel'
#  
#end

#target ‘WStockDetail’ do
#  
#  pod 'AFNetworking/NSURLSession', '~> 4.0'
#  pod 'CCModel'
#  
#end

#target ‘WStockListHandel’ do
#  
#  pod 'AFNetworking/NSURLSession', '~> 4.0'
#  pod 'YYModel'
#  
#end
