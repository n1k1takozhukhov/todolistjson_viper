import Foundation


// MARK: - Protocols

protocol EditInteractorInput {
    func updateToDoItem(toDo: ToDoItem, title: String, description: String, isCompleted: Bool)
}

protocol EditInteractorOutput: AnyObject {
    func didUpdateToDo()
    func didFailToUpdateToDo(with error: Error)
}


// MARK: - Interactor

class EditInteractor: EditInteractorInput {
    weak var output: EditInteractorOutput?
    
    func updateToDoItem(toDo: ToDoItem, title: String, description: String, isCompleted: Bool) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            CoreDataManager.shared.updateToDo(toDo: toDo, title: title, description: description, isCompleted: isCompleted)
            
            DispatchQueue.main.async {
                self?.output?.didUpdateToDo()
            }
        }
    }
}

