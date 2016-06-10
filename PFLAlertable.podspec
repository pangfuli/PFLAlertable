Pod::Spec.new do |s|


  s.name         = "PFLAlertable"
  s.version      = "0.0.2"
  s.summary      = "all kinds of alertableProtocol for iOS developer."
  s.description  = <<-DESC
                      this project provide all kinds of alertableProtocol for iOS developer 
                   DESC

  s.homepage     = "https://github.com/pangfuli/PFLAlertable"



  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "haq" => "pflnh2011@gmail.com" }
 

  s.platform     = :ios

  #  When using multiple platforms
  s.ios.deployment_target = "8.0"
 

  s.source       = { :git => "https://github.com/pangfuli/PFLAlertable.git", :tag => "0.0.2" }


  s.source_files  = "PFLAlertable", "PFLAlertable/*.{swift}"
  s.exclude_files = "PFLAlertable/Exclude"

  s.ios.frameworks = "UIKit", "Foundation", "AudioToolbox"

  s.requires_arc = true

  s.dependency 'IQKeyboardManagerSwift'

end
