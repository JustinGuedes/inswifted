import Foundation

public class DependencyContainer {
    
    private var dependencies: [String: [DependencyFactory]]
    
    public init() {
        self.dependencies = [:]
    }
    
}

extension DependencyContainer: DependencyResolver {
    
    public func resolve<Dependency>(_ dependency: Dependency.Type) throws -> Dependency {
        let dependencies = _resolveAll(dependency)
        guard !dependencies.isEmpty else {
            throw DependencyError.notRegistered
        }
        
        guard let dependency = dependencies.first, dependencies.count == 1 else {
            throw DependencyError.multipleRegistered
        }
        
        return try dependency.create(using: self)
    }
    
    public func resolveAll<Dependency>(_ dependency: Dependency.Type) throws -> [Dependency] {
        return try _resolveAll(dependency).map { factory in
            try factory.create(using: self)
        }
    }
    
}

extension DependencyContainer: DependencyRegisterer {
    
    public func register<Dependency, Implementation>(_ dependency: Dependency.Type,
                                                     with implementation: @escaping (DependencyResolver) -> Implementation) {
        let factory = InstanceDependencyFactory(implementation)
        _register(dependency, with: factory)
    }
    
    public func register<Dependency, Implementation>(singleton dependency: Dependency.Type,
                                                     with implementation: @escaping (DependencyResolver) -> Implementation) {
        let factory = getSingletonFactory(from: Implementation.self) ?? SingletonDependencyFactory(implementation)
        _register(dependency, with: factory)
    }
    
}

private extension DependencyContainer {
    
    func getKey<Dependency>(from dependency: Dependency.Type) -> String {
        return String(describing: Dependency.self)
    }
    
    func getSingletonFactory<Dependency>(from dependency: Dependency.Type) -> DependencyFactory? {
        let key = getKey(from: dependency)
        return dependencies
            .values
            .flatMap { $0 }
            .filter { $0.isSingleton }
            .first { $0.implementation == key }
    }
    
    func _resolveAll<Dependency>(_ dependency: Dependency.Type) -> [DependencyFactory] {
        let key = getKey(from: dependency)
        guard let dependencies = self.dependencies[key] else {
            return []
        }
        
        return dependencies
    }
    
    func _register<Dependency>(_ dependency: Dependency.Type,
                               with factory: DependencyFactory) {
        let key = getKey(from: dependency)
        let array = dependencies[key] ?? []
        let newArray = array + [factory]
        dependencies[key] = newArray.unique
    }
    
}

extension Array where Element == DependencyFactory {
    
    var unique: [DependencyFactory] {
        var uniqueValues: [DependencyFactory] = []
        forEach { item in
            guard !uniqueValues.contains(where: { $0.implementation == item.implementation }) else {
                return
            }
            
            uniqueValues.append(item)
        }

        return uniqueValues
    }

}
