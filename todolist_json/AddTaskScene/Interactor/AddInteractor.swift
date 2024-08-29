import Foundation

protocol AddInteractorInput {
    func addToDoItem(title: String, description: String, createdDate: Date)
}

protocol AddInteractorOutput: AnyObject {
    func didAddToDo()
    func didFailToAddToDo(with error: Error)
}

final class AddInteractor: AddInteractorInput {
    weak var output: AddInteractorOutput?
    
    func addToDoItem(title: String, description: String, createdDate: Date) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            CoreDataManager.shared.createToDo(title: title, description: description, createdDate: createdDate, isCompleted: false)
            
            DispatchQueue.main.async {
                self?.output?.didAddToDo()
            }
        }
    }
}

