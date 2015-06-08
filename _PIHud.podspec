Pod::Spec.new do |s|

  s.name         = "PIHud"
  s.version      = "0.1.3"
  s.summary      = "HUD / Toast for iOS (swift)"
  s.homepage     = "https://github.com/pixel-ink/PIHud"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "pixelink" => "https://github.com/pixel-ink" }
  s.social_media_url   = "http://twitter.com/pixelink_jp"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/pixel-ink/PIhud.git", :tag => s.version }
  s.source_files  = "**/src/PIHud*.swift"

end