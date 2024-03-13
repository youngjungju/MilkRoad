import SwiftUI

struct EndingView: View {
    
    @State var secondView: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                Image("end_background")
                    .resizable()
                    .ignoresSafeArea(.all, edges: .all)
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        
        
    }
}
