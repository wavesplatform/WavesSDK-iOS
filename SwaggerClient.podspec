Pod::Spec.new do |s|
  s.name = 'SwaggerClient'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.version = '0.0.1'
  s.source = { :git => 'git@github.com:swagger-api/swagger-mustache.git', :tag => 'v1.0.0' }
  s.authors = 'Swagger Codegen'
  s.license = 'Proprietary'
  s.source_files = 'WavesSDKSource/SwaggerClient/Classes/Swaggers/**/*.swift'
  s.license      = { :type => 'MIT' }
  s.summary      = 'The library contains method, variable and other entities for development on crypto'  
  s.homepage     = 'https://wavesplatform.com'  
  s.dependency 'Alamofire', '~> 4.8.2'
  s.dependency 'Result', '~> 4.1.0'
  s.swift_version = '4.2'
end
