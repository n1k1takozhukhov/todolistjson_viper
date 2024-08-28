import UIKit


// MARK: - Router

class EditToDoRouter {
    
    weak var viewController: UIViewController?
    
    static func assembleModule(toDoItem: ToDoItem, rootPresenter: ToDoListPresenter) -> UIViewController {
        let view = EditToDoViewController()
        let interactor = EditToDoInteractor()
        let presenter = EditToDoPresenterImpl(view: view, interactor: interactor)
        let router = EditToDoRouter()
        
        view.presenter = presenter
        view.rootPresenter = rootPresenter
        view.toDoItem = toDoItem
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

