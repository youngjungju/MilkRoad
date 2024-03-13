import SwiftUI

struct ContentView: View {
    @State private var animationAmount: Double = 1.0

    var body: some View {
        GeometryReader { geometry in
            NavigationLink(
                destination: IntroView(),
                label: {
                    ZStack {
                        Image("start_background")
                            .resizable()
                            .ignoresSafeArea(.all, edges: .all)
                        VStack {
                            Spacer()
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.5)
                                .padding(.bottom, 50)
                            Text("Touch to Start")
                                .foregroundColor(.white)
                                .font(.custom("PoetsenOne-Regular", size: 36))
                                .opacity(self.animationAmount)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        self.animationAmount = 0.0
                                    }
                                }
                            Spacer()
                            Text("It's more fun to play the game in landscape:)")
                                .foregroundColor(.black)
                                .font(.custom("PoetsenOne-Regular", size: 24))
                        }
                        .padding(geometry.size.height * 0.05)
                    }
                    .ignoresSafeArea()
                }
            )
        }
    }
}
