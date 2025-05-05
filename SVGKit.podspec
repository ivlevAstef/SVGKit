Pod::Spec.new do |s|
  s.name = 'SVGKit'
  s.version = '1.0.0'
  s.homepage = 'https://github.com/ivlevAstef/SVGKit'
  s.authors = 'Simon Whitty and Tensor'
  s.summary = 'SVGKit - library for show svg into UIImage'
  s.license = { :type => 'zlib', :file => 'LICENSE.txt' }
  s.description = <<-DESC
  					SVGKit - library for show svg into UIImage
            DESC
  s.source = { :git => 'https://github.com/ivlevAstef/SVGKit', :tag => "v#{s.version}" }
  s.platform = :ios, '15.0'

  s.ios.source_files = 'NativeSVG.swift', 'UIImage+SVG.swift', 'SwiftDraw/**/*.swift'
  
end
