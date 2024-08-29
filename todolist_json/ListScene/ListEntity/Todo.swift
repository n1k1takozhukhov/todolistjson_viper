import Foundation

struct TodoResponse: Decodable {
    let todos: [Todo]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Todo: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let createdDate: Date
    let userId: Int
}
