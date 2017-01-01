Pod::Spec.new do |s|
  s.name         = "TIImageViewer"
  s.version      = "1.0.0"
  s.summary      = "Display images with paging, zoom and pan"
  s.description  = "Display images with paging, zoom and pan"
  s.homepage     = "https://github.com/toddisaacs/TIIMageViewer"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author       = "Todd Isaacs"
  s.social_media_url   = "http://twitter.com/toddisaacs"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/toddisaacs/TICircleProgress.git", :tag => "1.0.0"}
  s.source_files  = "TIImageViewer", "TIImageViewer/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
