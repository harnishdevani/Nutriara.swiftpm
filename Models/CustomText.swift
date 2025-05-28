import SwiftUI

struct CustomFont {
    static let regular = "systemfont"  // Replace with your custom font name
    static let bold = "systemfont"        // Replace with your custom font name
    
    static func font(_ style: FontStyle, size: CGFloat) -> Font {
        switch style {
        case .regular:
            return .custom(regular, size: size)
        case .bold:
            return .custom(bold, size: size)
        }
    }
    
    enum FontStyle {
        case regular, bold
    }
}
