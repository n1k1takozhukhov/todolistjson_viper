import XCTest
@testable import todolist_json

class MockAddView: AddViewProtocol {
    var successCalled = false
    var errorCalled = false
    var errorMessage: String?
    
    func displaySuccess() {
        successCalled = true
    }
    
    func displayError(_ message: String) {
        errorCalled = true
        errorMessage = message
    }
}

class MockAddInteractor: AddInteractorInput {
    weak var output: AddInteractorOutput?
    
    var addToDoItemCalled = false
    var title: String?
    var createdDate: Date?
    var description: String?
    
    
    func addToDoItem(title: String, createdDate: Date, description: String) {
        addToDoItemCalled = true
        self.title = title
        self.createdDate = createdDate
        self.description = description
        
        output?.didAddToDo()
    }
}
