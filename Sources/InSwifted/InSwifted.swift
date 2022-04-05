import Foundation

public struct InSwifted {
    
    private static var instance: DependencyResolver = DependencyContainer()
    
    public static func resolve<Dependency>(_ dependency: Dependency.Type) throws -> Dependency {
        return try instance.resolve(dependency)
    }
    
    public static func resolveAll<Dependency>(_ dependency: Dependency.Type) throws -> [Dependency] {
        return try instance.resolveAll(dependency)
    }
    
    public static func set(resolver: DependencyResolver) {
        self.instance = resolver
    }
    
    public static func reset() {
        self.instance = DependencyContainer()
    }
    
}
