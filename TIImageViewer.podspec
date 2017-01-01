Pod::Spec.new do |s|
  s.name         = "TIImageViewer"
  s.version      = "1.0.0"
  s.summary      = "Display images with paging, zoom and pan"
  s.description  = "Used to display an array of images or a single image with controls to zoom and pan"
  s.homepage     = "https://github.com/toddisaacs/TIImageViewer"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author       = "Todd Isaacs"
  s.social_media_url   = "http://twitter.com/toddisaacs"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/toddisaacs/TIImageViewer.git", :tag => "1.0.0"}
  s.source_files  = "TIImageViewer", "TIImageViewer/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
