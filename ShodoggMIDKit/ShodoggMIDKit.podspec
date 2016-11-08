Pod::Spec.new do |s|
  s.name             = "ShodoggMIDKit"
  s.version          = "1.2.1"
  s.summary          = "Shodogg MediaID library for iOS."
  s.homepage         = "https://github.com/shodogg/ShodoggMIDKit"
  s.license          = 'BSD'
  s.author           = { "Shodogg" => "info@shodogg.com" }
  s.source           = { :git => "https://github.com/shodogg/ShodoggMIDKit.git", :tag => s.version.to_s }
  s.platform     	 = :ios, '7.0'
  s.requires_arc 	 = true
  s.prefix_header_file  = 'ShodoggMIDKit-prefix.pch'
  
  non_arc_files    = "Classes/SHMIDKeychain.{h,m}"
  ui_support_files = "Classes/UISupport/**/*.{h,m}"
  
  s.subspec 'Core' do |core|
	core.source_files   = 'Classes/**/*.{h,m}'
	core.exclude_files  = ui_support_files, non_arc_files
	core.resources 	  = 'Classes/DataRecorder/Model/*.{xcdatamodeld,xcdatamodel}'
  	core.preserve_paths = 'Classes/DataRecorder/Model/*'
	core.dependency 'ShodoggMIDKit/NoARC'
  end
  
  s.subspec 'NoARC' do |noarc|
    noarc.source_files = non_arc_files
    noarc.requires_arc = false
  end
      
  s.subspec 'UISupport' do |uisupport|
    uisupport.source_files = ui_support_files
    uisupport.dependency 'ShodoggMIDKit/Core'
    uisupport.dependency 'LNPopupController'
    uisupport.dependency 'pop'
    uisupport.dependency 'MBProgressHUD', '~> 1.0.0'
    uisupport.dependency 'SDWebImage', '~> 3.7.3'
  end
  
  s.subspec 'Discovery' do |ss|
  	ss.source_files = 'Discovery/**/*.{h,m}'
  	ss.dependency 'ShodoggMIDKit/Core'
  	ss.dependency 'LGConnectSDK'
  end

  s.subspec 'Data' do |ss|
  	ss.subspec 'DataTracking' do |dt|
  	  dt.source_files = 'Data/DataTracking/**/*.{h,m}'
    end
    ss.subspec 'DeviceGraph' do |dg|
      dg.source_files = 'Data/DeviceGraph/**/*.{h,m,c}'
    end
  end

  s.resource_bundles = {
    'ShodoggMIDKit' => ['Assets/Images/**/*.png','Classes/UISupport/MIDUIComponents.storyboard']
  }
  
  s.dependency 'ShodoggAPIKit'
  s.dependency 'Mantle'
  s.dependency 'Realm'
  s.dependency 'MagicalRecord'
  s.dependency 'MagicalRecord/ShorthandMethodAliases'
end