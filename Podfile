use_frameworks!
inhibit_all_warnings!

def shared 
	pod 'RxSwift', '~> 3.1.0'
	pod 'RxCocoa', '~> 3.1.0'
	pod 'Moya/RxSwift', '~> 8.0.0'
	pod 'Argo', :git => 'https://github.com/thoughtbot/Argo.git', :branch => 'master'
	pod 'Curry', :git => 'https://github.com/thoughtbot/Curry.git', :branch => 'master'
	pod 'Runes', :git => 'https://github.com/thoughtbot/Runes.git', :branch => 'master'
	pod 'BRYXBanner', '~> 0.7.0'
	pod 'Nuke', '~> 4.1.2'
end

target 'Repositories' do
  shared
end

target 'RepositoriesTests' do
  shared

  pod 'Quick'
  pod 'Nimble'
end

post_install do |installer|

    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end

end