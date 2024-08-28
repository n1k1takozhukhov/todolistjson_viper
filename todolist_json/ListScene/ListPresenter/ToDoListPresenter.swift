import Foundation

protocol ToDoListViewProtocol: AnyObject {
    func showToDos(_ toDos: [ToDoItem])
    func showError(_ error: Error)
}

protocol ToDoListPresenterInput {
    func viewDidLoad()
    func fetchToDos()
    func showAddToDo()
    func showEditToDo(for toDo: ToDoItem)
    func deleteToDoItem(_ toDo: ToDoItem)
    func toggleComplete(_ toDo: ToDoItem)
}


// MARK: - Presenter

class ToDoListPresenter {
    
    weak var view: ToDoListViewProtocol?
    var interactor: ToDoListInteractorInput?
    var router: ToDoListRouter?
    
    init(view: ToDoListViewProtocol, interactor: ToDoListInteractorInput, router: ToDoListRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}


// MARK: - Interactor Input

extension ToDoListPresenter: ToDoListPresenterInput {
    func viewDidLoad() {
        fetchToDos()
    }
    
    func fetchToDos() {
        interactor?.fetchToDo()
    }
    
    func showAddToDo() {
        router?.AddToDoViewControoler(rootPresenter: self)
    }
    
    func showEditToDo(for toDo: ToDoItem) {
        router?.EditToDoViewControoler(for: toDo, rootPresenter: self)
    }
    
    func deleteToDoItem(_ toDo: ToDoItem) {
        interactor?.deleteToDoItem(toDo: toDo)
    }
    
    func toggleComplete(_ toDo: ToDoItem) {
        interactor?.toggleComplete(toDo)
    }
}


// MARK: - Interactor Output

extension ToDoListPresenter: ToDoListInteractorOutput {
    func didFetchToDos(_ toDos: [ToDoItem]) {
        view?.showToDos(toDos)
    }
    
    func didFailToFetchToDos(with error: Error) {
        view?.showError(error)
    }
    
    func didUpdateToDo() {
        fetchToDos()
    }
}
