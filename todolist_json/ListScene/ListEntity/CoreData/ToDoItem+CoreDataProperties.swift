import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var todoDescription: String?
    @NSManaged public var title: String?

}

extension ToDoItem : Identifiable {

}
