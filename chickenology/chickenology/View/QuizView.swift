
import SwiftUI

struct QuizView: View {
    @Binding var selectedTab: String
    @StateObject var rewardMN = RewardsManager()
    @StateObject var progress = ProgressManager()
    @ObservedObject var audioMN = AudioManager.shared
    @State private var facts: [ChickenFact] = chickenFactsData.shuffled()
    @State private var currentIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var showFeedback = false
    @State private var isCorrect = false
    @State private var navigateToResults = false
    @State private var score = 0
    @State private var wrongAnswers = 0
    @State private var showTips = false
    private let currentBG = "bg3"
    let audio = AudioManager.shared
    
    let maxQuestions = 3
    
    var swipeChoice: Bool? {
        if dragOffset.width > 40 {
            return true
        } else if dragOffset.width < -40 {
            return false
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            bg(bgName: currentBG)
            
            VStack(spacing: 0) {
                Button {
                    audio.playButtonSound()
                    selectedTab = "Home"
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: screen.width / 5, height: screen.height / 20)
                            .foregroundStyle(.color4)
                            .shadow(color: .white, radius: 0.3)
                            .shadow(color: .white, radius: 0.3)
                            .shadow(color: .white, radius: 0.3)
                            .shadow(color: .white, radius: 0.3)
                            .shadow(color: .white, radius: 0.3)
                        Text("Back")
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                }

                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 5)
                            .frame(width: screen.width / 1.3, height: screen.height / 6)
                            .foregroundStyle(LinearGradient(colors: [.yellow, .gray, .white, .gray, .yellow], startPoint: .leading, endPoint: .trailing))
                        Rectangle()
                            .frame(width: screen.width / 1.3, height: screen.height / 6).cornerRadius(12)
                            .foregroundStyle(.color4)
                        Text(facts[currentIndex].fact)
                            .foregroundStyle(.white)
                            .font(.system(size: 24).bold())
                            .lineLimit(55)
                            .minimumScaleFactor(1.5)
                            .padding(.horizontal, 75)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    VStack(spacing: 20) {
                        ZStack {
                            Rectangle()
                                .frame(width: screen.width / 1.2, height: screen.height / 1.8)
                                .foregroundStyle(LinearGradient(colors: [.white, .gray, .gray, .gray, .white], startPoint: .top, endPoint: .bottom))
                                .cornerRadius(12)
                            
                            Image(facts[currentIndex].imageName)
                                .resizable()
                                .frame(width: screen.width / 1.3, height: screen.height / 1.9)
                                .shadow(color: .black, radius: 1)
                                .shadow(color: .black, radius: 1)
                                .shadow(color: .black, radius: 1)
                                .shadow(color: .black, radius: 1)
                                .shadow(color: .black, radius: 1)
                        }
                        .overlay {
                            Image("cardEl")
                                .resizable()
                                .frame(width: screen.width / 1.2, height: screen.height / 1.8)
                                .cornerRadius(12)
                        }
                    }
                    .offset(x: dragOffset.width, y: dragOffset.height)
                    .rotationEffect(.degrees(Double(dragOffset.width / 20)))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.spring()) {
                                    dragOffset = value.translation
                                }
                            }
                            .onEnded { value in
                                if abs(value.translation.width) > 120 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        dragOffset.width = value.translation.width > 0 ? 1000 : -1000
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        handleSwipe()
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        dragOffset = .zero
                                    }
                                }
                            }
                    )
                    .padding()
                }
                .zIndex(1)
            }
            
            if navigateToResults {
                ZStack {
                    resultView(progress: progress, retryAction: resetGame, quitAction: { selectedTab = "Home"})
                }
                .zIndex(2)
            }
            if dragOffset.width > 0 {
                ZStack {
                    LinearGradient(colors: [.green.opacity(0.4), .clear], startPoint: .trailing, endPoint: .leading)
                        .ignoresSafeArea()
                }
                .zIndex(0)
            }
            if dragOffset.width < 0 {
                ZStack {
                    LinearGradient(colors: [.red.opacity(0.4), .clear], startPoint: .leading, endPoint: .trailing)
                        .ignoresSafeArea()
                }
                .zIndex(0)
            }
            if showTips {
                tipsView(closeWindow: $showTips)
            }
        }
        .onAppear {
            showTips = true
        }
    }
    func handleSwipe() {
        let answer: Bool?
        
        if dragOffset.width > 100 {
            answer = true
        } else if dragOffset.width < -100 {
            answer = false
        } else {
            dragOffset = .zero
            return
        }
        audio.playSwipeSound()
        audio.vibrateIfEnabled()
        checkAnswer(answer!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            moveToNext()
        }
    }
    func checkAnswer(_ userAnswer: Bool) {
        let correct = facts[currentIndex].isTrue == userAnswer
        isCorrect = correct
        showFeedback = true
        
        progress.totalAnswers += 1
        
        if correct {
            progress.score += 5
            rewardMN.score += progress.score
        } else {
            progress.wrongAnswers += 1
        }
    }
    func moveToNext() {
        showFeedback = false
        dragOffset = .zero
        
        if currentIndex < min(maxQuestions, facts.count) - 1 {
            currentIndex += 1
        } else {
            progress.recordResult()
            navigateToResults = true
        }
    }
    func resetGame() {
        progress.reset()
        currentIndex = 0
        facts.shuffle()
        navigateToResults = false
    }
}
struct ChickenFact: Identifiable {
    let id = UUID()
    let imageName: String
    let fact: String
    let isTrue: Bool
}
let chickenFactsData: [ChickenFact] = [
    ChickenFact(imageName: "cardImage1", fact: "Chickens can dream?", isTrue: true),
    ChickenFact(imageName: "cardImage2", fact: "Chickens can swim?", isTrue: true),
    ChickenFact(imageName: "cardImage3", fact: "Chickens evolution from Dinosaurs?", isTrue: true),
    ChickenFact(imageName: "cardImage4", fact: "Chickens can run faster than humans?", isTrue: false),
    ChickenFact(imageName: "cardImage5", fact: "Chickens lay blue eggs?", isTrue: false),
    ChickenFact(imageName: "cardImage6", fact: "Roosters crow at sunrise?", isTrue: true),
    ChickenFact(imageName: "cardImage7", fact: "Hen can lay an egg without rooster?", isTrue: true),
    ChickenFact(imageName: "cardImage8", fact: "Chickens are unable to fly?", isTrue: false),
    ChickenFact(imageName: "cardImage9", fact: "Chikens can communicate with over 30 different sound?", isTrue: true),
    ChickenFact(imageName: "cardImage10", fact: "Roosters have a natural instinct to protect hens?", isTrue: true),
    ChickenFact(imageName: "cardImage11", fact: "Chickens prefer to eat at night?", isTrue: false),
    ChickenFact(imageName: "cardImage12", fact: "Chickens can recognize their owners?", isTrue: true),
    ChickenFact(imageName: "cardImage13", fact: "Chickens have been domesticated for over 5000 years?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "The heaviest chicken ever recorded weighed over 20 kg?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "Chickens are deaf?", isTrue: false),
    ChickenFact(imageName: "cardQuizImage1", fact: "Roosters have a natural instinct to protect hens?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens use their beaks to explore objects?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens cannot taste spicy foods?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "Chicken bones are hollow like those of birds of prey?", isTrue: false),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens have a third eyelid called the nictitating membrane?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "A chicken’s heartbeat can be over 300 beats per minute?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens are more closely related to dinosaurs than to turkeys?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "Chicken feathers can be used to make clothing?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens can see ultraviolet light?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens are able to walk backwards?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "Chickens use dust baths to clean themselves?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens have a 360-degree field of vision?", isTrue: false),
    ChickenFact(imageName: "cardQuizImage2", fact: "The average lifespan of a chicken is 5-10 years.", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens can dream during REM sleep?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "Chickens communicate their mood with tail feather position?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "A rooster’s crow can be heard up to 1 mile away?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens can run at speeds up to 9 miles per hour?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "The chicken was the first bird to have its genome sequenced?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens can lay eggs of different colors depending on breed?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens have no teeth?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "Chickens’ legs contain more bones than their wings?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens cannot see red colors?", isTrue: false),
    ChickenFact(imageName: "cardQuizImage2", fact: "The chicken is the closest living relative to the Tyrannosaurus rex?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "Chickens have been used in scientific research for decades?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chicken meat is the most consumed meat worldwide?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "Roosters have spurs on their legs used for fighting?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens sleep with one eye open?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens can lay up to 300 eggs per year?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "The world’s largest chicken egg weighed over 12 ounces?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens’ beaks never stop growing?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens do not have a good sense of smell?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage3", fact: "A chicken’s brain is the size of a pea?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage2", fact: "Chickens have more bones in their neck than humans?", isTrue: true),
    ChickenFact(imageName: "cardQuizImage1", fact: "Chickens are descended from the red junglefowl?", isTrue: true),
]
struct tipsView: View {
    @ObservedObject var audio = AudioManager.shared
    
    @State private var currentIndex = 0
    @Binding var closeWindow: Bool
    
    private let slides: [Slide] = [
        .image(name: "slideImage1"),
        .image(name: "slideImage2"),
        .image(name: "slideImage3"),
        .image(name: "slideImage4"),
        .image(name: "slideImage5"),
        .text(content: "Enjoy the game!"),
    ]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(spacing: 45) {
                ZStack {
                    switch slides[currentIndex] {
                    case .image(let name):
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 4)
                            .frame(width: screen.width / 1.65, height: screen.height / 1.76)
                            .foregroundStyle(.gray)
                            .overlay {
                                ZStack {
                                    Image(name)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: screen.width / 1.2, height: screen.height / 1.8)
                                }
                                .cornerRadius(15)
                            }
                    
                    case .text(let content):
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(lineWidth: 5)
                            .frame(width: screen.width / 1.2, height: screen.height / 4)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .gray, .white, .gray, .yellow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay(
                                Rectangle()
                                    .foregroundStyle(.color4)
                                    .cornerRadius(12)
                            )
                            .overlay(
                                Text(content)
                                    .foregroundColor(.white)
                                    .font(.system(size: 24).bold())
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            )
                    }
                }
                
                HStack(spacing: 25) {
                    if currentIndex > 0 {
                        Button {
                            audio.playButtonSound()
                            currentIndex -= 1
                        } label: {
                            ZStack {
                                Image("buttonstngsBG")
                                    .resizable()
                                    .frame(width: screen.width / 2.8, height: screen.height / 13)
                                Text("Previous")
                                    .font(.title2).bold()
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Button {
                        audio.playButtonSound()
                        if currentIndex < slides.count - 1 {
                            currentIndex += 1
                        } else {
                            closeWindow = false
                        }
                    } label: {
                        ZStack {
                            Image("buttonstngsBG")
                                .resizable()
                                .frame(width: screen.width / 2.8, height: screen.height / 13)
                            Text(currentIndex == slides.count - 1 ? "Close" : "Next")
                                .font(.title2).bold()
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding()
        }
    }
}
enum Slide {
    case image(name: String)
    case text(content: String)
}
struct resultView: View {
    @ObservedObject var progress: ProgressManager
    
    @State var retryAction: () -> Void
    @State var quitAction: () -> Void
    let audio = AudioManager.shared
    
    var didWin: Bool {
        let correctAnswers = progress.totalAnswers - progress.wrongAnswers
        return correctAnswers >= progress.wrongAnswers
    }
    
    var body: some View {
        ZStack {
            Image("bg4")
                .resizable()
                .ignoresSafeArea()
            Color.blue.ignoresSafeArea().opacity(0.2)
            Color.black.ignoresSafeArea().opacity(0.7)
            
            VStack(spacing: 30) {
                Text(didWin ? "Quiz Complete!" : "You loss!")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Text("Score: \(progress.score)")
                    .foregroundStyle(.gray)
                    .font(.title)
                Text("Correct Answers: \(progress.totalAnswers - progress.wrongAnswers)")
                    .foregroundStyle(.gray)
                    .font(.title2)
                Text("Wrong Answers: \(progress.wrongAnswers)")
                    .foregroundStyle(.gray)
                    .font(.title2)
                Text("Total Answers: \(progress.totalAnswers)")
                    .foregroundStyle(.gray)
                    .font(.title2)
                VStack(spacing: 12) {
                    Button {
                        audio.playButtonSound()
                        retryAction()
                    } label: {
                        ZStack {
                            Image("resultButtonDS")
                                .resizable()
                                .frame(width: screen.width / 2, height: screen.height / 8)
                            Text("Retry")
                                .font(.title).bold()
                                .foregroundStyle(.white)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                        }
                    }
                    
                    Button {
                        audio.playButtonSound()
                        quitAction()
                    } label: {
                        ZStack {
                            Image("resultButtonDS")
                                .resizable()
                                .frame(width: screen.width / 2, height: screen.height / 8)
                            Text("Quit")
                                .font(.title).bold()
                                .foregroundStyle(.white)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                            
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            if didWin {
                audio.playWinSound()
            } else {
                audio.playLossSound()
            }
        }
    }
}
class ProgressManager: ObservableObject {
    @Published var score: Int {
        didSet { UserDefaults.standard.set(score, forKey: "score")}
    }
    @Published var wrongAnswers: Int {
        didSet { UserDefaults.standard.set(wrongAnswers, forKey: "wrongAnswers")}
    }
    @Published var totalAnswers: Int {
        didSet { UserDefaults.standard.set(totalAnswers, forKey: "totalAnswers")}
    }
    @Published var wins: Int {
        didSet { UserDefaults.standard.set(wins, forKey: "wins")}
    }
    @Published var losses: Int {
        didSet { UserDefaults.standard.set(losses, forKey: "losses")}
    }
    
    init() {
        self.score = UserDefaults.standard.integer(forKey: "score")
        self.wrongAnswers = UserDefaults.standard.integer(forKey: "wrongAnswers")
        self.totalAnswers = UserDefaults.standard.integer(forKey: "totalAnswers")
        self.wins = UserDefaults.standard.integer(forKey: "wins")
        self.losses = UserDefaults.standard.integer(forKey: "losses")
    }
    
    func reset() {
        score = 0
        wrongAnswers = 0
        totalAnswers = 0
    }
    func recordResult() {
        let correctAnswers = totalAnswers - wrongAnswers
        if correctAnswers >= wrongAnswers {
            wins += 1
        } else {
            losses += 1
        }
    }
}
