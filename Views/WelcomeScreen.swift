import SwiftUI

struct WelcomeScreen: View {
    let startInstructions: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            VStack{
                Spacer()
                
                Image("alex_normal")  
                    .resizable()
                    .frame(width: 370, height: 638)
            }
            Spacer()
            VStack {
                
                Text("Hello, Join Alex on an exciting journey to maintain a healthy lifestyle!")
                    .font(CustomFont.font(.regular, size: 34))
                    .foregroundColor(.black)
                    .padding(.top, 90)
                    .frame(width: 703)
                    .shadow(radius: 1)
                Spacer()
                
                
                
                Button(action: startInstructions) {
                    Text("Start Adventure")
                        .font(CustomFont.font(.bold, size: 24))
                        .bold()
                        .padding()
                        .frame(width: 200, height: 78)
                        .background(Color.teal)
                        .foregroundColor(.primary)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .background(Image("bg")
            .resizable()
            .scaledToFill())
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
}



