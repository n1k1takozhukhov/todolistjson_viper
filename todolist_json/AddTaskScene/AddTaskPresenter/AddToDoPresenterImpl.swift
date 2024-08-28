import Foundation


// MARK: - Protocols

protocol AddToDoPresenter: AnyObject {
    func saveToDo(title: String, description: String)
}


// MARK: - Presenter

class AddToDoPresenterImpl: AddToDoPresenter {
    
    weak var view: AddToDoView?
    var interactor: AddToDoInteractorInput!
    
    init(view: AddToDoView, interactor: AddToDoInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
    
    func saveToDo(title: String, description: String) {
        interactor.addToDoItem(title: title, description: description)
    }
}


// MARK: - AddToDoInteractorOutput

extension AddToDoPresenterImpl: AddToDoInteractorOutput {
    func didAddToDo() {
        view?.displaySuccess()
    }
    
    func didFailToAddToDo(with error: Error) {
        view?.displayError(error.localizedDescription)
    }
}

