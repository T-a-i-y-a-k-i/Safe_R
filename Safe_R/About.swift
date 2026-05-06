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
                            .foregroundColor(Color(red: 180/255, green: 172/255, blue: 172/255))
                    }
                    
                    Link("github.com/t-a-i-y-a-k-i", destination: URL(string: "https://github.com/t-a-i-y-a-k-i")!)
                        .font(.footnote)
                        .foregroundColor(Color(red: 180/255, green: 172/255, blue: 172/255))
                }
                .padding(.vertical, 4)
                
                HStack {
                    Text("Product Owner")
                    Spacer()
                    Text("Rose Houssain")
                        .foregroundColor(Color(red: 180/255, green: 172/255, blue: 172/255))
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
                        .foregroundColor(Color(red: 180/255, green: 172/255, blue: 172/255))
                    
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
        .scrollContentBackground(.hidden) 
        .background(Color(red: 180/255, green: 172/255, blue: 172/255))
        .navigationTitle("About")
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
}
