# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  # Project name, as a String. The default value is the name passed to motion create.
  app.name = "Motion 1"
  # Project version, as a String. The default value is "1.0".
  app.version = '1.1.0'
  # Project short version, as a String. This value must be unique for each version released to the App Store. The default value is "1".
  app.short_version = '1.1'
  # Project identifier, as a String, in reverse DNS format. The default value is the concatenation of "com.yourcompany." and the name variable.
  app.identifier = "com.codefriar.Motion1"
  # The names of iOS or OS X frameworks to link against, as an Array. It should contain the names of public frameworks, typically present in /System/Library/Frameworks. The build system is capable of dealing with dependencies, for instance there is no need to mention "CoreFoundation" if you have "Foundation". The default value for iOS projects is [UIKit, Foundation, CoreGraphics], and for OS X projects, [AppKit, Foundation, CoreGraphics].
  app.frameworks += %w{WebKit}
  # Library paths to link against, as an Array. It should contain paths to public, system libraries, for example "/usr/lib/libz.dylib". The default value is [], an empty array.
  # app.libs
  # Version number of the SDK to target, as a String. The default value is the value of sdk_version, but can be lowered to target older versions of iOS or OS X. Example: "4.3".
  app.deployment_target = '10.7'
  # The name of the certificate to use for codesigning, as a String. The default value is the first iPhone or Mac Developer certificate found in keychain. Example: "iPhone Developer: Darth Vader (A3LKZY369Q)".
  # app.codesign_certificate
  # The name of the icon resource file to use as the application icon, as a String. For example, "Icon.png". The default value is '', an empty string.
  app.icon = 'motion1.icns'
  # Whether it codesigns the application for development build. If false, it skips codesigning. The default value is false.
  app.codesign_for_development = false
  # Whether it codesigns the application for release build. If false, it skips codesigning. The default value is true.
  app.codesign_for_release = false
end
