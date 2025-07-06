import Foundation

protocol Rule {
    func validate(value: [String]) -> Bool
    func errorMessage() -> String
}

protocol TaskValidatable {
    var taskValidationRules: [Rule] { get }
}

struct EmptyNameRule: Rule {
    func validate(value: [String]) -> Bool {
        value.first?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }

    func errorMessage() -> String {
        "Task name cannot be empty"
    }
}

struct InvalidCharacterLengthRule: Rule {
    func validate(value: [String]) -> Bool {
        for val in value {
            if val.trimmingCharacters(in: .whitespacesAndNewlines).count > 30 {
                return true
            }
        }
        return false
    }

    func errorMessage() -> String {
        "Please choose a shorter title"
    }
}
