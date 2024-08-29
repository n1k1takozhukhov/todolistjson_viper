import UIKit

final class ToDoListRouter {
    
    weak var viewController: UIViewController?
    
    static func assembleModule() -> UIViewController {
        let view = ToDoListViewController()
        let interactor = ToDoListInteractor()
        let router = ToDoListRouter()
        let presenter = ToDoListPresenter(
            view: view,
            interactor: interactor,
            router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func AddToDoViewControoler(rootPresenter: ToDoListPresenter) {
        let addToDoVC = AddRouter.assembleModule(rootPresenter: rootPresenter)
        addToDoVC.modalPresentationStyle = .pageSheet
        viewController?.present(addToDoVC, animated: true, completion: nil)
    }
    
    func EditToDoViewControoler(for toDo: ToDoItem, rootPresenter: ToDoListPresenter) {
        let editToDoVC = EditRouter.assembleModule(toDoItem: toDo, rootPresenter: rootPresenter)
        editToDoVC.modalPresentationStyle = .pageSheet
        viewController?.present(editToDoVC, animated: true, completion: nil)
    }
}
