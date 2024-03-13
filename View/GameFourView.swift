import SwiftUI
import SpriteKit

struct GameFourView: View {
    @State private var showingEndDialog = false
    @State private var showingReplayDialog = false
    @State private var navigateToStoryView = false
    @State private var navigateToGameView = false
    
    var scene: SKScene {
        let scene = GameFourScene(size: CGSize(width: 400, height: 800))
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $showingEndDialog) {
                VStack {
                    Text("Great!")
                        .font(.custom("PoetsenOne-Regular", size: 36))
                    Image("cow_3")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(10)
                    Button {
                        navigateToStoryView = true
                        showingEndDialog = false
                    } label: {
                        Text("END")
                            .padding(EdgeInsets(top: 20, leading: 32, bottom: 20, trailing: 32))
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 32))
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundColor(.pink)
                            )
                    }
                }
                .padding(30)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("Success"))) { _ in
                showingEndDialog = true
            }
            .sheet(isPresented: $showingReplayDialog) {
                VStack {
                    Text("It's okay, we can do it again")
                        .font(.custom("PoetsenOne-Regular", size: 36))
                    Image("cow_4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(10)
                    Button {
                        navigateToGameView = true
                        showingReplayDialog = false
                    } label: {
                        Text("TRY AGAIN")
                            .padding(EdgeInsets(top: 20, leading: 32, bottom: 20, trailing: 32))
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 32))
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundColor(.pink)
                            )
                    }
                }
                .padding(30)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReplayGame"))) { _ in
                showingReplayDialog = true
            }
        
            if navigateToStoryView {
                NavigationLink(destination: OutroView(), isActive: $navigateToStoryView) {
               }
           }
        
            if navigateToGameView {
                NavigationLink(destination: GameFourView(), isActive: $navigateToGameView) {
               }
           }
    }
}

struct SpriteView: UIViewRepresentable {
    let scene: SKScene

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.presentScene(scene)
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}



struct GameFourView_Previews: PreviewProvider {
    static var previews: some View {
        GameFourView()
    }
}
