Pod::Spec.new do |spec|
    spec.name     = 'RANC'
    spec.version  = '1.0.0'
    spec.license  = 'MIT'
    spec.summary  = 'navigation controller'
    spec.homepage = 'https://github.com/retriable/RANavigationController'
    spec.author   = { 'retriable' => 'retriable@retriable.com' }
    spec.source   = { :git => 'https://github.com/retriable/RANavigationController.git',:tag => "#{spec.version}" }
    spec.description = 'navigation controller.'
    spec.requires_arc = true
    spec.source_files = 'RANC/*.{h,m}'
    spec.ios.framework = 'UIKit'
    spec.ios.deployment_target = '8.0'
end
