import SwiftUI

struct StoryOneView: View {
    let sunGraph = SunGraph()

    @State var alongTrackDistancePercent = [0.0, 0.35, 0.65, 1]
    @State private var isUnlocked = [true,false, false, false]
    @State private var isActive = [false, false, false, false]
    
    var body: some View {
        VStack {
            ZStack {
                BackgroundModel(imageName: "game_map_background")
                GeometryReader { proxy in
                    sunGraph
                        .stroke(style: StrokeStyle(lineWidth: 5, dash: [20, 25]))

                    createButton(number: 1, index: 0, proxy: proxy, destination: GameOneDescriptionView(), action: {
                        isUnlocked[1] = true
                    })
                    createButton(number: 2, index: 1, proxy: proxy, destination: GameTwoDescriptionView(), action: {
                        isUnlocked[2] = true
                    })
                    createButton(number: 3, index: 2, proxy: proxy, destination: GameThreeDescriptionView(), action: {
                        isUnlocked[3] = true
                    })
                    createButton(number: 4, index: 3, proxy: proxy, destination: GameFourDescriptionView(), action: {})
                }
                .frame(width: 800, height: 400)
            }
        }
        .navigationBarHidden(true)
    }
    
    func createButton<V: View>(number: Int, index: Int, proxy: GeometryProxy, destination: V, action: @escaping () -> Void) -> some View {
        Button(action: {
            if isUnlocked[index] {
                action()
                isActive[index] = true
            }
        }) {
            ZStack {
                if isUnlocked[index] {
                    NavigationLink(destination: destination, isActive: $isActive[index]) {
                        EmptyView()
                    }
                    Text("\(number)")
                        .padding(EdgeInsets(top: 20, leading: 32, bottom: 20, trailing: 32))
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .semibold, design: .default))
                        .background(
                            RoundedRectangle(cornerRadius: 50, style: .continuous)
                                .foregroundColor(.black)
                        )
                } else {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .position(
            sunGraph
                .path(in: CGRect(origin: .zero,
                                 size: CGSize(width: proxy.size.width,
                                              height: proxy.size.height)))
                .trimmedPath(from: 0,
                             to: alongTrackDistancePercent[index])
                .currentPoint ?? CGPoint(x: 0,
                                         y: proxy.size.height)
        )
    }
}

