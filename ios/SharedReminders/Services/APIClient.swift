import Foundation

class APIClient {
    // MARK: - Configuration
    
    // ⚠️ CAMBIA ESTO CON LA IP DE TU SERVIDOR
    private let baseURL = "http://192.168.1.100:3000/api"
    
    // MARK: - Methods
    
    // Obtener recordatorios de un usuario
    func getReminders(for userId: String) async throws -> [Reminder] {
        let url = URL(string: "\(baseURL)/reminders/\(userId)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(APIResponse<[Reminder]>.self, from: data)
        
        return response.data ?? []
    }
    
    // Obtener recordatorios compartidos
    func getSharedReminders(for userId: String) async throws -> [Reminder] {
        let url = URL(string: "\(baseURL)/reminders/shared/\(userId)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(APIResponse<[Reminder]>.self, from: data)
        
        return response.data ?? []
    }
    
    // Crear recordatorio
    func createReminder(userId: String, title: String, description: String, dueDate: String) async throws -> Reminder {
        let url = URL(string: "\(baseURL)/reminders")!
        
        let request = CreateReminderRequest(
            userId: userId,
            title: title,
            description: description,
            dueDate: dueDate
        )
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response = try JSONDecoder().decode(APIResponse<Reminder>.self, from: data)
        
        guard let reminder = response.data else {
            throw NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: response.error ?? "Unknown error"])
        }
        
        return reminder
    }
    
    // Actualizar recordatorio
    func updateReminder(id: String, title: String? = nil, description: String? = nil, completed: Bool? = nil) async throws -> Reminder {
        let url = URL(string: "\(baseURL)/reminders/\(id)")!
        
        var updates: [String: Any] = [:]
        if let title = title { updates["title"] = title }
        if let description = description { updates["description"] = description }
        if let completed = completed { updates["completed"] = completed }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: updates)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response = try JSONDecoder().decode(APIResponse<Reminder>.self, from: data)
        
        guard let reminder = response.data else {
            throw NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: response.error ?? "Unknown error"])
        }
        
        return reminder
    }
    
    // Eliminar recordatorio
    func deleteReminder(id: String) async throws {
        let url = URL(string: "\(baseURL)/reminders/\(id)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        _ = try await URLSession.shared.data(for: urlRequest)
    }
    
    // Compartir recordatorio
    func shareReminder(id: String, with userId: String) async throws {
        let url = URL(string: "\(baseURL)/reminders/\(id)/share")!
        
        let request = ShareReminderRequest(sharedWithUserId: userId)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        _ = try await URLSession.shared.data(for: urlRequest)
    }
}
