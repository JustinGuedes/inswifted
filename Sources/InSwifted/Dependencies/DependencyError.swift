import Foundation

public enum DependencyError: Error {
    case notRegistered
    case multipleRegistered
    case doesNotConform
}
