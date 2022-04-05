import Foundation

public protocol DependencyResolver {
    func resolve<Dependency>(_ dependency: Dependency.Type) throws -> Dependency
    func resolveAll<Dependency>(_ dependency: Dependency.Type) throws -> [Dependency]
}
