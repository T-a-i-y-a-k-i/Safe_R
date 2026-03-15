import SwiftUI
import MessageUI

struct EmergencyMode: View {
    @ObservedObject var data: AppData
    @State private var isShowingPassword = false
    @State private var didTriggerMessage = false
    @Binding var navPath: NavigationPath
    @State private var showMessage = false

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
                
                if MFMessageComposeViewController.canSendText() && !data.emergencyContacts.isEmpty {
                    showMessage = true
                }
            }
        }
        .sheet(isPresented: $showMessage) {
            MessageComposer(
                recipients: data.emergencyContacts,
                body: "I am in danger, please help."
            )
        }
    }
}
