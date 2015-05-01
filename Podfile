# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!


def import_pods
	pod 'Alamofire', '~> 1.2'
	pod 'SwiftTask', '~> 3.0'
	pod 'Async', :git => 'https://github.com/duemunk/Async.git'
	pod 'Realm', '~> 0.91'

	pod 'FBSDKCoreKit', '~> 4.1'
	pod 'FBSDKShareKit', '~> 4.1'
	pod 'FBSDKLoginKit', '~> 4.1'

    pod 'SwiftyJSON', '~> 2.2'
    pod 'Bond', '~> 3.7'

    # UI
    pod 'SCLAlertView', '~> 0.3'
    pod "SwiftSpinner", :git => 'https://github.com/joseph-montanez/SwiftSpinner.git', :branch => 'master' # Can use with SCLAlertView without a complete handler - so using master
end

target 'Starter App' do
	# Fixes the PodSpec issue
	# Dollar breaks in Swift 1.2, removed until the fixes are merged back to the master branch
	# pod 'Dollar', :git => 'https://github.com/ankurp/Dollar.swift.git', :branch => 'xcode-6.3-beta-swift-1.2', :commit => 'da2549defb'
	pod 'TPKeyboardAvoiding', '~> 1.2'
	pod 'IQKeyboardManager'
	import_pods
end

target 'Starter AppTests' do
    pod 'Quick', '~> 0.3'
    pod 'Nimble', '~> 0.4'
	pod 'Mockingjay', '~> 0.2'
	import_pods
end
