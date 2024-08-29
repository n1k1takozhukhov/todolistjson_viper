import UIKit

final class EditRouter {
    weak var viewController: UIViewController?
    
    static func assembleModule(toDoItem: ToDoItem, rootPresenter: ToDoListPresenter) -> UIViewController {
        let view = EditViewController()
        let interactor = EditInteractor()
        let presenter = EditPresenter(view: view, interactor: interactor)
        let router = EditRouter()
        
        view.presenter = presenter
        view.rootPresenter = rootPresenter
        view.toDoItem = toDoItem
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

