# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

def shared
	pod 'RxSwift',    '~> 4.0'
end

def rxTestShared
	pod 'RxBlocking', '~> 4.0'
	pod 'RxTest',     '~> 4.0'
end

target 'CryptoCurrency' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for CryptoCurrency

#  target 'CryptoCurrencyTests' do
#    inherit! :search_paths
#    # Pods for testing
#  end
#
#  target 'CryptoCurrencyUITests' do
#    inherit! :search_paths
#    # Pods for testing
#  end

end

target 'CryptoCurrencyCore' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CryptoCurrencyCore
  shared
  
  # Rx Utils
  pod 'RxCocoa',    '~> 4.0'
  pod 'RxDataSources', '~> 3.0'
  pod 'Action'
  pod 'NSObject+Rx'
  pod 'RxGesture'
  pod 'RxAnimated'

  # Image Cache
  pod 'Kingfisher', '~> 4.0'
  
  # Charts and colors
  pod 'Charts'
  pod 'ChameleonFramework'
  
#  target 'CryptoCurrencyCoreTests' do
#    inherit! :search_paths
#    # Pods for testing
#  end

end

target 'CryptoCurrenciesWebservice' do
	# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
	use_frameworks!
	
	shared
	pod 'RxAlamofire'
	pod 'Reachability'
	
	target 'CryptoCurrenciesWebserviceTests' do
		inherit! :search_paths
		# Pods for testing
		rxTestShared
	end
end

post_install do |installer|
	
	installer.pods_project.build_configurations.each do |config|
		config.build_settings.delete('CODE_SIGNING_ALLOWED')
		config.build_settings.delete('CODE_SIGNING_REQUIRED')
	end
	
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
		end
	end
end
