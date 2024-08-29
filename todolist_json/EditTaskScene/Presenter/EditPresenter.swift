import Foundation

protocol EditPresenterProtocol: AnyObject {
    func saveToDo(toDoItem: ToDoItem, title: String, createdDate: Date, description: String)
}

final class EditPresenter: EditPresenterProtocol {
    
    weak var view: EditViewProtocol?
    var interactor: EditInteractorInput!
    
    init(view: EditViewProtocol, interactor: EditInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    func saveToDo(toDoItem: ToDoItem, title: String, createdDate: Date, description: String) {
        interactor.updateToDoItem(
            toDo: toDoItem, 
            title: title,
            createdDate: createdDate,
            description: description,
            isCompleted: toDoItem.isCompleted)
    }
}

extension EditPresenter: EditInteractorOutput {
    func didUpdateToDo() {
        view?.displaySuccess()
    }
    
    func didFailToUpdateToDo(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
}
