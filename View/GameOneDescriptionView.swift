import SwiftUI

struct GameOneDescriptionView: View {
    
    @State var secondView: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                Image(secondView ? "game_one_description_background2" : "game_one_description_background1")
                    .resizable()
                    .ignoresSafeArea(.all, edges: .all)
                
                if secondView {
                    NavigationLink(
                        destination: {
                            GameOneView()
                        }, label: {
                            Text("START")
                                .padding(EdgeInsets(top: 20, leading: 32, bottom: 20, trailing: 32))
                                .foregroundColor(.white)
                                .font(.custom("PoetsenOne-Regular", size: 32))
                                .background(
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .foregroundColor(.pink)
                                )
                            .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.9)
                        }
                    )
                } else {
                    Button {
                        secondView = true
                    } label: {
                        Text("NEXT")
                            .padding(EdgeInsets(top: 20, leading: 32, bottom: 20, trailing: 32))
                            .foregroundColor(.white)
                            .font(.custom("PoetsenOne-Regular", size: 32))
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundColor(.pink)
                            )
                    }
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.9)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        
        
    }
}
