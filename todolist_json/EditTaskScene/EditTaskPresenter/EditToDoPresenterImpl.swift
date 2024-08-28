import Foundation


// MARK: - Protocols

protocol EditToDoPresenter: AnyObject {
    func saveToDo(toDoItem: ToDoItem, title: String, description: String)
}


// MARK: - Presenter

class EditToDoPresenterImpl: EditToDoPresenter {
    
    weak var view: EditToDoView?
    var interactor: EditToDoInteractorInput!
    
    init(view: EditToDoView, interactor: EditToDoInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    func saveToDo(toDoItem: ToDoItem, title: String, description: String) {
        interactor.updateToDoItem(toDo: toDoItem, title: title, description: description, isCompleted: toDoItem.isCompleted)
    }
}


// MARK: - EditToDoInteractorOutput

extension EditToDoPresenterImpl: EditToDoInteractorOutput {
    func didUpdateToDo() {
        view?.displaySuccess()
    }
    
    func didFailToUpdateToDo(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
}
