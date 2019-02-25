Pod::Spec.new do |s|

  s.name         = "GJImgScroll"
  s.version      = "0.0.9"
  s.summary      = "GJImgScroll is Image Scroll Kit."
  s.homepage     = "https://github.com/yigegongjiang/GJImgScroll"
  s.license      = "MIT"
  s.author       = {"一个工匠" => "one.gongjiang@gmail.com"}
  s.source       = { :git => "https://github.com/yigegongjiang/GJImgScroll.git", :tag => s.version }
  s.source_files = "GJImgScrollProject/GJImgScroll/*.{h,m}"
  s.requires_arc = true
  s.dependency   "SDWebImage", "4.0.0"
  s.ios.deployment_target = "8.0"
end
