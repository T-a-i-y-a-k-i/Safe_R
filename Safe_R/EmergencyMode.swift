import SwiftUI
import MessageUI
import CoreLocation

struct MessageData: Identifiable {
    let id = UUID()
    let text: String
}

struct EmergencyMode: View {
    @ObservedObject var data: AppData
    @State private var isShowingPassword = false
    @State private var didTriggerMessage = false
    @Binding var navPath: NavigationPath
    @State private var showCannotMessageAlert = false
    @StateObject private var locationManager = LocationManager()
    @State private var hasSent = false
    @State private var isLoadingLocation = true
    @State private var messageToSend: MessageData? = nil
    
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
            
            if isLoadingLocation {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.white)
                    .scaleEffect(1.5)
                    .padding(.top, 10)
            }
            
            NavigationLink(destination: Password(data: data), isActive: $isShowingPassword) {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .ignoresSafeArea()
        
        .alert("Messaging Unavailable", isPresented: .constant(true)) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("This device cannot send SMS messages.")
        }
    
        
        .onAppear {
            guard !didTriggerMessage else { return }
            didTriggerMessage = true
            
            guard !data.emergencyContacts.isEmpty else {
                print("No emergency contacts set")
                return
            }
            
            locationManager.requestLocation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if !hasSent {
                    hasSent = true
                    isLoadingLocation = false
                    
                    DispatchQueue.main.async {
                        messageToSend = MessageData(
                            text: "I am in danger. Location unavailable."
                        )
                    }
                }
            }
        }
        
        .onChange(of: locationManager.location) {  newLocation in
            guard let loc = newLocation, !hasSent else { return }
            
            hasSent = true
            isLoadingLocation = false
            
            let lat = loc.coordinate.latitude
            let lon = loc.coordinate.longitude
            let mapLink = "https://maps.apple.com/?ll=\(lat),\(lon)"
            
            DispatchQueue.main.async {
                messageToSend = MessageData(
                    text: "I am in danger. My location: \(mapLink)"
                )
            }
        }
        
        .sheet(item: $messageToSend) { message in
                if MFMessageComposeViewController.canSendText() {
                    MessageComposer(
                        recipients: data.emergencyContacts,
                        messageText: message.text
                    )
                } else {
                    Text("This device cannot send messages.")
                }
            
            }
        }
    }
