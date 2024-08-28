import Foundation

protocol ToDoListInteractorInput {
    func fetchToDo()
    func addToDoItem(title: String, description: String, isCompleted: Bool)
    func updateToDoItem(toDo: ToDoItem, title: String, description: String, isCompleted: Bool)
    func deleteToDoItem(toDo: ToDoItem)
    func toggleComplete(_ toDo: ToDoItem)
}

protocol ToDoListInteractorOutput: AnyObject {
    func didFetchToDos(_ toDos: [ToDoItem])
    func didUpdateToDo()
}

class ToDoListInteractor: ToDoListInteractorInput {
    weak var output: ToDoListInteractorOutput?
    
    func fetchToDo() {
        DispatchQueue.global(qos: .background).async {
            var toDos: [ToDoItem] = []
            
            // Check UserDefaults to see if this is the first launch
            let hasFetchToDo = UserDefaults.standard.bool(forKey: "hasFetchToDo")
            if !hasFetchToDo {
                // Fetch todos from API
                CoreDataManager.shared.firstFetchToDos { result in
                    switch result {
                    case .success(let todos):
                        toDos = todos
                    case .failure(_):
                        toDos = CoreDataManager.shared.fetchToDo()
                    }
                }
                // Mark that firstFetchToDos has been called
                UserDefaults.standard.set(true, forKey: "hasFetchToDo")
            } else {
                toDos = CoreDataManager.shared.fetchToDo()
            }
            
            DispatchQueue.main.async {
                self.output?.didFetchToDos(toDos)
            }
        }
    }
    
    func addToDoItem(title: String, description: String, isCompleted: Bool) {
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.shared.createToDo(title: title, description: description, createdDate: Date(), isCompleted: isCompleted)
            DispatchQueue.main.async {
                self.output?.didUpdateToDo()
            }
        }
    }
    
    func updateToDoItem(toDo: ToDoItem, title: String, description: String, isCompleted: Bool) {
        DispatchQueue.global(qos: .background).async {
            CoreDataManager.shared.updateToDo(toDo: toDo, title: title, description: description, isCompleted: isCompleted)
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
            CoreDataManager.shared.updateToDo(toDo: toDo, title: toDo.title ?? "", description: toDo.todoDescription, isCompleted: newStatus)
            DispatchQueue.main.async {
                self.output?.didUpdateToDo()
            }
        }
    }
}
