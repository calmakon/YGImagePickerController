Pod::Spec.new do |s|
  s.name         = "YGImagePickerController"
  s.version      = "1.0.1"
  s.summary      = "a pick image tool,support picking multiple photos、gif and video"
  s.homepage     = "https://github.com/calmakon/YGImagePickerController"
  s.license      = "MIT"
  s.author             = { "calmakon" => "17611597020@163.com" }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/calmakon/YGImagePickerController.git", :tag => "1.0.1" }
  s.resources    = "YGImagePickerController/YGImagePickerController/images/*.{png}"
  s.source_files = "YGImagePickerController/YGImagePickerController/*.{h,m}"
  s.framework  = "Photos"
  s.requires_arc = true
end