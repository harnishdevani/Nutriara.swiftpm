import SwiftUI
import Combine
import Foundation

struct GameMessageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(CustomFont.font(.regular, size: 18))
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(.blue)
            .background(Color.secondary.opacity(1))
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

extension View {
    func gameMessageStyle() -> some View {
        modifier(GameMessageModifier())
    }
}

struct GameScreen: View {
    @Binding var playerX: CGFloat
    @Binding var foods: [FoodItem]
    @Binding var glucoseLevel: Double
    @Binding var score: Int
    @Binding var storyText: String
    @Binding var fallDuration: Double
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    let soundPlayer: SoundPlayer
    let endGame: () -> Void
    let victory: () -> Void
    
    @State private var screenHeight: CGFloat = UIScreen.main.bounds.height
    @State private var screenWidth: CGFloat = UIScreen.main.bounds.width
    @State private var dragStartX: CGFloat = 0
    @State private var stableGlucoseTime: Int = 0
    @State private var showInstructions: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    // Info Button and Game Message in same row
                    HStack(spacing: 10) {
                        Text(storyText)
                            .gameMessageStyle()
                            .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            showInstructions = true
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 25))
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color.secondary.opacity(1))
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    HStack {
                        // Score display with updated color
                        Text("Score: ")
                            .font(CustomFont.font(.bold, size: 24))
                            .bold()
                            .foregroundColor(.black)
                        Text("\(score)")
                            .font(CustomFont.font(.bold, size: 28))
                            .bold()
                            .foregroundColor(.black) // Score value in yellow
                        
                        Spacer()
                        
                        // Glucose display with updated color
                        Text("Glucose: ")
                            .font(CustomFont.font(.bold, size: 24))
                            .bold()
                            .foregroundColor(.black)
                        Text("\(Int(glucoseLevel))")
                            .font(CustomFont.font(.bold, size: 28))
                            .bold()
                            .foregroundColor(
                                glucoseLevel > 75 ? .red :
                                    (glucoseLevel < 25 ? .orange : .green)
                            ) // Glucose value color changes based on level
                    }
                    .padding()
                    
                    Text("Stable Time: \(stableGlucoseTime)s")
                        .font(CustomFont.font(.regular, size: 18))
                        .foregroundColor(stableGlucoseTime > 0 ? .green : .gray)
                    
                    ProgressView(value: glucoseLevel, total: 100)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 10)
                        .padding(.horizontal)
                        .tint(glucoseLevel > 75 ? .red : (glucoseLevel < 25 ? .orange : .blue))
                    
                    ZStack(alignment: .bottom) {
                        ZStack {
                            ForEach(foods) { food in
                                Text(food.emoji)
                                    .font(.system(size: 40))
                                    .position(x: food.x, y: food.y)
                                    .animation(.linear(duration: fallDuration), value: food.y)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        Text("🧺")
                            .font(.system(size: 50))
                            .offset(x: playerX - geometry.size.width/2)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        if dragStartX == 0 {
                                            dragStartX = playerX - value.translation.width
                                        }
                                        let dampening: CGFloat = 1
                                        let newX = dragStartX + (value.translation.width * dampening)
                                        playerX = min(max(newX, 50), geometry.size.width - 50)
                                    }
                                    .onEnded { _ in
                                        dragStartX = 0
                                    }
                            )
                            .padding(.bottom, 20)
                    }
                }
                .onAppear {
                    screenWidth = geometry.size.width
                    screenHeight = geometry.size.height
                    playerX = geometry.size.width / 2
                    stableGlucoseTime = 0
                }
                .onReceive(timer) { _ in
                    dropFood()
                    checkCollisions()
                    checkStableGlucose()
                }
                
                if showInstructions {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showInstructions = false
                        }
                    
                    VStack(spacing: 20) {
                        Text("How to Play")
                            .font(CustomFont.font(.bold, size: 30))
                            .bold()
                            .foregroundColor(.black)
                            .padding()
                            .shadow(radius: 5)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            InstructionRow(emoji: "🧺", text: "Move the basket left and right to catch food")
                            InstructionRow(emoji: "🍎", text: "Catch healthy foods to lower glucose")
                            InstructionRow(emoji: "🍔", text: "Avoid junk food that raises glucose")
                            InstructionRow(emoji: "⚖️", text: "Keep glucose level between 25-75 for 1 minute to win!")
                        }
                        
                        .foregroundStyle(.black)
                        
                        
                        Button("Close") {
                            showInstructions = false
                        }
                        .font(CustomFont.font(.bold, size: 20))
                        .padding()
                        .background(Color.teal)
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
            .background(Image("bg"))
        }
    }
    
    private func checkStableGlucose() {
        if glucoseLevel >= 25 && glucoseLevel <= 75 {
            stableGlucoseTime += 1
            if stableGlucoseTime >= 60 {
                victory()
            }
        } else {
            stableGlucoseTime = 0
        }
        
        if stableGlucoseTime > 0 {
            storyText = "Keep it up! Glucose stable for \(stableGlucoseTime) seconds!"
        }
    }
    
    @MainActor
    func dropFood() {
        let foodOptions = [
            FoodItem(emoji: "🍏", isHealthy: true, screenWidth: screenWidth),
            FoodItem(emoji: "🥦", isHealthy: true, screenWidth: screenWidth),
            FoodItem(emoji: "🍔", isHealthy: false, screenWidth: screenWidth),
            FoodItem(emoji: "🍩", isHealthy: false, screenWidth: screenWidth),
            FoodItem(emoji: "🥕", isHealthy: true, screenWidth: screenWidth),
            FoodItem(emoji: "🍟", isHealthy: false, screenWidth: screenWidth)
        ]
        
        if foods.count < 5 {
            let newFood = foodOptions.randomElement()!
            foods.append(newFood)
        }
        
        withAnimation(.linear(duration: fallDuration)) {
            foods = foods.map { food in
                var newFood = food
                newFood.y += 100
                return newFood
            }
        }
        
        foods = foods.filter { $0.y < screenHeight + 100 }
    }
    
    @MainActor
    func checkCollisions() {
        let basketY = screenHeight - 110
        let catchRange: CGFloat = 50
        
        foods = foods.filter { food in
            if abs(food.x - playerX) < catchRange && abs(food.y - basketY) < catchRange {
                if food.isHealthy {
                    withAnimation {
                        glucoseLevel = max(0, glucoseLevel - 10)
                    }
                    score += 10
                    soundPlayer.playSound("healthy")
                    storyText = "Great! \(food.emoji) gave Alex energy!"
                } else {
                    withAnimation {
                        glucoseLevel = min(100, glucoseLevel + 15)
                    }
                    score -= 5
                    soundPlayer.playSound("unhealthy")
                    storyText = "Oh no! \(food.emoji) made Alex sluggish..."
                }
                
                if glucoseLevel <= 0 || glucoseLevel >= 100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        endGame()
                    }
                }
                
                return false
            }
            return true
        }
    }
}
