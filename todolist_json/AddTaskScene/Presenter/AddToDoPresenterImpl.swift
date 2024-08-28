import Foundation


// MARK: - Protocols

protocol AddPresenterProtocol: AnyObject {
    func saveToDo(title: String, description: String)
}


// MARK: - Presenter

class AddTaskPresenter: AddPresenterProtocol {
    
    weak var view: AddViewProtocol?
    var interactor: AddInteractorInput!
    
    init(view: AddViewProtocol, interactor: AddInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    func saveToDo(title: String, description: String) {
        interactor.addToDoItem(title: title, description: description)
    }
}


// MARK: - AddToDoInteractorOutput

extension AddTaskPresenter: AddInteractorOutput {
    func didAddToDo() {
        view?.displaySuccess()
    }
    
    func didFailToAddToDo(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
}

