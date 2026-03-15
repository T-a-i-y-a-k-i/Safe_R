import SwiftUI
struct Password: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var data: AppData
    @State private var passwordEntry = ""

    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Enter your password to cancel your alert and notify your contacts you are safe")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .font(.system(size: 20))
                    .foregroundColor(.white)

                SecureField("Enter Password", text: $passwordEntry)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .textContentType(.password)
                    .onSubmit {
                        checkPassword()
                    }
                    .padding(.horizontal, 40)

                Button("Confirm") {
                    checkPassword()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal, 40)
            }
        }
    }

    func checkPassword() {
        if passwordEntry == data.password {
            data.isShowingEmergency = false
            dismiss()
        } else {
            passwordEntry = ""
            print("Wrong password")
        }
    }
}
