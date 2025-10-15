
import SwiftUI

struct RewardsView: View {
    @Binding var selectedTab: String
    @ObservedObject var rewardMN = RewardsManager.shared
    @ObservedObject var progressMN = ProgressManager()
    @State private var alertRewardID : UUID? = nil
    @State private var showingDetailReward: Reward? = nil
    let currentBG = "bg5"
    let audio = AudioManager.shared
    
    var body: some View {
        ZStack {
            bg(bgName: currentBG)
            
            VStack(spacing: 3) {
                VStack(alignment: .leading) {
                    Button {
                        audio.playButtonSound()
                        selectedTab = "Home"
                    } label: {
                        ZStack {
                            Image("stngsbuttonBG")
                                .resizable()
                                .frame(width: screen.width / 3, height: screen.height / 16)
                                .cornerRadius(8)
                            Text("Back")
                                .foregroundStyle(.white)
                                .font(.title2).bold()
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .shadow(radius: 0.3)
                                .overlay {
                                    Text("Back")
                                        .foregroundStyle(Color.black.opacity(0.07))
                                        .font(.title2).bold()
                                }
                        }
                    }
                }
                .padding(.trailing, 200)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 5)
                        .frame(width: screen.width / 1.8, height: screen.height / 17)
                        .foregroundStyle(.gray)
                    Text("Score: \(rewardMN.score) pts")
                        .foregroundStyle(.white)
                        .font(.title2)
                }
                .padding(2)
                .padding(.bottom)
                .padding(.top)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                        ForEach(rewardMN.rewards) { reward in
                            VStack {
                                Image(reward.imageName)
                                    .resizable()
                                    .frame(width: screen.width / 2.5, height: screen.height / 5)
                                    .cornerRadius(12)
                                    .shadow(color: .white, radius: 0.3)
                                    .shadow(color: .white, radius: 0.3)
                                    .shadow(color: .white, radius: 0.3)
                                    .shadow(color: .white, radius: 0.3)
                                    .overlay {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .frame(width: screen.width / 2.5, height: screen.height / 5)
                                                .foregroundStyle(LinearGradient(colors: [.black.opacity(0.4), .black.opacity(0.80), .black], startPoint: .top, endPoint: .bottom))
                                                .opacity(rewardMN.purchasedRewards.contains(reward.title) ? 0.6 : 1)
                                            RoundedRectangle(cornerRadius: 12)
                                                .frame(width: screen.width / 2.5, height: screen.height / 5)
                                                .foregroundStyle(LinearGradient(colors: [.black], startPoint: .top, endPoint: .bottom))
                                                .opacity(rewardMN.purchasedRewards.contains(reward.title) ? 0.1 : 0.6)
                                            VStack {
                                                Text(reward.title)
                                                    .font(.headline)
                                                    .foregroundStyle(.white)
                                                    .multilineTextAlignment(.center)
                                                    .padding(.top, 35)
                                                    .padding(.horizontal)
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .foregroundStyle(.black)
                                                        .frame(width: screen.width / 4.2, height: screen.height / 20)
                                                        .opacity(rewardMN.purchasedRewards.contains(reward.title) ? 0 : 1)
                                                    Text("\(reward.price) pts")
                                                        .font(.headline)
                                                        .foregroundStyle(.white)
                                                        .opacity(rewardMN.purchasedRewards.contains(reward.title) ? 0 : 1)
                                                }
                                            }
                                        }
                                    }
                                Text(reward.descriptionn)
                                    .font(.callout).bold()
                                    .foregroundStyle(.white)
                                    .opacity(0.8)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(5.5)
                                    .lineLimit(15)
                                    .padding(.horizontal, 45)
                                    .padding(5)
                                
                                if rewardMN.purchasedRewards.contains(reward.title) {
                                    Button {
                                        audio.playButtonSound()
                                        print("Viewing \(reward.title)")
                                        showingDetailReward = reward
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(lineWidth: 5)
                                                .frame(width: screen.width / 3.5, height: screen.height / 17)
                                                .foregroundStyle(LinearGradient(colors: [.yellow, .gray, .white, .gray, .yellow], startPoint: .leading, endPoint: .trailing))
                                            RoundedRectangle(cornerRadius: 9)
                                                .frame(width: screen.width / 3.5, height: screen.height / 17)
                                                .foregroundStyle(.color4)
                                            Text("View")
                                                .font(.title3).bold()
                                                .foregroundStyle(.white)
                                                .opacity(0.8)
                                        }
                                    }
                                } else {
                                    Button {
                                        if !rewardMN.canBuy(reward) {
                                            audio.playButtonSound()
                                            alertRewardID = reward.id
                                        } else {
                                            audio.playButtonSound()
                                           _ = rewardMN.buy(reward)
                                        }
                                    } label: {
                                        ZStack {
                                            Image("buttonBG")
                                                .resizable()
                                                .frame(width: screen.width / 3.5, height: screen.height / 17)
                                            Text("Buy")
                                                .font(.title2).bold()
                                                .foregroundStyle(.black)
                                                .opacity(0.7)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            if alertRewardID != nil {
                VStack {
                    ZStack {
                        Color.black.ignoresSafeArea().opacity(0.5)
                            .onTapGesture {
                                audio.playButtonSound()
                                alertRewardID = nil
                            }
                        
                        VStack(spacing: 20) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(lineWidth: 5)
                                    .frame(width: screen.width / 1.3, height: screen.height / 4)
                                    .foregroundStyle(LinearGradient(colors: [.yellow, .gray, .white, .gray, .yellow], startPoint: .leading, endPoint: .trailing))
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: screen.width / 1.3, height: screen.height / 4)
                                    .foregroundStyle(.color4)
                                    .shadow(color: .white, radius: 0.3)
                                    .shadow(color: .white, radius: 0.3)
                                    .shadow(color: .white, radius: 0.3)
                                Text("Not Enough points to get reward!")
                                    .foregroundStyle(.white)
                            }
                            Button {
                                audio.playButtonSound()
                                alertRewardID = nil
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 9)
                                        .frame(width: screen.width / 4.5, height: screen.height / 18)
                                        .foregroundStyle(.color4)
                                        .shadow(color: .white, radius: 0.3)
                                        .shadow(color: .white, radius: 0.3)
                                        .shadow(color: .white, radius: 0.3)
                                        .shadow(color: .white, radius: 0.3)
                                        .shadow(color: .white, radius: 0.3)
                                        .shadow(color: .white, radius: 0.3)
                                        .shadow(color: .white, radius: 0.3)
                                    Text("Close")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        
                    }
                    .zIndex(11)
                }
            }
            if let showDetail = showingDetailReward?.detail {
                VStack {
                    ZStack {
                        Color.black.ignoresSafeArea().opacity(0.7)
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .frame(height: screen.height / 5).opacity(0)
                                ScrollView(.vertical, showsIndicators: false) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(lineWidth: 5)
                                            .frame(width: screen.width / 1.2, height: screen.height / 0.90)
                                            .foregroundStyle(LinearGradient(colors: [.yellow, .gray, .white, .gray, .yellow], startPoint: .leading, endPoint: .trailing))
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(.color4)
                                            .frame(width: screen.width / 1.2, height: screen.height / 0.90)
                                        VStack(spacing: 20) {
                                            Text(showDetail.name)
                                                .font(.title)
                                                .foregroundStyle(.white)
                                            RoundedRectangle(cornerRadius: 12)
                                                .foregroundStyle(.gray)
                                                .frame(width: screen.width / 2.2, height: screen.height / 3.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .overlay {
                                                    Image(showDetail.imageName)
                                                        .resizable()
                                                        .frame(width: screen.width / 2.5, height: screen.height / 3.6)
                                                        .cornerRadius(12)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                        .shadow(radius: 0.3)
                                                }
                                            Text(showDetail.descriptio)
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                                .opacity(0.8)
                                                .multilineTextAlignment(.center)
                                                .padding(.horizontal, 25)
                                                .lineLimit(175)
                                                .minimumScaleFactor(15.5)
                                                .padding(.horizontal)
                                            HStack(spacing: 12) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(lineWidth: 2)
                                                        .frame(width: screen.width / 5, height: screen.height / 24)
                                                        .foregroundStyle(.gray)
                                                    Text(showDetail.cookingTime)
                                                        .font(.callout)
                                                        .foregroundStyle(.white)
                                                }
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                    .stroke(lineWidth: 2)
                                                    .frame(width: screen.width / 3, height: screen.height / 24)
                                                    .foregroundStyle(.gray)
                                                    Text(showDetail.difficulty)
                                                        .font(.callout)
                                                        .foregroundStyle(.white)
                                                }
                                            }
                                            VStack {
                                                Text("Ingredients:")
                                                    .font(.title3)
                                                    .foregroundStyle(.white)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(20)
                                                    .minimumScaleFactor(3.5)
                                                    .padding(.horizontal)
                                                ForEach(showDetail.ingredients, id: \.self) { ingredient in
                                                    Text("· \(ingredient)")
                                                        .font(.headline)
                                                        .foregroundStyle(.white)
                                                        .opacity(0.6)
                                                }
                                            }
                                            RoundedRectangle(cornerRadius: 12)
                                                .frame(width: screen.width / 1.3, height: screen.height / 190)
                                                .foregroundStyle(.white).opacity(0.2)
                                                .padding(1)
                                            VStack(alignment: .leading) {
                                                VStack {
                                                    ForEach(Array(showDetail.steps.enumerated()), id: \.offset) { index, step in
                                                        Text("\(index + 1). \(step)")
                                                            .foregroundStyle(.white)
                                                            .multilineTextAlignment(.center)
                                                            .padding(.horizontal, 35)
                                                            .lineLimit(175)
                                                            .minimumScaleFactor(15.5)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.bottom, 15)
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                    
                                    Button {
                                        audio.playButtonSound()
                                        showingDetailReward = nil
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 9)
                                                .frame(width: screen.width / 4.5, height: screen.height / 18)
                                                .foregroundStyle(.color4)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                                .shadow(color: .white, radius: 0.3)
                                            Text("Close")
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }
                                Rectangle()
                                    .frame(height: screen.height / 12).opacity(0)
                            }
                        }
                        
                    }
                    .zIndex(11)
                }
            }
        }
    }
}
class RewardsManager: ObservableObject {
    static let shared = RewardsManager()
    
