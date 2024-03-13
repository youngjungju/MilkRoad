import SwiftUI

struct BackgroundModel: View {
    
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .ignoresSafeArea(.all, edges: .all)
    }
}
