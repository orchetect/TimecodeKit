Pod::Spec.new do |s|
  s.name             = 'TimecodeKit'
  s.version          = '2.0.4'
  s.summary          = 'A robust and precise Swift Library for working with SMPTE timecode.'
  s.homepage         = 'https://github.com/orchetect/TimecodeKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'orchetect' => 'https://github.com/orchetect' }
  s.source           = { :git => 'https://github.com/orchetect/TimecodeKit', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
  s.swift_version = '5.5'
  s.static_framework = true

  s.subspec 'Core' do |subspec|
    subspec.source_files = 'Sources/TimecodeKit/**/*'
    subspec.ios.deployment_target = '12.0'
  end

  s.subspec 'TimecodeKitUI' do |ui|
    ui.source_files = 'Sources/TimecodeKitUI/**/*'
    ui.dependency 'Core'
    ui.weak_framework = 'SwiftUI'
    ui.ios.deployment_target = '12.0'
  end

end