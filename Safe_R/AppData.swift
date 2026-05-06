import SwiftUI
import Combine

class AppData: ObservableObject {
    @AppStorage("password") var password: String = "0000"
    
    @Published var circleColor: Color = Color(red: 0.62, green: 0.20, blue: 0.20)
    @Published var textColor: Color = Color(red: 0.945, green: 0.937, blue: 0.906)
    @Published var isShowingEmergency = false
    @Published var isShowingPassword = false
    @Published var isShowingSettings = false
    @Published var showMessage = false
    
    @AppStorage("emergencyContacts") private var storedContacts: String = ""
        
    var emergencyContacts: [String] {
        get {
            storedContacts.isEmpty ? [] : storedContacts.components(separatedBy: ",")
        }
        set {
            storedContacts = newValue.joined(separator: ",")
        }
    }
}
