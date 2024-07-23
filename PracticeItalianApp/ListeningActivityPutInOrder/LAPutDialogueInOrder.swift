//
//  LAPutDialogueInOrder.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/20/23.
//

import SwiftUI


struct LAPutDialogueInOrder: View {
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    
    @ObservedObject var globalModel = GlobalModel()

    @State var draggingItem: dialogueBox?
    
    @StateObject var LAPutDialogueInOrderVM: LAPutDialogueInOrderViewModel
    
    @State var isUpdating = false
    @State var reveal = false
    @State var animatingBear = false
    @State var correctChosen = false
    @State var animateInvalidEntry: Bool = false
    @State var wrongOrder = false
    @State var showUserCheck: Bool = false
    @State var showFinishedActivityPage: Bool = false
    @State var showingSheet = false
    @State var showInfoPopUp = false
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    
    @State var viewLoaded = false
    @State var positionOfBoxes: [dialogueBox] = []

    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 45), count: 1)
    
    var infoManager = InfoBubbleDataManager(activityName: "putInOrderAudio")
    
    
    var body: some View {
        GeometryReader{geo in
            if horizontalSizeClass == .compact {
                ZStack(alignment: .topLeading){
                    
                    Image("Screen Background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            Image("cypress2")
                                .resizable()
                                .scaledToFill()
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: geo.size.width * 0.1, height: geo.size.height * 0.5)
                                .offset(x: geo.size.width * 0.095, y: geo.size.height * 0.1)
                              
                        }
                    }
                    
                    VStack{
                        Spacer()
                        HStack{
                            
                            Image("cypress1")
                                .resizable()
                                .scaledToFill()
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: geo.size.width * 0.05, height: geo.size.height * 0.5)
                                .offset(x: -geo.size.width * 0.017, y: geo.size.height * 0.22)
                                
                           Spacer()
                        }
                    }
                    
                    
                    HStack(spacing: 18){
                        Button(action: {
                            showUserCheck.toggle()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        })
                        
                        Spacer()
                        
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            
                    }.padding([.leading, .trailing], 25).zIndex(1)
                    
                    if showUserCheck {
                        userCheckNavigationPopUpListeningActivity(showUserCheck: $showUserCheck)
                            .padding(.leading, 5)
                            .padding(.top, 60)
                            .zIndex(2)
                            .opacity(showUserCheck ? 1.0 : 0.0)
                    }
                    
        
                        
                        
                        
                        VStack(spacing: 0){
                            VStack{
                                HStack(spacing: 0){
                                    Button(action: {
                                        withAnimation(Animation.spring()){
                                            showingSheet.toggle()
                                        }
                                    }, label: {
                                        Image(systemName: "newspaper")
                                            .font(.system(size: 35))
                                            .foregroundColor(.black)
                                            .edgesIgnoringSafeArea(.all)
                                            .frame(width: 35, height: 35)
                                            
                                    }).offset(y: 8)
                                    Spacer()
                                    Text("Rearrange in Order")
                                        .font(Font.custom("Georgia", size: geo.size.height * 0.028))
                                        .padding(.bottom, 15)
                                        .padding(.top, 30)
                                    
                                    PopOverView(textIn: "Listen to the individual audio segments from the original story. Try to put them in the correct order by clicking and holding down on the boxes and dragging them to the desired position.", infoBubbleColor: Color.black, frameHeight: CGFloat(180), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch)
                                        .offset(y: 7)
                                        .padding(.trailing, geo.size.width * 0.085)
                                }
   
                            }.padding(.top, 40)
                            ScrollView{
                                
                                VStack(spacing: 20){

                                    
                                    
                                    ForEach(LAPutDialogueInOrderVM.dialogueBoxes){ item in
                                        
                                        HStack{
                                            Text(String(item.initialPosition))
                                                .font(Font.custom("Georgia", size: geo.size.height * 0.032))
                                             
                                            
                                            dialogueBoxView(dialogueBox: item, dialogueText: item.dialogueText, initialBoxPositions: positionOfBoxes)
                                                .frame(width: geo.size.width * 0.81, height: 70)
                                                .padding([.top, .bottom], 2)
                                                .padding([.leading, .trailing], 5)
                                                .contentShape([.dragPreview], RoundedRectangle(cornerRadius: 12))
                                            /*.background(item.positionWrong ? Color("terracotta").opacity(0.95) : .white)*/ //Color("themeGray"))
                                            //.cornerRadius(1)
                                            //                                            .shadow(radius: 1.5)
                                            /* .opacity(item.id == draggingItem?.id && isUpdating ? 1.0 : 1)*/ // <- HERE
                                                .onDrag {
                                                    draggingItem = item
                                                    return NSItemProvider(contentsOf: URL(string: "\(item.id)"))!
                                                }preview: {
                                                    Color.gray.opacity(0.01)
                                                        .shadow(radius: 1)
                                                        
                                                }
                                                .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: item, items: $LAPutDialogueInOrderVM.dialogueBoxes, draggingItem: $draggingItem))
                                        }
                                            
                                       
                                            
                                        }
                                 
                                    
                                }.animation(.easeIn(duration: reveal ? 2.5 : 0.75), value: LAPutDialogueInOrderVM.dialogueBoxes)
                                    .padding(.top, 40)
                                    .padding(.bottom, 10)
                                    .frame(width: geo.size.width)
                                
                                
                            }.scrollDisabled(true).frame(width: geo.size.width)
                            
                            HStack{
                                Spacer()
                             
                                
                                Button(action: {
                                    var tempLoopCounter = 0
                                    var tempCheck = false
                                    var wrongOrder = false
                                    
                                    if reveal == true {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            showFinishedActivityPage = true
                                        }
                                    }else{
                                        
                                        while tempLoopCounter <= LAPutDialogueInOrderVM.dialogueBoxes.count-1 {
                                            
                                            if LAPutDialogueInOrderVM.dialogueBoxes[tempLoopCounter].position != tempLoopCounter+1 {
                                                withAnimation(.spring()){
                                                    LAPutDialogueInOrderVM.dialogueBoxes[tempLoopCounter].positionWrong = true
                                                    
                                                    
                                                }
                                                tempCheck = true
                                            }else{
                                                withAnimation(.spring()){
                                                    LAPutDialogueInOrderVM.dialogueBoxes[tempLoopCounter].positionWrong = false
                                                }
                                            }
                                            
                                            tempLoopCounter += 1
                                            
                                        }
                                        
                                        if tempCheck {
                                            wrongOrder = true
                                        }
                                        
                                        
                                        if !wrongOrder {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                showFinishedActivityPage = true
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                correctChosen = false
                                            }
                                            correctChosen = true
                                            
                                            SoundManager.instance.playSound(sound: .correct)
                                        }else{
                                            SoundManager.instance.playSound(sound: .wrong)
                                            animateView()
                                        }
                                    }
                                    
                                }, label: {
                                    Text(reveal ? "Continue" : "Check")
                                        .font(Font.custom("Georgia", size: 18)).padding(.bottom, 4)
                                        .padding(.top, 3)
                                        .foregroundColor(.black)
                                        .frame(width: 110, height: 35)
                                        //.background(Color("terracotta"))
                                        .cornerRadius(15)
                                       // .shadow(radius: 5)
           
                                }).buttonStyle(ThreeDButton(backgroundColor: "white")) .frame(width: 110, height: 35)
                                if !reveal {
                                Spacer()
                                
                               
                                    Button(action: {
                                        
                                        for var item in LAPutDialogueInOrderVM.dialogueBoxes {
                                            item.positionWrong = false
                                        }
                                        
                                        wrongOrder = false
                                        
                                        LAPutDialogueInOrderVM.dialogueBoxes = LAPutDialogueInOrderVM.correctOrder
                                        reveal = true
                                        
                                        
                                        
                                    }, label: {
                                        Text("Reveal")
                                            .font(Font.custom("Georgia", size: 18))
                                            .foregroundColor(.black)
                                            .frame(width: 110, height: 35)
                                        //.background(Color("terracotta"))
                                            .cornerRadius(15)
                                        //.shadow(radius: 5)
                                        
                                    }).buttonStyle(ThreeDButton(backgroundColor: "white")) .frame(width: 110, height: 35)
                                }
                                Spacer()
                            }.padding(.bottom, 10)
                            
                        }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.95)
                            .padding([.leading, .trailing], geo.size.width * 0.05)
                            .padding(.top, 10)
                            .offset(x: animateInvalidEntry ? -30 : 0)
                  
                    
                    
                    
                    NavigationLink(destination: ActivityCompleteAudioActivity(listeningActivityVM: listeningActivityVM, finishedAudioName: audioManager.currentAudioStoryPlaying),isActive: $showFinishedActivityPage,label:{}
                    ).isDetailLink(false).id(UUID())
                    
                }.navigationBarBackButtonHidden(true)
                    .sheet(isPresented: $showingSheet) {
                        SheetViewListeningActivity(listeningActivityVM: listeningActivityVM)
                    }
                    .onDisappear{
                        infoManager.updateCorrectInput(activity: infoManager.getActivityFirstLaunchData())
                    }
                    .onAppear{
                        
                        
                        positionOfBoxes = LAPutDialogueInOrderVM.dialogueBoxes
                        
                        withAnimation(.spring()){
                            animatingBear = true
                            
                            
                        }
                        
                    
                    LAPutDialogueInOrderVM.dialogueBoxes.shuffle()
                    
                    if !viewLoaded{
                        for i in 0...LAPutDialogueInOrderVM.dialogueBoxes.count - 1 {
                            LAPutDialogueInOrderVM.dialogueBoxes[i].initialPosition = i + 1
                        }
                        
                        for i in 0...LAPutDialogueInOrderVM.correctOrder.count - 1 {
                            
                            for x in 0...LAPutDialogueInOrderVM.dialogueBoxes.count - 1 {
                                if LAPutDialogueInOrderVM.correctOrder[i].dialogueText ==  LAPutDialogueInOrderVM.dialogueBoxes[x].dialogueText {
                                    
                                    LAPutDialogueInOrderVM.correctOrder[i].initialPosition = LAPutDialogueInOrderVM.dialogueBoxes[x].initialPosition
                                    
                                    
                                }
                            }
                                
                            
                        }
                    }
                    
                    viewLoaded = true
                    
//                    if !reveal {
//                        LAPutDialogueInOrderVM.dialogueBoxes.shuffle()
//                        
//                        for i in 0...LAPutDialogueInOrderVM.dialogueBoxes.count - 1 {
//                            LAPutDialogueInOrderVM.dialogueBoxes[i].position = i + 1
//                        }
//                    }
                }
            }else{
                LAPutDialogueInOrderIPAD(LAPutDialogueInOrderVM: LAPutDialogueInOrderVM)
            }
        }
    }
    
  
    
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
            animateInvalidEntry = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
                animateInvalidEntry  = false
            }
        }
    }
    
    struct dialogueBoxView: View {
        var dialogueBox: dialogueBox
        @State private var value: Double = 0.0
        @State private var isEditing: Bool = false
        var isPreview: Bool = false
        @StateObject var audioManager = AudioManager()
        var dialogueText: String
        let timer = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
        var initialBoxPositions: [dialogueBox]
        var body: some View {
            GeometryReader{geo in
                ZStack{
                    VStack{
                        if let player = audioManager.player  {
                            VStack{
                                
                                
                                HStack{
                                    
                                    let tortoiseColor: Color = audioManager.isSlowPlayback ? .teal : .black
                                    
                                    
                                    PlaybackControlButton(systemName: audioManager.isPlaying && player.currentTime != 0 ? "pause.circle.fill" : "play.circle.fill", fontSize: 34) {
                                        audioManager.playPlause()
                                        
                                        
                                    }.padding(.bottom, 10)
                                        .padding(.leading, 9)
                                        
//                                        .overlay{
//                                        ZStack{
//                                            Circle()
//                                                .stroke(lineWidth: 6.0)
//                                                .opacity(0.20)
//                                                .foregroundColor(Color.gray)
//                                            
//                                            
//                                            Circle()
//                                                .trim(from: 0.0, to: CGFloat(min(self.value / player.duration, 1.0)))
//                                                .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round, lineJoin: .round))
//                                                .foregroundColor(Color("ForestGreen"))
//                                                .rotationEffect(Angle(degrees: 270))
//                                                .animation(.easeInOut(duration: 2.0))
//                                            
//                                        }
//                                    }.padding(.leading, 15)
                                    
                                    
                                    PlaybackControlButton(systemName: "tortoise.fill", color: tortoiseColor){
                                        audioManager.slowSpeed()
                                    }.padding(.trailing, 8).scaleEffect(0.75).padding(.leading, 5).padding(.bottom, 10)
                                    
                                    VStack(spacing: 0){
                                        
                                        Slider(value: $value, in: 0...player.duration) { editing
                                            in
                                            
                                            print("editing", editing)
                                            isEditing = editing
                                            
                                            if !editing {
                                                player.currentTime = value
                                            }
                                        }.controlSize(.mini)
                                        .scaleEffect(1)
                                        .frame(width: geo.size.width * 0.5, height: 10)
                                        .tint(.orange)
                                    
                                        
                                        
                                        HStack{
                                            Text(DateComponentsFormatter.positional
                                                .string(from: player.currentTime) ?? "0:00").font(.system(size: 13))
                                            
                                            Spacer()
                                            
                                            Text(DateComponentsFormatter.positional
                                                .string(from: player.duration - player.currentTime) ?? "0:00").font(.system(size: 13))
                                            
                                        }.padding(13)
                                    }.padding(.top, 15)
                                    
//                                    Spacer()
//                                    
//                                    Text("Audio: ")
//                                        .font(Font.custom("Georgia", size: 17))
//                                    
//                                    Spacer()
                                }

                                
                                
                            }
                            
                        }
                        
                    }.frame(width: geo.size.width, height: geo.size.height)
                        .background{
                            ZStack{
                                if dialogueBox.positionWrong {
                                    
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("darkTerracotta"))
                                    
                                    
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("terracotta"))
                                        .offset(y: -5)
                                    
                                }else{
                                    
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                                    
                                    
                                    RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                        .offset(y: -5)
                                    
                                    
                                }
                            }.shadow(radius:1.5)
                        }
    

                      
                }.scaleEffect(dialogueBox.positionWrong ? 1.03 : 1.0)
                
                    .onDisappear(perform: {audioManager.player?.stop()})
                    .navigationBarBackButtonHidden(true)
                    .onAppear{
                        
                        audioManager.startPlayer(track: dialogueText, isPreview: true)
                        
                    }
                    .onReceive(timer) { _ in
                        guard let player = audioManager.player, !isEditing else {return}
                        value = player.currentTime
                        
                        
                    }
            }
        }
    }
    
}
                   
    
struct ProgressBar: View {
    @Binding var progress: CGFloat
    var color: Color = Color.green
    
    
    var body: some View{
        ZStack{
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.20)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 2.0))
                      
        }
    }
}





struct LAPutDialogueInOrder_Previews: PreviewProvider {
    static let listeningActivityVM = ListeningActivityViewModel(audioAct: audioActivty.cosaDesidera)
    static let LAPutDialogueInOrderVM = LAPutDialogueInOrderViewModel(dialoguePutInOrderVM: dialoguePutInOrderObj(stringArray: ListeningActivityElement.cosaDesidera.putInOrderDialogueBoxes[0].fullSentences))
    static var previews: some View {
        LAPutDialogueInOrder(LAPutDialogueInOrderVM: LAPutDialogueInOrderVM, listeningActivityVM: listeningActivityVM)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
            .environmentObject(GlobalModel())
    }
}
