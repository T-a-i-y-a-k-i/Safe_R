import SwiftUI
struct ContentView: View {
    @ObservedObject var data: AppData
    @Binding var navPath: NavigationPath

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                HStack {
                    NavigationLink {
                        Settings(data: data)
                    } label: {
                        Image("Account_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)

                Spacer()
                
                Text("EMERGENCY ALARM")
                    .font(.system(size: 35, weight: .bold))
                    .multilineTextAlignment(.center)

                ZStack {
                    GeometryReader { geo in
                        Circle()
                            .fill(data.circleColor)
                            .frame(width: min(geo.size.width * 0.8, 300),
                                   height: min(geo.size.width * 0.8, 300))
                            .position(x: geo.size.width/2, y: geo.size.height/2)
                            .contentShape(Circle())
                            .onTapGesture {
                                data.isShowingEmergency = true
                            }

                        Text("SOS")
                            .font(.system(size: min(geo.size.width * 0.25, 120), weight: .bold))
                            .foregroundColor(data.textColor)
                            .position(x: geo.size.width/2, y: geo.size.height/2)
                            .allowsHitTesting(false)
                    }
                    .frame(height: 300)
                }

                Text("Press this button in the case of an emergency. A notification and your live location will be sent to your emergency contacts informing them you need help.")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .font(.system(size: 17))
                    .fixedSize(horizontal: false, vertical: true)

                NavigationLink(destination: EmergencyMode(data: data, navPath: $navPath), isActive: $data.isShowingEmergency) {
                    EmptyView()
                }
            }
        }
    }
}
