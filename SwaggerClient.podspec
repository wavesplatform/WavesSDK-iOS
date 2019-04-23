Pod::Spec.new do |s|
  s.name = 'SwaggerClient'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.homepage     = 'https://wavesplatform.com'
  s.authors      = { 'Mefilt' => 'Mefilt@gmail.com' }
  s.summary      = 'The library contains method, variable and other entities for development on crypto'  
  s.version = '0.0.1'
  s.source = { :source => ''}
  s.authors = 'Swagger Codegen'
  s.license = 'Proprietary'
  s.source_files = 'WavesSDKSource/SwaggerClient/Classes/**/*.swift'
  s.dependency 'Alamofire'
end
