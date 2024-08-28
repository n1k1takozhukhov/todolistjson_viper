import UIKit
import CoreData

public final class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    private lazy var context = persistentContainer.viewContext
    
    // MARK: - ToDo CRUD Operations
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "todolist_json")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data stack
    public func createToDo(title: String, description: String?, createdDate: Date, isCompleted: Bool) {
        guard let toDoEntityDescription = NSEntityDescription.entity(forEntityName: "ToDoItem", in: context) else { return }
        
        let toDo = NSManagedObject(entity: toDoEntityDescription, insertInto: context) as! ToDoItem
        toDo.id = UUID()
        toDo.title = title
        toDo.todoDescription = description
        toDo.createdDate = createdDate
        toDo.isCompleted = isCompleted
        
        saveContext()
    }
    
    public func firstFetchToDos(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                for todo in todoResponse.todos {
                    self.createToDo(title: todo.todo, description: nil, createdDate: Date(), isCompleted: todo.completed)
                }
                let toDos = self.fetchToDo()
                completion(.success(toDos))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        
        task.resume()
    }
    
    public func fetchToDo() -> [ToDoItem] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItem")
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return (try context.fetch(fetchRequest) as? [ToDoItem]) ?? []
        } catch {
            print("Failed to fetch ToDos: \(error)")
            return []
        }
    }
    
    public func updateToDo(toDo: ToDoItem, title: String, description: String?, isCompleted: Bool) {
        toDo.title = title
        toDo.todoDescription = description
        toDo.isCompleted = isCompleted
        
        saveContext()
    }
    
    public func deleteToDo(_ toDo: ToDoItem) {
        context.delete(toDo)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

