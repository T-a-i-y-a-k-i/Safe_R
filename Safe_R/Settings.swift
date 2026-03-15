import SwiftUI
struct Settings: View {
    @ObservedObject var data: AppData
    @State private var newPassword = ""
    @State private var newContact = ""

    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()

            ScrollView { // allow scrolling on small screens
                VStack(spacing: 20) {
                    Text("Set New Password")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)

                    SecureField("Enter new password", text: $newPassword)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.3), lineWidth: 1))
                        .padding(.horizontal, 40)

                    Button("Save Password") {
                        guard !newPassword.isEmpty else { return }
                        data.password = newPassword
                        newPassword = ""
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                    
                    Divider().padding(.vertical)

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
                            contacts.append(newContact)
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
        }
        .navigationTitle("Settings")
    }
}
