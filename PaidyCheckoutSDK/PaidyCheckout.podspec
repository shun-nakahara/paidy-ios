Pod::Spec.new do |s|
  s.name         = 'PaidyCheckout'
  s.version      = '1.0.0'
  s.summary      = 'The Paidy iOS SDK makes it easy to accept payment using email address and phone number without the need of a credit card.'
  s.description  = 'Paidy SDK is a Swift framework compatible with iOS apps iOS 8 and above. It is recommended to use the latest Xcode 6.4 version for compiling.'
  s.homepage     = "https://paidy.com/"
  s.license      = "MIT"
  s.author             = { "Paidy" => "support@paidy.com" }
  s.platform     = :ios,"8.0"
  s.source       = { :git => "https://github.com/paidy/paidy-ios.git", :tag => "v#{s.version}" }
  s.source_files  = 'PaidyCheckoutSDK/PaidyCheckoutSDK/*'
  s.dependency 'Alamofire', '1.3.1'
  s.dependency 'ObjectMapper','0.12'
end
