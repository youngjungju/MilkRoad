import SwiftUI
import SpriteKit

struct GameThreeView: View {
    @State private var objects = [Object]()
    @State private var boxes = [Box(type: .square), Box(type: .triangle)]
    @State private var hearts = 3
    @State private var navigateToStoryView = false
    @State private var showingEndDialog = false
    @State private var showingReplayDialog = false
    @State private var navigateToGameView = false


    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("game_three_background")
                    .resizable()
                    .ignoresSafeArea(.all, edges: .all)
                VStack {
                    HStack {
                        HStack {
                            ForEach(0..<hearts, id: \.self) { _ in
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.red)
                                    .padding(5)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Spacer()

                    VStack {
                        ForEach(self.objects.indices, id: \.self) { index in
                            Image(self.objects[index].type.rawValue)
                                .resizable()
                                .frame(width: 80, height: 160)
                                .offset(y: CGFloat(index) - 200 )
                                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))

                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    .animation(.easeInOut(duration: 1.0))
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            self.putObjectIntoBox(index: 0)
                        }) {
                            Image(self.boxes[0].type.rawValue)
                                .resizable()
                                .frame(width: 100, height: 200)
                                .shadow(color: Color.gray, radius: 50, x: 0, y: 0)
                        }
                        .padding(150)
                        Spacer()
                        Button(action: {
                            self.putObjectIntoBox(index: 1)
                        }) {
                            Image(self.boxes[1].type.rawValue)
                                .resizable()
                                .frame(width: 100, height: 200)
                                .shadow(color: Color.gray, radius: 50, x: 0, y: 0)
                            
                        }
                        .padding(150)
                    }
                }
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
                    .shadow(radius: 0)
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
                            showingReplayDialog = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    navigateToGameView = true
                                }
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
                    .shadow(radius: 0)
                }
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ReplayGame"))) { _ in
                    showingReplayDialog = true
                }
            }
            .onAppear {
                self.initializeGame()
            }
            
            
            if navigateToStoryView {
                NavigationLink(destination: StoryFourView(), isActive: $navigateToStoryView) {
               }
           }
        
            if navigateToGameView {
                NavigationLink(destination: GameThreeView(), isActive: $navigateToGameView) {
               }
           }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    func initializeGame() {
        for _ in 1...15 {
            let type = Bool.random() ? ObjectType.square : ObjectType.triangle
            self.objects.append(Object(type: type))
        }

    }
    

    func success() {
        self.showingEndDialog = true
    }
    
    func gameOver() {
        DispatchQueue.main.async {
            self.showingReplayDialog = true
        }
    }

    func putObjectIntoBox(index: Int) {
        if let lastObject = self.objects.last {
            if lastObject.type != self.boxes[index].type {
                self.hearts -= 1
                if self.hearts == 0 {
                    self.gameOver()
                }
            } else {
                self.boxes[index].objects.append(lastObject)
                self.objects.removeLast()
                if self.objects.isEmpty {
                    self.success()
                }
            }
        }
    }
}

enum ObjectType: String {
    case square = "milk_1"
    case triangle = "milk_2"
}

struct Object {
    let type: ObjectType
}

struct Box {
    let type: ObjectType
    var objects = [Object]()
}

