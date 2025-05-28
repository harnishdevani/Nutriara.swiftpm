import SwiftUI

struct FoodItem: Identifiable {
    let id = UUID()
    let emoji: String
    let isHealthy: Bool
    var x: CGFloat
    var y: CGFloat = 0
    
    init(emoji: String, isHealthy: Bool, screenWidth: CGFloat) {
        self.emoji = emoji
        self.isHealthy = isHealthy
        self.x = CGFloat.random(in: 50...screenWidth - 50)
    }
}
