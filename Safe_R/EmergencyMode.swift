import SwiftUI
import MessageUI
import CoreLocation

struct MessageData: Identifiable {
    let id = UUID()
    let text: String
}

import MessageUI
import UIKit

final class SMSHelper: NSObject, MFMessageComposeViewControllerDelegate {
    static let shared = SMSHelper()

    func sendMessage(recipients: [String], body: String) {
        guard MFMessageComposeViewController.canSendText() else {
            print("SMS not available")
            return
        }

        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = body
        vc.messageComposeDelegate = self

        if let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController {

            root.present(vc, animated: true)
        }
    }

    func messageComposeViewController(
        _ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult
    ) {
        controller.dismiss(animated: true)
    }
}

struct EmergencyMode: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var data: AppData

    @State private var didTriggerMessage = false
    @State private var hasSent = false
    @State private var isLoadingLocation = true
    @State private var messageToSend: MessageData? = nil
    @State private var pendingMessage: MessageData? = nil

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

            Button("Cancel") {
                print("CANCEL: tapped")

                authenticateUser { success in
                    DispatchQueue.main.async {
                        print("CANCEL: auth result =", success)

                        if success {

                            SMSHelper.shared.sendMessage(
                                recipients: data.emergencyContacts,
                                body: "I am safe now. Emergency cancelled."
                            )

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                print("CANCEL: dismissing emergency mode")
                                dismiss()
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 50)

            if isLoadingLocation {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.white)
                    .scaleEffect(1.5)
                    .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .ignoresSafeArea()

        // MARK: - Start emergency flow
        .onAppear {
            guard !didTriggerMessage else { return }
            didTriggerMessage = true

            guard !data.emergencyContacts.isEmpty else {
                print("No emergency contacts set")
                return
            }

            locationManager.requestLocation()

            // fallback message if location fails
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if !hasSent {
                    hasSent = true
                    isLoadingLocation = false

                    pendingMessage = MessageData(
                        text: "I am in danger. Location unavailable."
                    )

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        messageToSend = pendingMessage
                    }
                }
            }
        }

        // MARK: - Location update
        .onChange(of: locationManager.location) { newLocation in
            guard let loc = newLocation, !hasSent else { return }

            hasSent = true
            isLoadingLocation = false

            let lat = loc.coordinate.latitude
            let lon = loc.coordinate.longitude
            let mapLink = "https://maps.apple.com/?ll=\(lat),\(lon)"

            pendingMessage = MessageData(
                text: "I am in danger. My location: \(mapLink)"
            )

            // IMPORTANT: delay prevents SwiftUI presentation conflict
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                messageToSend = pendingMessage
            }
        }

        // MARK: - Debug
        .onAppear {
            print("Sending to:", data.emergencyContacts)
            print("Can send:", MFMessageComposeViewController.canSendText())
        }

        // MARK: - Message UI
        .sheet(item: $messageToSend) { message in
            MessageComposer(
                recipients: data.emergencyContacts,
                messageText: message.text
            )
        }
    }
}
