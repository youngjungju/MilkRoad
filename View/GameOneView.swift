import SwiftUI
import SpriteKit

struct GameOneView: View {
    @State private var showingEndDialog = false
    @State private var navigateToStoryView = false
    
    var body: some View {
        GameViewControllerRepresentable()
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
                NavigationLink(destination: StoryTwoView(), isActive: $navigateToStoryView) {
               }
           }

    }
}

struct GameViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let scene = GameOneScene(size: CGSize(width: 400, height: 800))
        scene.scaleMode = .fill
        let vc = UIViewController()
        let skView = SKView()
        skView.presentScene(scene)
        vc.view.addSubview(skView)
        skView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: vc.view.topAnchor),
            skView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            skView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            skView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor)
        ])
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
