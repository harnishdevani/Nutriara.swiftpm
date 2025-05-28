import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.title3)
                Text("Back")
                    .font(.title3)
            }
            .padding(10)
            .background(Color.white.opacity(0.9))
            .foregroundColor(.green)
            .cornerRadius(20)
            .shadow(radius: 3)
        }
    }
}
