import Foundation


protocol AddPresenterProtocol: AnyObject {
    func saveToDo(title: String, description: String, createdDate: Date)
}

final class AddTaskPresenter: AddPresenterProtocol {
    
    weak var view: AddViewProtocol?
    var interactor: AddInteractorInput!
    
    init(view: AddViewProtocol, interactor: AddInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    func saveToDo(title: String, description: String, createdDate: Date) {
        interactor.addToDoItem(title: title, description: description, createdDate: createdDate)
    }
}

extension AddTaskPresenter: AddInteractorOutput {
    func didAddToDo() {
        view?.displaySuccess()
    }
    
    func didFailToAddToDo(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
}

