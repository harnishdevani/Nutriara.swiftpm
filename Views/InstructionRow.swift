import SwiftUI

struct InstructionRow: View {
    let emoji: String
    let text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Text(emoji)
                .font(.system(size: 30))
            Text(text)
                .font(CustomFont.font(.regular, size: 24))
        }
        .padding(.vertical, 5)
    }
}
