import SwiftUI

struct InstructionsScreen: View {
    let startGame: () -> Void
    let goBack: () -> Void
    
    var body: some View {
        ZStack {
            Image("bg_instructions")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    BackButton(action: goBack)
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                Text("How to Play")
                    .font(CustomFont.font(.bold, size: 35))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                
                VStack(alignment: .leading, spacing: 15) {
                    InstructionRow(emoji: "🧺", text: "Move the basket left and right to catch food")
                    InstructionRow(emoji: "🍎", text: "Catch healthy foods to lower glucose")
                    InstructionRow(emoji: "🍔", text: "Avoid junk food that raises glucose")
                    InstructionRow(emoji: "⚖️", text: "Keep glucose level between 25-75 for 1 minute to win!")
                }
                .padding()
                .foregroundColor(Color.black)
                .background(Color.green.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Button(action: startGame) {
                    Text("Let's Play!")
                        .font(CustomFont.font(.bold, size: 24))
                        .bold()
                        .padding()
                        .background(Color.teal)
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
                .padding(.top, 30)
                
                Spacer()
            }
        }
    }
}
