Pod::Spec.new do |s|
  s.name             = 'TimecodeKit'
  s.version          = '2.0.10'
  s.summary          = 'The definitive SMPTE timecode library for Swift.'
  s.homepage         = 'https://github.com/orchetect/TimecodeKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Steffan Andrews' => 'https://github.com/orchetect' }
  s.source           = { :git => 'https://github.com/orchetect/TimecodeKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '12.0'
  s.watchos.deployment_target = '5.0'
  s.swift_version = '5.5'
  s.static_framework = true

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'Sources/TimecodeKit/**/*'
  end

  # s.subspec 'UI' do |ui|
  #   ui.source_files = 'Sources/TimecodeKitUI/**/*'
  #   ui.dependency 'TimecodeKit/Core'
  #   ui.weak_framework = 'SwiftUI'
  # end
end
