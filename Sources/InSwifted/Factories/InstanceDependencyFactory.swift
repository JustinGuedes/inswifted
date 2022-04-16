import Foundation

class InstanceDependencyFactory<Implementation>: DependencyFactory {
    
    var creation: (DependencyResolver) -> Implementation
    
    init(_ creation: @escaping (DependencyResolver) -> Implementation) {
        self.creation = creation
    }
    
    var isSingleton: Bool {
        return false
    }
    
    var implementation: String {
        return String(describing: Implementation.self)
    }
    
    func create<Dependency>(using resolver: DependencyResolver) throws -> Dependency {
        guard let instance = creation(resolver) as? Dependency else {
            throw DependencyError.doesNotConform
        }
        
        return instance
    }
    
}
