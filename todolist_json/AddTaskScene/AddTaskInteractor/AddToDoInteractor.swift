import Foundation


// MARK: - Protocols

protocol AddToDoInteractorInput {
    func addToDoItem(title: String, description: String)
}

protocol AddToDoInteractorOutput: AnyObject {
    func didAddToDo()
    func didFailToAddToDo(with error: Error)
}


// MARK: - Interactor

class AddToDoInteractor: AddToDoInteractorInput {
    weak var output: AddToDoInteractorOutput?
    
    func addToDoItem(title: String, description: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            CoreDataManager.shared.createToDo(title: title, description: description, createdDate: Date(), isCompleted: false)
            
            DispatchQueue.main.async {
                self?.output?.didAddToDo()
            }
        }
    }
}

