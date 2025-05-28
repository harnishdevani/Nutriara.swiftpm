import SwiftUI
import Combine

struct ContentView: View {
    @State private var currentScreen: GameScreenType = .welcome
    @State private var playerX: CGFloat = 0
    @State private var foods: [FoodItem] = []
    @State private var glucoseLevel: Double = 50
    @State private var score: Int = 0
    @State private var fallDuration: Double = 3
    @State private var storyText: String = "Welcome to Nutriara! Help Alex survive the food rain."
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let soundPlayer = SoundPlayer()
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .welcome:
                WelcomeScreen(startInstructions: { currentScreen = .instructions })
            case .instructions:
                InstructionsScreen(
                    startGame: { currentScreen = .game },
                    goBack: { currentScreen = .welcome }
                )
            case .game:
                GameScreen(
                    playerX: $playerX,
                    foods: $foods,
                    glucoseLevel: $glucoseLevel,
                    score: $score,
                    storyText: $storyText,
                    fallDuration: $fallDuration,
                    timer: timer,
                    soundPlayer: soundPlayer,
                    endGame: { currentScreen = .gameOver },
                    victory: { currentScreen = .victory }
                )
            case .gameOver:
                GameOverScreen(
                    score: score,
                    restartGame: restartGame,
                    goBack: { currentScreen = .welcome }
                )
            case .victory:
                VictoryScreen(
                    restartGame: restartGame,
                    goBack: { currentScreen = .welcome }
                )
            }
        }
    }
    
    func restartGame() {
        playerX = UIScreen.main.bounds.width / 2
        glucoseLevel = 50
        score = 0
        foods = []
        fallDuration = 3
        storyText = "Welcome back to Nutriara! Help Alex survive the food rain."
        currentScreen = .game
    }
}