    @Published var rewards : [Reward] = [
        Reward(title: "Herb Omlette", descriptionn: "A light, fluffy omlette seasoned with fresh herbs and a pinch of salt.", imageName: "receiptPhoto1", price: 2500, detail: RewardDetail(id: UUID(), name: "Herb Omlette", descriptio: "A light, fluffy omlette seasoned with fresh herbs and a pinch of salt.", cookingTime: "15 min", difficulty: "Easy", ingredients: ["Eggs", "Sausage", "Salt", "Herbs"], imageName: "receiptPhoto1", steps: ["Crack the eggs into a bowl and whisk until smooth.", "Add chopped fresh herbs and salt to taste.", "Melt butter in a hot pan.", "Pour the egg mixture into the pan and cook on low heat.", "Fold and serve warm."])),
        Reward(title: "Banana Omlette", descriptionn: "Tasty egg omlette with herbs and banana", imageName: "receiptPhoto2", price: 500, detail: RewardDetail(id: UUID(), name: "Banana Omlette", descriptio: "Tasty egg omlette with herbs and banana", cookingTime: "10 min", difficulty: "Easy", ingredients: ["Eggs", "Banana", "Butter", "Apple", "Salt", "Herbs"], imageName: "receiptPhoto2", steps: ["Mash the banana with a fork.", "Add the eggs and beat until all is well mixed and fluffy.", "Add spices up to taste.", "Add some salt, pepper and some chili flakes.", "Heat some oil in a pan, and pour the banana-egg mixture in the pan.", "Bake the omelette over medium heat. So you prevent that it burns at the bottom and is still raw on top.", "When the omelette is firm enough, turn it around and bake it for a short time on the other side."])),
        Reward(title: "Chicken Curry", descriptionn: "Spicy chicken curry with fragrant spices.", imageName: "receiptPhoto3", price: 5000, detail: RewardDetail(id: UUID(), name: "Chicken Curry", descriptio: "Juice tomato with egg omlette and ganj", cookingTime: "15 min", difficulty: "Medium", ingredients: ["Chicken", "Onion", "Garlic", "Curry Powder", "Coconut Milk", "Oil", "Salt"], imageName: "receiptPhoto3", steps: ["Cut chicken into bite-sized pieces.", "Fry onions and garlic until golden.", "Add curry powder and stir for 1 minute.", "Add chicken and cook until browned.", "Pour in coconut milk and simmer for 20 minutes.", "Serve with rice or bread."])),
        Reward(title: "Chicken Noodle Soup", descriptionn: "Comforting chicken soup with noodles and vegetables.", imageName: "receiptPhoto4", price: 2200, detail: RewardDetail(id: UUID(), name: "Chicken Noodle Soup", descriptio: "Comforting chicken soup with noodles and vegetables.", cookingTime: "20 min", difficulty: "Hard", ingredients: ["Chicken", "Noodles", "Carrots", "Celery", "Onion", "Garlic", "Salt", "Pepper"], imageName: "receiptPhoto4", steps: ["In a large pot, heat some oil and saute chopped onions, carrots, and celery until soft. Add garlic, then pour in chicken broth.", "Add chicken pieces (breast or thighs) and bring to a boil. Reduce heat and simmer until the chicken is cooked through. Remove the chicken, shred it, and return it to the pot. Stir in egg noodles or pasta and cook until tender.", "Add salt, pepper, and fresh herbs (like parsley or thyme) to taste. Serve hot with bread or crackers."])),
        Reward(title: "Chicken Caesar Salad", descriptionn: "Classic Caesar salad with grilled chicken.", imageName: "receiptPhoto5", price: 1500, detail: RewardDetail( id: UUID(), name: "Chicken Caesar Salad", descriptio: "Crisp romaine, grilled chicken, croutons, and Caesar dressing.", cookingTime: "15 min", difficulty: "Easy", ingredients: ["Romaine Lettuce", "Grilled Chicken", "Croutons", "Parmesan Cheese", "Caesar Dressing"], imageName: "receiptPhoto5", steps: [ "Grill chicken and slice into strips.", "Chop romaine lettuce and place in a bowl.", "Add croutons, cheese, and chicken on top.", "Drizzle Caesar dressing and toss lightly before serving."])),

        Reward(title: "Eggs Benedict", descriptionn: "Poached eggs with hollandaise sauce on toasted bread.",imageName: "receiptPhoto6", price: 4000, detail: RewardDetail(id: UUID(), name: "Eggs Benedict", descriptio: "Classic breakfast dish with silky hollandaise sauce.", cookingTime: "25 min", difficulty: "Hard", ingredients: ["Eggs", "Butter", "Lemon Juice", "Bread", "Ham", "Salt", "Pepper"], imageName: "receiptPhoto6", steps: ["Toast bread and prepare ham slices.", "Poach the eggs until whites are set but yolks remain runny.", "Melt butter and mix with egg yolks and lemon juice to make hollandaise sauce.", "Place ham and poached eggs on bread.", "Pour hollandaise sauce on top and serve."])),
        
        Reward(title: "Chicken Egg Muffins", descriptionn: "Mini baked egg and chicken muffins for breakfast.", imageName: "receiptPhoto7", price: 2500, detail: RewardDetail(id: UUID(), name: "Chicken Egg Muffins", descriptio: "Portable egg muffins baked with diced chicken, cheese, and vegetables.", cookingTime: "30 min", difficulty: "Medium", ingredients: ["Eggs", "Cooked Chicken", "Cheese", "Spinach", "Bell Peppers", "Salt", "Pepper"],imageName: "receiptPhoto7", steps: ["Preheat oven to 180°C (350°F).", "Dice chicken and vegetables.", "Whisk eggs with salt and pepper.", "Grease muffin tin and fill each cup with chicken, vegetables, and cheese.", "Pour egg mixture over each muffin cup.", "Bake for 20–25 minutes until eggs are set.", "Cool slightly and remove from tin."]))
    ]
    
    @Published var purchasedRewards: Set<String>
    @Published var score: Int {
        didSet {
            UserDefaults.standard.set(score, forKey: "score")
        }
    }
    init () {
        self.score = UserDefaults.standard.integer(forKey: "score")
        self.purchasedRewards = Set(UserDefaults.standard.stringArray(forKey: "purchasedRewards") ?? [])
    }
    func canBuy(_ reward: Reward) -> Bool {
        return score >= reward.price
    }
    
    func buy(_ reward: Reward) -> Bool {
        guard canBuy(reward) else { return false }
        score -= reward.price
        purchasedRewards.insert(reward.title)
        UserDefaults.standard.set(Array(purchasedRewards), forKey: "purchasedRewards")
        return true
    }
}
struct Reward: Identifiable {
    let id = UUID()
    let title: String
    let descriptionn: String
    let imageName: String
    let price: Int
    let detail: RewardDetail?
}
struct RewardDetail: Identifiable {
    let id: UUID
    let name: String
    let descriptio: String
    let cookingTime: String
    let difficulty: String
    let ingredients: [String]
    let imageName: String
    let steps: [String]
}
