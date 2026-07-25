import Foundation

@MainActor
class RemindersViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    @Published var sharedReminders: [Reminder] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiClient = APIClient()
    var currentUserId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "default-user"
    }
    
    // MARK: - Methods
    
    func loadReminders() async {
        isLoading = true
        errorMessage = nil
        
        do {
            reminders = try await apiClient.getReminders(for: currentUserId)
            sharedReminders = try await apiClient.getSharedReminders(for: currentUserId)
        } catch {
            errorMessage = "Error al cargar recordatorios: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func createReminder(title: String, description: String, dueDate: Date) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let dateFormatter = ISO8601DateFormatter()
            let dateString = dateFormatter.string(from: dueDate)
            
            let reminder = try await apiClient.createReminder(
                userId: currentUserId,
                title: title,
                description: description,
                dueDate: dateString
            )
            
            reminders.append(reminder)
        } catch {
            errorMessage = "Error al crear recordatorio: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleReminder(_ reminder: Reminder) async {
        do {
            let updated = try await apiClient.updateReminder(
                id: reminder.id,
                completed: !reminder.completed
            )
            
            if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                reminders[index] = updated
            }
        } catch {
            errorMessage = "Error al actualizar recordatorio: \(error.localizedDescription)"
        }
    }
    
    func deleteReminder(_ reminder: Reminder) async {
        do {
            try await apiClient.deleteReminder(id: reminder.id)
            reminders.removeAll { $0.id == reminder.id }
        } catch {
            errorMessage = "Error al eliminar recordatorio: \(error.localizedDescription)"
        }
    }
    
    func shareReminder(_ reminder: Reminder, with userId: String) async {
        do {
            try await apiClient.shareReminder(id: reminder.id, with: userId)
            errorMessage = nil
        } catch {
            errorMessage = "Error al compartir recordatorio: \(error.localizedDescription)"
        }
    }
}
