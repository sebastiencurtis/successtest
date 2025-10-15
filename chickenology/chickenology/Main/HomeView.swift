
import SwiftUI

struct HomeView: View {
    @State var selectedTab: String = "Home"
    @State private var isLoading = false
    @StateObject var rewardMN = RewardsManager()
    @State var currentBG = "bg1"
    @StateObject var audioMN = AudioManager.shared
    let audio = AudioManager.shared
    
    var body: some View {
        ZStack {
            bg(bgName: currentBG)
            if selectedTab == "Home" {
                VStack(spacing: -50) {
                    VStack {
                        Image("topheaderEl")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: screen.width / 1.8, height: screen.height / 4)
                            .padding(0)
                    }
                    .padding(.top, 7)
                    .padding()
                    
                    
                    TabBar(selectedTab: $selectedTab, isLoading: $isLoading)
                        .padding(.bottom)
                    
                }
            }
            if isLoading {
                ZStack {
                    bg(bgName: currentBG)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .teal))
                        .scaleEffect(1.8)
                }
            }
            if !isLoading && selectedTab != "Home" {            ZStack {
                bg(bgName: currentBG)
                
                    switch selectedTab {
                    case "Quiz": QuizView(selectedTab: $selectedTab)
                    case "Settings": SettingsView(selectedTab: $selectedTab)
                    case "Rewards": RewardsView(selectedTab: $selectedTab, rewardMN: RewardsManager())
                    case "Vault": VaultView(selectedTab: $selectedTab)
                    default: EmptyView()
                    }
                }
            }
        }
        .onAppear {
            audio.startBackgroundMusic()
            
        }
    }
}
struct TabBar: View {
    @Binding var selectedTab: String
    @Binding var isLoading: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            TabBarBox(name: "Start Game", tag: "Quiz", selectedTab: $selectedTab, isLoading: $isLoading)
            TabBarBox(name: "Rewards", tag: "Rewards", selectedTab: $selectedTab, isLoading: $isLoading)
            TabBarBox(name: "Vault", tag: "Vault", selectedTab: $selectedTab, isLoading: $isLoading)
            TabBarBox(name: "Settings", tag: "Settings", selectedTab: $selectedTab, isLoading: $isLoading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct TabBarBox: View {
    let audio = AudioManager.shared
    let name: String
    let tag: String
    @Binding var selectedTab: String
    @Binding var isLoading: Bool
    var body: some View {
        Button {
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                audio.playButtonSound()
                selectedTab = tag
                isLoading = false
            }
        } label: {
            ZStack {
                Image("menubuttonBG")
                    .resizable()
                    .frame(width: screen.width / 1.5, height: screen.height / 8)
                    .cornerRadius(12)
                
                Text(name)
                    .font(.title).bold()
                    .foregroundStyle(LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .black, radius: 0.1)
                    .shadow(color: .color5, radius: 3)
                    .shadow(color: .color5, radius: 1)
            }
        }
    }
}
struct bg: View {
    var bgName: String
    var body: some View {
        ZStack {
            Image(bgName)
                .resizable()
                .ignoresSafeArea()
            Color.blue.ignoresSafeArea().opacity(0.2)
            Color.black.ignoresSafeArea().opacity(0.5)
        }
    }
}
struct loadingView: View {
    var body: some View {
        ZStack {
            bg(bgName: "bg")
            VStack(spacing: 50) {
                Image("loadinglogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: screen.height / 2.6)
                VStack(spacing: 40) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .teal))
                        .scaleEffect(3.4)
                    Text("Loading")
                        .font(.largeTitle).bold()
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .shadow(radius: 0.3)
                        .shadow(radius: 0.3)
                        .shadow(radius: 0.3)
                        .shadow(radius: 0.3)
                        .shadow(radius: 0.3)
                        .shadow(radius: 0.3)
                }
            }
        }
    }
}
