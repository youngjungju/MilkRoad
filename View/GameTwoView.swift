import SwiftUI
import SpriteKit

struct GameTwoView: View {
    @State private var showingEndDialog = false
    @State private var navigateToStoryView = false

    var body: some View {
        VStack {
            SpriteView(scene: GameTwoScene(size: UIScreen.main.bounds.size))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
                            Text("Go to MAP")
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
            
            if navigateToStoryView {
                NavigationLink(destination: StoryThreeView(), isActive: $navigateToStoryView) {
               }
           }
        }
    }
}
