import SwiftUI

struct Settings: View {
    @ObservedObject var data: AppData
    @State private var newPassword = ""
    @State private var newContact = ""
    @State private var showErrorBanner = false

    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Emergency Contacts")
                        .font(.title2)
                        .bold()

                    HStack {
                        TextField("Enter phone number", text: $newContact)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)

                        Button("Add") {
                            guard !newContact.isEmpty else { return }

                            var contacts = data.emergencyContacts
                            let cleaned = newContact.filter { $0.isNumber }

                            if isValidPhoneNumber(newContact) {
                                if !contacts.contains(where: { $0.filter { $0.isNumber } == cleaned }) {
                                    contacts.append(newContact)
                                }
                            } else {
                                showErrorBanner = true

                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showErrorBanner = false
                                }
                                return
                            }

                            data.emergencyContacts = contacts
                            newContact = ""
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal, 40)

                    ForEach(data.emergencyContacts, id: \.self) { contact in
                        HStack {
                            Text(contact)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            Spacer()
                            Button("Remove") {
                                var contacts = data.emergencyContacts
                                contacts.removeAll { $0 == contact }
                                data.emergencyContacts = contacts
                            }
                            .foregroundColor(.red)
                        }
                        .padding(.horizontal, 40)
                    }
                }
                .padding(.vertical, 30)
            }

            // Error banner overlay
            if showErrorBanner {
                VStack {
                    Text("Invalid phone number")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)

                    Spacer()
                }
                .padding(.top, 50)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .navigationTitle("Settings")
    }

    func isValidPhoneNumber(_ number: String) -> Bool {
        let detector = try! NSDataDetector(
            types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        )
        let matches = detector.matches(
            in: number,
            options: [],
            range: NSRange(location: 0, length: number.utf16.count)
        )

        return matches.first?.phoneNumber != nil
    }
}
