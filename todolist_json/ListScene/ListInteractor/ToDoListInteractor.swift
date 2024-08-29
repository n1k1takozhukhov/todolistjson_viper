import Foundation

protocol ToDoListInteractorInput {
    func fetchToDo()
    func addToDoItem(title: String, description: String, createdDate: Date, isCompleted: Bool)
    func updateToDoItem(toDo: ToDoItem, title: String, description: String, createdDate: Date, isCompleted: Bool)
    func deleteToDoItem(toDo: ToDoItem)
    func toggleComplete(_ toDo: ToDoItem)
}

protocol ToDoListInteractorOutput: AnyObject {
    func didFetchToDos(_ toDos: [ToDoItem])
    func didUpdateToDo()
}

final class ToDoListInteractor: ToDoListInteractorInput {
    weak var output: ToDoListInteractorOutput?
    
    func fetchToDo() {
        DispatchQueue.global(qos: .background).async {
            var toDos: [ToDoItem] = []
            
            let hasFetchToDo = UserDefaults.standard.bool(forKey: "hasFetchToDo")
            if !hasFetchToDo {
                CoreDataManager.shared.firstFetchToDos { result in
                    switch result {
                    case .success(let todos):
                        toDos = todos
                    case .failure(_):
                        toDos = CoreDataManager.shared.fetchToDo()
                    }
                }
                UserDefaults.standard.set(true, forKey: "hasFetchToDo")
            } else {
                toDos = CoreDataManager.shared.fetchToDo()
            }
            
            DispatchQueue.main.async {
                self.output?.didFetchToDos(toDos)
            }
        }
    }
    
    func addToDoItem(title: String, description: String, createdDate: Date, isCompleted: Bool) {
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.shared.createToDo(title: title, description: description, createdDate: Date(), isCompleted: isCompleted)
            DispatchQueue.main.async {
                self.output?.didUpdateToDo()
            }
        }
    }
    
    func updateToDoItem(toDo: ToDoItem, title: String, description: String, createdDate: Date, isCompleted: Bool) {
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.shared.updateToDo(toDo: toDo, title: title, description: description, createdDate: createdDate, isCompleted: isCompleted)
            DispatchQueue.main.async {
                self.output?.didUpdateToDo()
            }
        }
    }
    
    func deleteToDoItem(toDo: ToDoItem) {
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.shared.deleteToDo(toDo)
            DispatchQueue.main.async {
                self.output?.didUpdateToDo()
            }
        }
    }
    
    func toggleComplete(_ toDo: ToDoItem) {
        DispatchQueue.global(qos: .background).async {
            let newStatus = !toDo.isCompleted
            toDo.isCompleted = newStatus
            CoreDataManager.shared.updateToDo(toDo: toDo, title: toDo.title ?? "", description: toDo.todoDescription, createdDate: toDo.createdDate ?? Date(), isCompleted: newStatus)
            DispatchQueue.main.async {
                self.output?.didUpdateToDo()
            }
        }
    }
}
