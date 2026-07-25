import SwiftUI

struct ReminderListView: View {
    @EnvironmentObject var viewModel: RemindersViewModel
    let reminders: [Reminder]
    let title: String
    
    var sortedReminders: [Reminder] {
        reminders.sorted { a, b in
            (a.dueDate < b.dueDate)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if reminders.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No hay recordatorios")
                            .font(.headline)
                        Text("Crea uno nuevo con el botón +")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    List {
                        ForEach(sortedReminders) { reminder in
                            ReminderRowView(reminder: reminder)
                                .environmentObject(viewModel)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        Task {
                                            await viewModel.deleteReminder(reminder)
                                        }
                                    } label: {
                                        Label("Eliminar", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .refreshable {
                await viewModel.loadReminders()
            }
        }
    }
}

struct ReminderRowView: View {
    @EnvironmentObject var viewModel: RemindersViewModel
    let reminder: Reminder
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        if let date = ISO8601DateFormatter().date(from: reminder.dueDate) {
            return formatter.string(from: date)
        }
        return reminder.dueDate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: {
                    Task {
                        await viewModel.toggleReminder(reminder)
                    }
                }) {
                    Image(systemName: reminder.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(reminder.completed ? .green : .gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reminder.title)
                        .font(.headline)
                        .strikethrough(reminder.completed)
                    
                    if !reminder.description.isEmpty {
                        Text(reminder.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            
            Text(formattedDate)
                .font(.caption2)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ReminderListView(
        reminders: [
            Reminder(
                id: "1",
                userId: "user-1",
                title: "Comprar leche",
                description: "En el supermercado",
                dueDate: "2026-07-26T10:00:00Z",
                createdAt: "2026-07-25T10:00:00Z",
                completed: false
            )
        ],
        title: "Mis Recordatorios"
    )
    .environmentObject(RemindersViewModel())
}
