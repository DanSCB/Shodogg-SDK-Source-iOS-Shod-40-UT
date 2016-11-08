Pod::Spec.new do |s|
  s.name         = "LNPopupController"
  s.version      = "0.0.4"
  s.summary      = "Popup controller such as the one in Apple Music."
  s.homepage     = "https://github.com/LeoNatan/LNPopupController"
  s.license      = "MIT"
  s.author       = { "LN" => "" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/LeoNatan/LNPopupController.git", :tag => s.version.to_s }
  s.source_files = 'Classes/**/*.{h,m}'
  s.requires_arc = true
end