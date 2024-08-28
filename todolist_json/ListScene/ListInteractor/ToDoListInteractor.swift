import Foundation

protocol ToDoListInteractorInput {
    func fetchToDos()
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
    
    func fetchToDos() {
        DispatchQueue.global(qos: .background).async {
            var toDos: [ToDoItem] = []
            
            // Check UserDefaults to see if this is the first launch
            let hasFetchedToDos = UserDefaults.standard.bool(forKey: "hasFetchedToDos")
            if !hasFetchedToDos {
                // Fetch todos from API
                CoreDataManager.shared.firstFetchToDos { result in
                    switch result {
                    case .success(let todos):
                        toDos = todos
                    case .failure(_):
                        toDos = CoreDataManager.shared.fetchToDos()
                    }
                }
                // Mark that firstFetchToDos has been called
                UserDefaults.standard.set(true, forKey: "hasFetchedToDos")
            } else {
                toDos = CoreDataManager.shared.fetchToDos()
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
            toDo.isCompleted.toggle()
            DispatchQueue.main.async {
                self.output?.didUpdateToDo()
            }
        }
    }
}
