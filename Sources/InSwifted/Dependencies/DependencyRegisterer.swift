import Foundation

public protocol DependencyRegisterer {
    func register<Dependency, Implementation>(_ dependency: Dependency.Type,
                                              with implementation: @escaping (DependencyResolver) -> Implementation)
    func register<Dependency, Implementation>(singleton dependency: Dependency.Type,
                                              with implementation: @escaping (DependencyResolver) -> Implementation)
}

public extension DependencyRegisterer {
    
    func register<Dependency, Implementation>(_ dependency: Dependency.Type,
                                              with implementation: @escaping () -> Implementation) {
        register(dependency) { _ in
            implementation()
        }
    }
    
    func register<Dependency, Implementation>(_ dependency: Dependency.Type,
                                              with implementation: Implementation) {
        register(dependency) {
            implementation
        }
    }
    
    func register<Dependency, Implementation>(singleton dependency: Dependency.Type,
                                              with implementation: @escaping () -> Implementation) {
        register(singleton: dependency) { _ in
            implementation()
        }
    }
    
    func register<Dependency, Implementation>(singleton dependency: Dependency.Type,
                                              with implementation: Implementation) {
        register(singleton: dependency) {
            implementation
        }
    }
    
}
