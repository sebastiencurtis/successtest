
import SwiftUI

struct VaultView: View {
    @Binding var selectedTab: String
    private let currentBG = "bg5"
    @State private var quizFacts: [quizFact] = quizFactsData.shuffled()
    @State private var currentIndex = 0
    @StateObject var progress = ProgressManager()
    let audio = AudioManager.shared
    
    var body: some View {
        ZStack {
            bg(bgName: currentBG)
            
            VStack {
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
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            VStack(spacing: 5) {
                                ZStack {
                                    Image("\(quizFacts[currentIndex].imageName)")
                                        .resizable()
                                        .frame(width: screen.width / 1.6, height: screen.height / 2.8)
                                        .shadow(color: .black, radius: 1)
                                        .shadow(color: .black, radius: 1)
                                        .shadow(color: .black, radius: 1)
                                        .shadow(color: .black, radius: 1)
                                        .shadow(color: .black, radius: 1)
                                        .cornerRadius(12)
                                }
                                .overlay {
                                    Image("cardEl")
                                        .resizable()
                                        .frame(width: screen.width / 1.6, height: screen.height / 2.8)
                                        .cornerRadius(12)
                                }
                            }
                            .padding(.vertical)
                            
                            ZStack {
                                Rectangle()
                                    .frame(width: screen.width / 1.2, height: screen.height / 7.4).cornerRadius(12)
                                    .foregroundStyle(.color4)
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 3)
                                    .frame(width: screen.width / 1.2, height: screen.height / 7.4)
                                    .foregroundStyle(LinearGradient(colors: [.yellow, .gray, .white, .gray, .yellow], startPoint: .leading, endPoint: .trailing))
                                Text("\(quizFacts[currentIndex].fact)")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24).bold())
                                    .lineLimit(55)
                                    .minimumScaleFactor(1.5)
                                    .padding(.horizontal, 75)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(0)
                            .padding(.bottom)
                            HStack(spacing: 20) {
                                Button {
                                    audio.playButtonSound()
                                    currentIndex = (currentIndex - 1 + quizFacts.count) % quizFacts.count
                                } label: {
                                    ZStack {
                                        Image("buttonstngsBG")
                                            .resizable()
                                            .frame(width: screen.width / 2.8, height: screen.height / 13)
                                        Text("Previous")
                                            .font(.title2).bold()
                                            .foregroundStyle(.white)
                                    }
                                }
                                Button {
                                    audio.playButtonSound()
                                    currentIndex = (currentIndex + 1) % quizFacts.count
                                } label: {
                                    ZStack {
                                        Image("buttonstngsBG")
                                            .resizable()
                                            .frame(width: screen.width / 2.8, height: screen.height / 13)
                                        Text("Next")
                                            .font(.title2).bold()
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: screen.width / 1.2, height: screen.height / 2.8)
                                    .foregroundStyle(.color4)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(lineWidth: 2)
                                            .frame(width: screen.width / 1.2, height: screen.height / 2.8)
                                            .foregroundStyle(LinearGradient(colors: [.white, .color4, .white], startPoint: .top, endPoint: .bottom))
                                    }
                                
                                VStack {
                                    VStack {
                                        Text("Statistics")
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(LinearGradient(colors: [.clear, .yellow, .yellow, .yellow, .clear], startPoint: .leading, endPoint: .trailing))
                                            .frame(width: screen.width / 1.4, height: screen.height / 300)
                                            .opacity(0.8)
                                        VStack(spacing: 12) {
                                            Text("Score: \(progress.score)")
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                            Text("Wrong Answers: \(progress.wrongAnswers)")
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                            
                                            Text("Total Answers: \(progress.totalAnswers)")
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                            Text("Wins: \(progress.wins)")
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                            Text("Loss: \(progress.losses)")
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                        }
                                        .padding(.top)
                                    }
                                    .padding(.bottom)
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct quizFact: Identifiable {
    let id = UUID()
    let fact: String
    let imageName: String
}

let quizFactsData: [quizFact] = [
    quizFact(fact: "Chickens can dream", imageName: "cardImage1"),
    quizFact(fact: "Chickens can swim", imageName: "cardImage2"),
    quizFact(fact: "Chickens evolved from dinosaurs", imageName: "cardImage3"),
    quizFact(fact: "Chickens cannot run faster than humans", imageName: "cardImage4"),
    quizFact(fact: "Chickens cannot lay blue eggs", imageName: "cardImage5"),
    quizFact(fact: "Roosters crow at sunrise", imageName: "cardImage6"),
    quizFact(fact: "Hens can lay eggs without a rooster", imageName: "cardImage7"),
    quizFact(fact: "Chickens are unable to fly long distances", imageName: "cardImage8"),
    quizFact(fact: "Chickens can communicate with over 30 different sounds", imageName: "cardImage9"),
    quizFact(fact: "Roosters have a natural instinct to protect hens", imageName: "cardImage10"),
    quizFact(fact: "Chickens do not prefer to eat at night", imageName: "cardImage11"),
    quizFact(fact: "Chickens can recognize their owners", imageName: "cardImage12"),
    quizFact(fact: "Chickens have been domesticated for over 5000 years", imageName: "cardImage13"),
    quizFact(fact: "The heaviest chicken ever recorded weighed over 20 kg", imageName: "cardQuizImage1"),
    quizFact(fact: "Chickens are not deaf", imageName: "cardQuizImage2"),
    quizFact(fact: "Chickens use their beaks to explore objects", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens cannot taste spicy foods", imageName: "cardQuizImage1"),
    quizFact(fact: "Chicken bones are not hollow like birds of prey", imageName: "cardQuizImage2"),
    quizFact(fact: "Chickens have a third eyelid called the nictitating membrane", imageName: "cardQuizImage3"),
    quizFact(fact: "A chicken’s heartbeat can be over 300 beats per minute", imageName: "cardQuizImage1"),
    quizFact(fact: "Chickens are more closely related to dinosaurs than to turkeys", imageName: "cardQuizImage2"),
    quizFact(fact: "Chicken feathers can be used to make clothing", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens can see ultraviolet light", imageName: "cardQuizImage1"),
    quizFact(fact: "Chickens are able to walk backwards", imageName: "cardQuizImage2"),
    quizFact(fact: "Chickens use dust baths to clean themselves", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens do not have a full 360-degree field of vision", imageName: "cardQuizImage1"),
    quizFact(fact: "The average lifespan of a chicken is 5-10 years", imageName: "cardQuizImage2"),
    quizFact(fact: "Chickens can dream during REM sleep", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens communicate mood with tail feather position", imageName: "cardQuizImage1"),
    quizFact(fact: "A rooster’s crow can be heard up to 1 mile away", imageName: "cardQuizImage2"),
    quizFact(fact: "Chickens can run at speeds up to 9 miles per hour", imageName: "cardQuizImage3"),
    quizFact(fact: "The chicken was the first bird to have its genome sequenced", imageName: "cardQuizImage1"),
    quizFact(fact: "Chickens can lay eggs of different colors depending on breed", imageName: "cardQuizImage2"),
    quizFact(fact: "Chickens have no teeth", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens’ legs contain more bones than their wings", imageName: "cardQuizImage1"),
    quizFact(fact: "Chickens can see red colors", imageName: "cardQuizImage2"),
    quizFact(fact: "The chicken is the closest living relative to the Tyrannosaurus rex", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens have been used in scientific research for decades", imageName: "cardQuizImage1"),
    quizFact(fact: "Chicken meat is the most consumed meat worldwide", imageName: "cardQuizImage2"),
    quizFact(fact: "Roosters have spurs on their legs used for fighting", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens sleep with one eye open", imageName: "cardQuizImage1"),
    quizFact(fact: "Chickens can lay up to 300 eggs per year", imageName: "cardQuizImage2"),
    quizFact(fact: "The world’s largest chicken egg weighed over 12 ounces", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens’ beaks never stop growing", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens do not have a good sense of smell", imageName: "cardQuizImage1"),
    quizFact(fact: "A chicken’s brain is the size of a pea", imageName: "cardQuizImage2"),
    quizFact(fact: "Chickens have more bones in their neck than humans", imageName: "cardQuizImage3"),
    quizFact(fact: "Chickens are descended from the red junglefowl", imageName: "cardQuizImage1")
]

