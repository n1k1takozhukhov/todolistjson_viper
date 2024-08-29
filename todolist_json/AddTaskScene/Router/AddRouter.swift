import UIKit

final class AddRouter {
    weak var viewController: UIViewController?
    
    static func assembleModule(rootPresenter: ToDoListPresenter) -> UIViewController {
        let view = AddViewController()
        let interactor = AddInteractor()
        let presenter = AddTaskPresenter(view: view, interactor: interactor)
        let router = AddRouter()
        
        view.presenter = presenter
        view.rootPresenter = rootPresenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
}

