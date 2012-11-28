Pod::Spec.new do |s|
  s.name          = 'WTGlyphFontSet'
  s.version       = '0.0.1'
  s.license       = 'proprietary'
  s.summary       = 'draw or create image using glyph webfont.'
  s.homepage      = 'http://www.waterworld.com.hk'
  s.author        = { 'waterlou' => 'https://github.com/waterlou' }

  s.platform      = :ios, '5.0'
  s.requires_arc  = true
  s.source        = { :git => 'ssh://git.waterworld.com.hk/WTGlyphFontSet', :tag => '0.0.1' }
  s.frameworks    = 'UIKit', 'CoreText'
  s.source_files  = 'WTGlyphFontSet/**/*.{h,m}'

  s.subspec 'fontawesome' do |fontawesome|
    fontawesome.resource = 'fontawesome/**/*.{ttf,otf,plist}'
  end

end
