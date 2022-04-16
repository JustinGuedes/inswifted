import Foundation

class SingletonDependencyFactory<Implementation>: DependencyFactory {

    var instance: Implementation?
    var instanceFactory: InstanceDependencyFactory<Implementation>

    init(_ creation: @escaping (DependencyResolver) -> Implementation) {
        self.instanceFactory = InstanceDependencyFactory(creation)
    }
    
    var isSingleton: Bool {
        return true
    }
    
    var implementation: String {
        return String(describing: Implementation.self)
    }

    func create<Dependency>(using resolver: DependencyResolver) throws -> Dependency {
        instance = try instance ?? instanceFactory.create(using: resolver)
        guard let instance = instance as? Dependency else {
            throw DependencyError.doesNotConform
        }
        
        return instance
    }

}
