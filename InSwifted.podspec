Pod::Spec.new do |spec|
  spec.name         = "InSwifted"
  spec.version      = "0.1.0"
  spec.summary      = "Simple dependency injection for swift."
  spec.description  = <<-DESC
Framework that enables the application to register and inject dependencies. InSwifted is designed to safely resolve dependencies as well as have a traditional dependency injection use.
                   DESC

  spec.homepage     = "https://github.com/JustinGuedes/inswifted"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Justin Guedes" => "justin.guedes@gmail.com" }

  spec.swift_version = "5.5"
  spec.ios.deployment_target = "12.0"
  spec.osx.deployment_target = "10.9"

  spec.source       = { :git => "https://github.com/JustinGuedes/inswifted.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/InSwifted", "Sources/InSwifted/**/*.{swift}", "Sources/InSwifted/**/**/*.{swift}"
end
