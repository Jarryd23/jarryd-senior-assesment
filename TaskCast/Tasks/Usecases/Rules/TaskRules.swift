import Foundation

protocol Rule {
    func validate(value: [String]) -> Bool
    func errorMessage() -> String
}

protocol TaskValidatable {
    var taskValidationRules: [Rule] { get }
}

struct EmptyTaskRule: Rule {
    func validate(value: [String]) -> Bool {
        for text in value {
            if text.isEmpty {
                return true
            }
        }
        return false
    }
    
    func errorMessage() -> String {
        "Task title cannot be empty"
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
