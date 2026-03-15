import SwiftUI


@main
struct EmergencyApp: App {
    
    @StateObject private var data = AppData()
    @State private var navPath = NavigationPath()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navPath) {
                ContentView(data: data, navPath: $navPath)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView(
            data: AppData(),
            navPath: .constant(NavigationPath())
        )
    }
}
