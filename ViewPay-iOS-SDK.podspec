Pod::Spec.new do |s|
  s.name         = "ViewPay-iOS-SDK"
  s.version      = "1.7.0"
  s.summary      = "SDK ViewPay pour iOS."
  s.description  = <<-DESC
                  Le SDK ViewPay vous permet de proposer à vos utilisateur de visionner des publicités comme alternative au payement pour accéder à un contenu.
                   DESC
  s.homepage     = "https://github.com/TechViewpay/ViewPay-iOS/"
  s.license      = "Private"
  s.authors      = { "Thibaut LE LEVIER" => "thibaut@lelevier.fr", "Philippe ROCTON" => "philippe@viewpay.tv" ,"RALAIVAO Eugène" => "ratifekely@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/TechViewpay/ViewPay-iOS.git", :tag => "v1.7.0" }
  s.vendored_frameworks = "Dist/ViewPay.xcframework"
  s.requires_arc = true
  s.dependency "GoogleAds-IMA-iOS-SDK"
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
