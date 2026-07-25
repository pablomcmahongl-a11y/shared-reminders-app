import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: RemindersViewModel
    @State private var shareUserId = ""
    @State private var showShareAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Mi Información") {
                    HStack {
                        Text("User ID")
                        Spacer()
                        Text(viewModel.currentUserId)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        UIPasteboard.general.string = viewModel.currentUserId
                    }) {
                        HStack {
                            Text("Copiar ID")
                            Spacer()
                            Image(systemName: "doc.on.doc")
                        }
                    }
                }
                
                Section("Compartir Recordatorio") {
                    TextField("ID del Usuario", text: $shareUserId)
                    
                    Button(action: { showShareAlert = true }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Compartir con otro usuario")
                        }
                    }
                }
                
                Section("Estadísticas") {
                    HStack {
                        Text("Total de recordatorios")
                        Spacer()
                        Text("\(viewModel.reminders.count)")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Compartidos conmigo")
                        Spacer()
                        Text("\(viewModel.sharedReminders.count)")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Completados")
                        Spacer()
                        Text("\(viewModel.reminders.filter { $0.completed }.count)")
                            .fontWeight(.semibold)
                    }
                }
            }
            .navigationTitle("Perfil")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(RemindersViewModel())
}
