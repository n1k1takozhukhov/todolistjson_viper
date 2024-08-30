import XCTest
@testable import todolist_json

class MockToDoListView: ToDoListViewProtocol {
    var didShowToDos = false
    var didShowError = false
    
    func showToDos(_ toDos: [ToDoItem]) {
        didShowToDos = true
    }
    
    func showError(_ error: Error) {
        didShowError = true
    }
}

class MockToDoListInteractor: ToDoListInteractorInput {
    var didFetchToDo = false
    var didAddToDoItem = false
    var didUpdateToDoItem = false
    var didDeleteToDoItem = false
    var didToggleComplete = false
    
    func fetchToDo() {
        didFetchToDo = true
    }
    
    func addToDoItem(title: String, description: String, isCompleted: Bool) {
        didAddToDoItem = true
    }
    
    func updateToDoItem(toDo: ToDoItem, title: String, description: String, isCompleted: Bool) {
        didUpdateToDoItem = true
    }
    
    func deleteToDoItem(toDo: ToDoItem) {
        didDeleteToDoItem = true
    }
    
    func toggleComplete(_ toDo: ToDoItem) {
        didToggleComplete = true
    }
}

class MockToDoListRouter: ToDoListRouter {
    var didShowAddToDoViewController = false
    var didShowEditToDoViewController = false
    
    override func AddToDoViewControoler(rootPresenter: ToDoListPresenter) {
        didShowAddToDoViewController = true
    }
    
    override func EditToDoViewControoler(for toDo: ToDoItem, rootPresenter: ToDoListPresenter) {
        didShowEditToDoViewController = true
    }
}
