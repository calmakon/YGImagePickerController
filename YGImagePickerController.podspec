Pod::Spec.new do |s|
  s.name         = "YGImagePickerController"
  s.version      = "1.1.2"
  s.summary      = "a pick image tool,support picking multiple photos、gif and video"
  s.homepage     = "https://github.com/calmakon/YGImagePickerController"
  s.license      = "MIT"
  s.author             = { "calmakon" => "17611597020@163.com" }
  s.platform     = :ios
  s.ios.deployment_target = "11.0"
  s.source       = { :git => "https://github.com/calmakon/YGImagePickerController.git", :tag => s.version }
  s.resources    = "YGImagePickerController/YGImagePickerController/images/*.{png}"
  s.source_files = "YGImagePickerController/YGImagePickerController"
  s.framework  = "Photos"
  s.requires_arc = true
end
