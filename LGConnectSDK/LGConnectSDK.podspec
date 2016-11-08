Pod::Spec.new do |s|
  s.name         = "LGConnectSDK"
  s.version      = "1.0.1"
  s.summary      = "Connect SDK connects your mobile apps with multiple TV platforms."
  s.homepage     = "https://github.com/Shodogg/LGConnectSDK"
  s.license      = 'BSD'
  s.author       = { "Shodogg" => "info@shodogg.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Shodogg/LGConnectSDK.git",:tag => s.version}
  s.prefix_header_contents = <<-PREFIX

                                  #define CONNECT_SDK_VERSION @"#{s.version}"

                                  // Uncomment this line to enable SDK logging
                                  //#define CONNECT_SDK_ENABLE_LOG

                                  #ifndef kConnectSDKWirelessSSIDChanged
                                  #define kConnectSDKWirelessSSIDChanged @"Connect_SDK_Wireless_SSID_Changed"
                                  #endif

                                  #ifdef CONNECT_SDK_ENABLE_LOG
                                      // credit: http://stackoverflow.com/a/969291/2715
                                      #ifdef DEBUG
                                      #   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
                                      #else
                                      #   define DLog(...)
                                      #endif
                                  #else
                                      #   define DLog(...)
                                  #endif
                               PREFIX
  s.requires_arc = true
  non_arc_files =
    "core/Frameworks/asi-http-request/External/Reachability/*.{h,m}",
    "core/Frameworks/asi-http-request/Classes/*.{h,m}"

  s.subspec 'Core' do |ss|
    ss.source_files  = "ConnectSDKDefaultPlatforms.h", "core/**/*.{h,m}"
    ss.exclude_files = (non_arc_files.dup << "core/ConnectSDK*Tests/**/*")
    ss.private_header_files = "core/**/*_Private.h"
    ss.requires_arc = true
    ss.dependency 'LGConnectSDK/no-arc'
  end

  s.subspec 'no-arc' do |ss|
    ss.source_files = non_arc_files
    ss.requires_arc = false
    # disable all warnings from asi-http-request
    ss.compiler_flags = '-w'
  end

  s.subspec 'google-cast' do |ss|
    cast_dir = "modules/google-cast"
    ss.dependency 'LGConnectSDK/Core'
    ss.source_files = "#{cast_dir}/**/*.{h,m}"
    ss.exclude_files = "#{cast_dir}/*Tests/**/*"
    ss.private_header_files = "#{cast_dir}/**/*_Private.h"
    ss.preserve_paths = "#{cast_dir}/framework/*.framework"
    ss.vendored_frameworks = "#{cast_dir}/framework/GoogleCast.framework"
    ss.framework = "GoogleCast"
    ss.requires_arc = true
  end
  
  s.subspec 'SmartView' do |ss|
    smartsdk_dir = "modules/samsung"
    ss.dependency 'LGConnectSDK/Core'
  	ss.source_files = "#{smartsdk_dir}/**/*.{h,m}"
    ss.requires_arc = true
  	ss.vendored_frameworks = "#{smartsdk_dir}/framework/SmartView.framework"
	  ss.framework = "SmartView"
  end

  s.libraries = "z", "icucore", "c++"
  s.frameworks = 'Accelerate', 'AudioToolbox', 'AVFoundation', 'CoreBluetooth', 'CoreText', 'MediaAccessibility', 'MediaPlayer', 'MediaToolbox', 'SystemConfiguration'
  s.xcconfig = {
      "OTHER_LDFLAGS" => "$(inherited) -ObjC",
  }
end