# InSwifted
Framework that enables the application to register and inject dependencies. InSwifted is designed to safely resolve dependencies as well as have a traditional dependency injection use.

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding InSwifted as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/JustinGuedes/inswifted.git", .upToNextMajor(from: "0.1.0"))
]
```

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate InSwifted into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'InSwifted', '~> 0.1'
```

## Usage

First thing to do is create a `DependencyContainer` to contain all the dependencies for the application, with the container you can start to register dependencies in the container, like so:

```swift
let container = DependencyContainer()

container.register(Protocol.self) { resolver in
  Implementation()
}
```

Once you have your container you can set the resolver for `InSwifted` using the `set(resolver:)` method:

```swift
InSwifted.set(resolver: container)
```

With the `InSwifted` resolver set you can then start resolving dependencies throughout the application using a convenient property wrapper:

```swift
struct Example {

  @Injected
  var dependency: Protocol

}
```

And thats it! You're all set!

## More Changes Coming Soon

## License

InSwifted is released under the MIT license. [See LICENSE](https://github.com/JustinGuedes/inswifted/blob/main/LICENSE) for details.

