import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: RemindersViewModel
    @State private var showAddReminder = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Mis Recordatorios
            ReminderListView(reminders: viewModel.reminders, title: "Mis Recordatorios")
                .tabItem {
                    Label("Mis", systemImage: "list.bullet")
                }
                .tag(0)
            
            // Recordatorios Compartidos
            ReminderListView(reminders: viewModel.sharedReminders, title: "Compartidos")
                .tabItem {
                    Label("Compartidos", systemImage: "square.and.arrow.up")
                }
                .tag(1)
            
            // Perfil
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
                .tag(2)
        }
        .overlay(alignment: .bottomTrailing) {
            Button(action: { showAddReminder = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .padding(20)
            }
        }
        .sheet(isPresented: $showAddReminder) {
            AddReminderView(isPresented: $showAddReminder)
                .environmentObject(viewModel)
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil), actions: {
            Button("OK") { viewModel.errorMessage = nil }
        }, message: {
            Text(viewModel.errorMessage ?? "")
        })
    }
}

#Preview {
    ContentView()
        .environmentObject(RemindersViewModel())
}
