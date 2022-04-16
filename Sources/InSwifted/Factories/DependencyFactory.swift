import Foundation

protocol DependencyFactory: AnyObject {
    var isSingleton: Bool { get }
    var implementation: String { get }
    
    func create<Dependency>(using resolver: DependencyResolver) throws  -> Dependency
}
