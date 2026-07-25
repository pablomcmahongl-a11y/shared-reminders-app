import SwiftUI

struct AddReminderView: View {
    @EnvironmentObject var viewModel: RemindersViewModel
    @Binding var isPresented: Bool
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date().addingTimeInterval(3600) // +1 hour
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Detalles del Recordatorio") {
                    TextField("Título", text: $title)
                    
                    TextField("Descripción (opcional)", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section("Fecha y Hora") {
                    DatePicker(
                        "Recordar en",
                        selection: $dueDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            .navigationTitle("Nuevo Recordatorio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        Task {
                            await viewModel.createReminder(
                                title: title,
                                description: description,
                                dueDate: dueDate
                            )
                            isPresented = false
                        }
                    }
                    .disabled(!isFormValid || viewModel.isLoading)
                }
            }
        }
    }
}

#Preview {
    AddReminderView(isPresented: .constant(true))
        .environmentObject(RemindersViewModel())
}
