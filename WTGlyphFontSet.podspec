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
  s.subspec 'iconic_fill' do |iconic_fill|
    iconic_fill.resource = 'iconic_fill/**/iconic_fill.{ttf,otf,plist}'
  end
  s.subspec 'iconic_stroke' do |iconic_stroke|
    iconic_stroke.resource = 'iconic_stroke/**/iconic_stroke.{ttf,otf,plist}'
  end
  s.subspec 'entypo' do |entypo|
    entypo.resource = 'entypo/**/entypo.{ttf,otf,plist}'
  end
  s.subspec 'entypo-social' do |entypo_social|
    entypo_social.resource = 'entypo-social/**/entypo-social.{ttf,otf,plist}'
  end
  s.subspec 'general_foundicons' do |general_foundicons|
    general_foundicons.resource = 'general_foundicons/**/general_foundicons.{ttf,otf,plist}'
  end
  s.subspec 'general_enclosed_foundicons' do |general_enclosed_foundicons|
    general_enclosed_foundicons.resource = 'general_enclosed_foundicons/**/general_enclosed_foundicons.{ttf,otf,plist}'
  end
  s.subspec 'social_foundicons' do |social_foundicons|
    social_foundicons.resource = 'social_foundicons/**/social_foundicons.{ttf,otf,plist}'
  end
  s.subspec 'accessibility_foundicons' do |accessibility_foundicons|
    accessibility_foundicons.resource = 'accessibility_foundicons/**/accessibility_foundicons.{ttf,otf,plist}'
  end
  s.subspec 'heydings_icons' do |heydings_icons|
    heydings_icons.resource = 'heydings_icons/**/*.{ttf,otf,plist}'
  end
  s.subspec 'modernpics' do |modernpics|
    modernpics.resource = 'modernpics/**/*.{ttf,otf,plist}'
  end

end
