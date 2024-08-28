import Foundation


// MARK: - Protocols

protocol EditPresenterProtocol: AnyObject {
    func saveToDo(toDoItem: ToDoItem, title: String, description: String)
}


// MARK: - Presenter

class EditPresenter: EditPresenterProtocol {
    
    weak var view: EditViewProtocol?
    var interactor: EditInteractorInput!
    
    init(view: EditViewProtocol, interactor: EditInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    func saveToDo(toDoItem: ToDoItem, title: String, description: String) {
        interactor.updateToDoItem(toDo: toDoItem, title: title, description: description, isCompleted: toDoItem.isCompleted)
    }
}


// MARK: - EditToDoInteractorOutput

extension EditPresenter: EditInteractorOutput {
    func didUpdateToDo() {
        view?.displaySuccess()
    }
    
    func didFailToUpdateToDo(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
}
