import Foundation

@propertyWrapper
public struct _Injected<Dependency, Other> {
    
    public var wrappedValue: Dependency
    
    public init() where Other == Never {
        self.wrappedValue = try! InSwifted.resolve(Dependency.self)
    }
    
    public init() where Dependency == Optional<Other> {
        self.wrappedValue = try? InSwifted.resolve(Other.self)
    }
    
    public init() where Dependency == Array<Other> {
        self.wrappedValue = try! InSwifted.resolveAll(Other.self)
    }
    
    public init() where Dependency == Optional<Array<Other>> {
        self.wrappedValue = try? InSwifted.resolveAll(Other.self)
    }
    
}

public typealias Injected<T> = _Injected<T, Never>
public typealias OptionalInjected<T> = _Injected<Optional<T>, T>
public typealias MultiInjected<T> = _Injected<Array<T>, T>
