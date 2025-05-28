import SwiftUI

struct GameOverScreen: View {
    let score: Int
    let restartGame: () -> Void
    let goBack: () -> Void
    
    var body: some View {
        ZStack {
            Image("bg_gameover")
                .resizable()
                .opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    BackButton(action: goBack)
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                Image("alex_sad")
                    .resizable()
                    .frame(width: 270, height: 438)
                    .padding()
                
                Text("Oh no! Alex's glucose level is out of balance!")
                    .font(CustomFont.font(.bold, size: 32))
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                    .shadow(radius: 5)
                
                Text("Final Score: \(score)")
                    .font(CustomFont.font(.regular, size: 24))
                    .foregroundColor(.black)
                    .padding()
                    .shadow(radius: 3)
                
                Button(action: restartGame) {
                    Text("Try Again")
                        .font(CustomFont.font(.bold, size: 24))
                        .bold()
                        .padding()
                        .background(Color.teal)
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
        }
    }
}

