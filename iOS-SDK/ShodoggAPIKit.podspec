Pod::Spec.new do |s|
  s.name             = "ShodoggAPIKit"
  s.version          = "2.0.4"
  s.summary          = "Objective-C wrapper for Shodogg UBE REST API."
  s.homepage         = "https://github.com/shodogg/iOS-SDK"
  s.license          = 'BSD'
  s.author           = { "Shodogg" => "info@shodogg.com" }
  s.source           = { :git => "https://github.com/shodogg/iOS-SDK.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/shodogg'
  s.platform     	 = :ios, '7.0'
  s.requires_arc 	 = true
  
  s.prefix_header_file = 'ShodoggAPIKit-Prefix.pch'
  s.subspec 'Core' do |ss|
  ss.source_files = 'Classes/**/*.{h,m}'
  ss.private_header_files = 'Classes/SHUbeAPIClient_Private.h'
  ss.dependency 'ShodoggAPIKit/GCJSONKit'
  ss.dependency 'ShodoggAPIKit/RequestUtils'
  end
  
  s.subspec 'GCJSONKit' do |ss|
    ss.source_files = 'GCJSONKit/*.{h,m}'
    ss.requires_arc = false
  end
  
  s.subspec 'RequestUtils' do |ss|
    ss.source_files = 'RequestUtils/*.{h,m}'
  end

  s.dependency 'AFNetworking', '~> 2.5.4'
  s.dependency 'UIDevice-Hardware', '~> 0.1.5'
  s.dependency 'Reachability', '~> 3.2'
  
  #s.xcconfig = { "ENABLE_BITCODE" => "NO"}
end	