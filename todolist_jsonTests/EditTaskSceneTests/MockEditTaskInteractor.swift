import XCTest
@testable import todolist_json

class MockEditView: EditViewProtocol {
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

class MockEditInteractor: EditInteractorInput {
    weak var output: EditInteractorOutput?
    
    var updateToDoItemCalled = false
    var title: String?
    var createdDate: Date?
    var description: String?
    var isCompleted: Bool = false
    
    func updateToDoItem(toDo: ToDoItem, title: String, createdDate: Date, description: String, isCompleted: Bool) {
        updateToDoItemCalled = true
        self.title = title
        self.createdDate = createdDate
        self.description = description
        self.isCompleted = isCompleted
        
        output?.didUpdateToDo()
    }
}
