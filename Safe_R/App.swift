import SwiftUI


@main
struct EmergencyApp: App {
    
    @StateObject private var data = AppData()
    @State private var navPath = NavigationPath()
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navPath) {
                ContentView(data: data, navPath: $navPath)
                    .environmentObject(locationManager)
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
