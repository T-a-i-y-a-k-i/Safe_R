import SwiftUI
import Combine

class AppData: ObservableObject {
    @AppStorage("password") var password: String = "0000"
    
    @Published var circleColor: Color = .red
    @Published var textColor: Color = .white
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
