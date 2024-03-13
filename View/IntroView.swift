import SwiftUI

struct IntroView: View {
    
    @State var secondView: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                Image("intro_background")
                    .resizable()
                    .ignoresSafeArea(.all, edges: .all)
                
                VStack {
                    VStack {
                        Image(secondView ? "intro_popup2" : "intro_popup1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.5)
                            .offset(x: geometry.size.width * 0.1, y: geometry.size.height * 0.1)
                        
                        Image(secondView ? "cow_2" : "cow_1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.4)
                            .offset(x: -(geometry.size.width * 0.2), y: geometry.size.height * 0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.45, blendDuration: 0.5), value: secondView)
                    }
                }
                
                
                
                if secondView {
                    NavigationLink(
                        destination: {
                            StoryOneView()
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
