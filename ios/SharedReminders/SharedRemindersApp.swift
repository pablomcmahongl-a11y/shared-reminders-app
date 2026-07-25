import SwiftUI

@main
struct SharedRemindersApp: App {
    @StateObject private var viewModel = RemindersViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .onAppear {
                    Task {
                        await viewModel.loadReminders()
                    }
                }
        }
    }
}
