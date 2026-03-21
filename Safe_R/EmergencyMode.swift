import SwiftUI
import MessageUI
import CoreLocation

struct EmergencyMode: View {
    @ObservedObject var data: AppData
    @State private var isShowingPassword = false
    @State private var didTriggerMessage = false
    @Binding var navPath: NavigationPath
    @State private var messageToSend: String? = nil
    @State private var showMessage = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Emergency Mode Activated")
                .multilineTextAlignment(.center)
                .font(.system(size: 35, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
            
            Text("Notifications are being sent to your emergency contacts.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            Button(action: {
                isShowingPassword = true
            }) {
                Text("Cancel")
                    .font(.system(size: 25, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 50)
            
            NavigationLink(destination: Password(data: data), isActive: $isShowingPassword) {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .ignoresSafeArea()
        .onAppear {
            if !didTriggerMessage {
                didTriggerMessage = true
                
                locationManager.requestLocation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    prepareMessage()
                }
            }
        }
        .sheet(isPresented: $showMessage) {
            if let message = messageToSend {
                MessageComposer(
                    recipients: data.emergencyContacts,
                    messageText: message
                )
            }
        }
    }
    func prepareMessage() {
        guard MFMessageComposeViewController.canSendText(),
              !data.emergencyContacts.isEmpty else { return }
        
        if let loc = locationManager.location {
            let lat = loc.coordinate.latitude
            let lon = loc.coordinate.longitude
            let mapLink = "https://maps.apple.com/?ll=\(lat),\(lon)"
            messageToSend = "I am in danger. My location: \(mapLink)"
        } else {
            messageToSend = "I am in danger. Location unavailable."
        }

        showMessage = true
    }
}
