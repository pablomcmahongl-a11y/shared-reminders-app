import Foundation

// MARK: - Models

struct Reminder: Codable, Identifiable {
    let id: String
    let userId: String
    let title: String
    let description: String
    let dueDate: String
    let createdAt: String
    var completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title, description, dueDate, createdAt, completed
    }
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: String?
    let message: String?
}

struct CreateReminderRequest: Codable {
    let userId: String
    let title: String
    let description: String
    let dueDate: String
}

struct ShareReminderRequest: Codable {
    let sharedWithUserId: String
}
