import XCTest

import InSwifted

class InjectedTests: XCTestCase {
    
    var container: DependencyContainer!
    
    override func setUp() async throws {
        try await super.setUp()
        container = DependencyContainer()
        InSwifted.set(resolver: container)
    }
    
    override func tearDown() async throws {
        InSwifted.reset()
        try await super.tearDown()
    }
    
    func testInjectedResolvesProperty() throws {
        container.register(TestProtocol.self, with: TestImplementation.init)

        let result = Example()

        XCTAssert(result.test is TestImplementation)
    }
    
    func testOptionalInjectedResolvesProperty() throws {
        container.register(TestProtocol.self, with: TestImplementation.init)
        
        let result = OptionalExample()
        
        XCTAssertNotNil(result.test)
    }
    
    func testOptionalInjectedResolvesNilWhenDependencyIsNotRegistered() throws {
        let result = OptionalExample()
        
        XCTAssertNil(result.test)
    }
    
    func testMultiInjectedResolvesProperty() throws {
        container.register(TestProtocol.self, with: TestImplementation.init)
        container.register(TestProtocol.self, with: TestImplementation2.init)
        
        let result = ArrayExample()
        
        XCTAssertEqual(2, result.test.count)
    }
    
    func testMultiInjectedResolvesEmptyArrayWhenNoDependencyIsRegistered() throws {
        let result = ArrayExample()
        
        XCTAssert(result.test.isEmpty)
    }
    
}

private protocol TestProtocol {}
private struct TestImplementation: TestProtocol {}
private struct TestImplementation2: TestProtocol {}

private struct Example {
    
    @Injected
    var test: TestProtocol

}

private struct OptionalExample {
    
    @OptionalInjected
    var test: TestProtocol?
    
}

private struct ArrayExample {
    
    @MultiInjected
    var test: [TestProtocol]
    
}
