import XCTest

import InSwifted

class DependencyContainerTests: XCTestCase {
    
    var serviceUnderTest: DependencyContainer!
    
    override func setUp() async throws {
        try await super.setUp()
        
        serviceUnderTest = DependencyContainer()
    }
    
    func testResolveReturnsRegisteredDependency() throws {
        serviceUnderTest.register(TestProtocol.self, with: TestImplementation.init)
        
        let result = try serviceUnderTest.resolve(TestProtocol.self)
        
        XCTAssert(result is TestImplementation)
    }
    
    func testResolveReturnsSeparateInstancesOfDependency() throws {
        serviceUnderTest.register(TestProtocol.self, with: TestImplementation.init)
        
        let result1 = try serviceUnderTest.resolve(TestProtocol.self)
        let result2 = try serviceUnderTest.resolve(TestProtocol.self)
        
        XCTAssertNotEqual(result1 as? TestImplementation, result2 as? TestImplementation)
    }
    
    func testResolveReturnsSameInstancesOfSingletonDependency() throws {
        serviceUnderTest.register(singleton: TestProtocol.self, with: TestImplementation.init)
        
        let result1 = try serviceUnderTest.resolve(TestProtocol.self)
        let result2 = try serviceUnderTest.resolve(TestProtocol.self)
        
        XCTAssertEqual(result1 as? TestImplementation, result2 as? TestImplementation)
    }
    
    func testResolveReturnsSameInstancesOfSingletonDependenciesWithSameImplementation() throws {
        serviceUnderTest.register(singleton: TestProtocol.self, with: TestImplementation.init)
        serviceUnderTest.register(singleton: TestProtocol2.self, with: TestImplementation.init)
        
        let result1 = try serviceUnderTest.resolve(TestProtocol.self)
        let result2 = try serviceUnderTest.resolve(TestProtocol2.self)
        
        XCTAssertEqual(result1 as? TestImplementation, result2 as? TestImplementation)
    }
    
    func testResolveReturnsSeparateInstancesOfSingletonAndNonSingletonDependencyWithSameImplementation() throws {
        serviceUnderTest.register(singleton: TestProtocol.self, with: TestImplementation.init)
        serviceUnderTest.register(TestProtocol2.self, with: TestImplementation.init)
        
        let result1 = try serviceUnderTest.resolve(TestProtocol.self)
        let result2 = try serviceUnderTest.resolve(TestProtocol2.self)
        
        XCTAssertNotEqual(result1 as? TestImplementation, result2 as? TestImplementation)
    }
    
    func testResolveThrowsErrorWhenDependencyNotRegistered() throws {
        XCTAssertThrowsError(try serviceUnderTest.resolve(TestProtocol.self)) {
            XCTAssertEqual(DependencyError.notRegistered, $0 as? DependencyError)
        }
    }
    
    func testResolveThrowsErrorWhenMultipleImplementationsRegisteredForSameDependency() throws {
        serviceUnderTest.register(TestProtocol2.self, with: TestImplementation.init)
        serviceUnderTest.register(TestProtocol2.self, with: TestImplementation2.init)
        
        XCTAssertThrowsError(try serviceUnderTest.resolve(TestProtocol2.self)) {
            XCTAssertEqual(DependencyError.multipleRegistered, $0 as? DependencyError)
        }
    }
    
    func testResolveThrowsErrorWhenImplementationDoesNotConformToDependency() throws {
        serviceUnderTest.register(TestProtocol.self, with: TestImplementation2.init)
        
        XCTAssertThrowsError(try serviceUnderTest.resolve(TestProtocol.self)) {
            XCTAssertEqual(DependencyError.doesNotConform, $0 as? DependencyError)
        }
    }
    
    func testResolveReturnsInstanceWhenDependencyRegisteredMultipleTimeWithSameImplementation() throws {
        serviceUnderTest.register(TestProtocol.self, with: TestImplementation.init)
        serviceUnderTest.register(TestProtocol.self, with: TestImplementation.init)
        
        XCTAssertNoThrow(try serviceUnderTest.resolve(TestProtocol.self))
    }
    
    func testResolveAllReturnsArrayOfImplementationsForDependency() throws {
        serviceUnderTest.register(TestProtocol2.self, with: TestImplementation.init)
        serviceUnderTest.register(TestProtocol2.self, with: TestImplementation2.init)
        
        let result = try serviceUnderTest.resolveAll(TestProtocol2.self)
        
        XCTAssertEqual(2, result.count)
    }
    
    func testResolveAllReturnsInstanceWhenDependencyRegisteredMultipleTimeWithSameImplementation() throws {
        serviceUnderTest.register(TestProtocol.self, with: TestImplementation.init)
        serviceUnderTest.register(TestProtocol.self, with: TestImplementation.init)
        
        let result = try serviceUnderTest.resolveAll(TestProtocol.self)
        
        XCTAssertEqual(1, result.count)
    }

}

private protocol TestProtocol {}
private protocol TestProtocol2 {}

private struct TestImplementation: TestProtocol,
                                   TestProtocol2,
                                   Equatable {
    var id: String = UUID().uuidString
}

private struct TestImplementation2: TestProtocol2 {}
