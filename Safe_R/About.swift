import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            
            Section(header: Text("Credits")) {
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Avery McComas")
                            .foregroundColor(.gray)
                    }
                    
                    Link("github.com/t-a-i-y-a-k-i", destination: URL(string: "https://github.com/t-a-i-y-a-k-i")!)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
                
                HStack {
                    Text("Product Owner")
                    Spacer()
                    Text("Rose Houssain")
                        .foregroundColor(.gray)
                }
            }
            
            Section {
                VStack(spacing: 10) {
                    
                    Image("AppIcon")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .cornerRadius(20)
                        .padding(.top, 10)
                    
                    Text("Safe_R")
                        .font(.title)
                        .bold()
                    
                    Text("Version \(appVersion)")
                        .foregroundColor(.gray)
                    
                    Text("Safe_R helps you quickly send your location to trusted contacts in an emergency.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity)
            }
            
            Section{
                VStack(spacing: 10){
                    
                    Text("Privacy policy")
                        .font(.title)
                        .bold()
                    
                    Text("Privacy policy words go here")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("About")
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
