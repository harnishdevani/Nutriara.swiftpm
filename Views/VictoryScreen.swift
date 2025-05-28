import SwiftUI

struct VictoryScreen: View {
    let restartGame: () -> Void
    let goBack: () -> Void
    
    var body: some View {
        ZStack {
            Image("bg_victory")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    BackButton(action: goBack)
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                Image("alex_happy")
                    .resizable()
                    .frame(width: 270, height: 438)
                    .padding()
                
                Text("Amazing Job!")
                    .font(CustomFont.font(.bold, size: 40))
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .shadow(radius: 5)
                
                Text("Alex is feeling great thanks to your help in maintaining a balanced diet!")
                    .font(CustomFont.font(.regular, size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                    .shadow(radius: 3)
                
                Button(action: restartGame) {
                    Text("Play Again")
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
            .padding()
        }
    }
}
