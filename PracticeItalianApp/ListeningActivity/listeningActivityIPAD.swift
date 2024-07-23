//
//  listeningActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/19/23.
//

import SwiftUI


struct listeningActivityIPAD: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    var isPreview: Bool = false
    
    
    @State private var value: Double = 0.0
    @State private var isEditing: Bool = false
    @State private var showDialogueQuestions: Bool = false
    @State private var questionNumber = 0
    @State private var wrongChosen = false
    @State private var correctChosen = false
    @State private var animatingBear = false
    @State private var progress: CGFloat = 0.0
    @State var showUserCheck: Bool = false
    @State var questionsExpanded: Bool = false
    @State var isDonePlaying = false
    @State var questionBoxWidth = UIScreen.main.bounds.width
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
 
    
    
    var body: some View {
        GeometryReader{geo in
  
                ZStack(alignment: .topLeading){
                    Image("skyBackground")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .opacity(1.0)
//                    Image("verticalNature")
//                        .resizable()
//                        .scaledToFill()
//                        .edgesIgnoringSafeArea(.all)
//                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//                        .zIndex(0)
                    
                    HStack(spacing: 18){
                        Spacer()
                        NavigationLink(destination: chooseAudio(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 35))
                                .foregroundColor(.black)
                            
                            
                        })
                        
                        GeometryReader{proxy in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.gray.opacity(0.25))
                                
                                Capsule()
                                    .fill(Color.green)
                                    .frame(width: proxy.size.width * CGFloat(progress))
                            }
                        }.frame(height: 16)
                            .onChange(of: questionNumber){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(listeningActivityVM.audioAct.comprehensionQuestions.count + 1))
                            }
                        
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Spacer()
                    }.zIndex(1)
                        .padding(.top, 20)
                    
                    
                    VStack(spacing: 0){
                        VStack{
                            Image(listeningActivityVM.audioAct.ipadImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width * 0.55, height: geo.size.height * 0.25)
                                .opacity(1.0)
                                .cornerRadius(85)
                                .shadow(radius: 10)
                            
//                                ImageOnCircle(icon: listeningActivityVM.audioAct.image, radius: geo.size.width * 0.13)
//                                    .padding(.top, 10)
//                                    .padding(.bottom, 20)
                                
                            
                            
                            GroupBox{
                                
                                
                                DisclosureGroup("Questions", isExpanded: $questionsExpanded) {
                                    
                                    
                                    
                                    
                                    VStack{
                                        
                                        
                                        Text(listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].question)
                                            .font(Font.custom("Arial Hebrew", size: 22))
                                            .multilineTextAlignment(.center)
                                            .padding([.leading,.trailing], 20)
                                            .padding()
                                            .padding(.top, 5)
                                            .frame(width: geo.size.width * 0.82)
                                            .border(width: 4, edges: [.bottom], color:Color("DarkNavy"))
                                            .padding(.bottom, 10)
                                  
                                        
                                        
                                        
                                        radioButtonsLAComprehensionIPAD(correctAnswer: listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].answer, choicesIn: listeningActivityVM.audioAct.comprehensionQuestionChoices[questionNumber], totalQuestions: listeningActivityVM.audioAct.comprehensionQuestions.count, questionNumber: $questionNumber, wrongChosen: $wrongChosen, correctChosen: $correctChosen, showDialogueQuestions: $showDialogueQuestions, geoSize: $questionBoxWidth)
                                        
                                        
                                        
                                        
                                        
                                    }
                                    .frame(width: geo.size.width * 0.65)
                                    .padding(.top, 10)
                                    
                                    
                                }
                                .tint(Color.black)
                                .font(Font.custom("Arial Hebrew", size: 20))
                                .frame(width: geo.size.width * 0.65)
                           
                                
                            } .padding(.bottom, 15)
                                .padding(.top, 10)
                                .padding([.leading, .trailing], geo.size.width * 0.225)
                            
                            //                        }.background(  RoundedRectangle(cornerRadius: 10)
                            //                            .fill(Color("DarkNavy"))
                            //                            .overlay( /// apply a rounded border
                            //                                RoundedRectangle(cornerRadius: 15)
                            //                                    .stroke(.black, lineWidth: 4)
                            //                                    )
                            //                                .shadow(radius: 10)
                            //                                .padding([.leading, .trailing], 10)
                            //                                .zIndex(0))
                            
       
                        }.offset(y: geo.size.height / 7)
                            .zIndex(1)
                        
                        
                        
                        
                        
                        
                        if let player = audioManager.player {
                            VStack{
                                Text(listeningActivityVM.audioAct.title)
                                    .font(Font.custom("Futura", size: 25))
                                    .frame(width: 200, height: 80)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 20)
                                    .padding(.top, 20)
                                VStack(spacing: 0){
                                    
                                    Slider(value: $value, in: 0...player.duration) { editing
                                        in
                                        
                                        print("editing", editing)
                                        isEditing = editing
                                        
                                        if !editing {
                                            player.currentTime = value
                                        }
                                    }
                                    .scaleEffect(1.25)
                                    .frame(width: 270, height: 20)
                                    .tint(.orange)
                                    
                                    
                                    HStack{
                                        Text(DateComponentsFormatter.positional
                                            .string(from: player.currentTime) ?? "0:00")
                                        
                                        Spacer()
                                        
                                        Text(DateComponentsFormatter.positional
                                            .string(from: player.duration - player.currentTime) ?? "0:00")
                                        
                                    }.padding(5)
                                }.frame(width: geo.size.width * 0.7)
                                .padding([.leading, .trailing], 35)
                                    .offset(y: -15)
                                    .zIndex(1)
                                
                                HStack{
                                    let color: Color = audioManager.isLooping ? .teal : .black
                                    let tortoiseColor: Color = audioManager.isSlowPlayback ? .teal : .black
                                    
                                    PlaybackControlButton(systemName: "repeat", color: color) {
                                        audioManager.toggleLoop()
                                    }.padding(.leading, 20)
                                    Spacer()
                                    PlaybackControlButton(systemName: "gobackward.10") {
                                        player.currentTime -= 10
                                    }
                                    Spacer()
                                    PlaybackControlButton(systemName: audioManager.isPlaying && player.currentTime != 0 ? "pause.circle.fill" : "play.circle.fill", fontSize: 44) {
                                        audioManager.playPlause()
                                        
                                        
                                    }.padding([.top, .bottom], 3)
                                    Spacer()
                                    PlaybackControlButton(systemName: "goforward.10") {
                                        player.currentTime += 10
                                    }
                                    Spacer()
                                    
                                    PlaybackControlButton(systemName: "tortoise.fill", color: tortoiseColor){
                                        audioManager.slowSpeed()
                                    }.padding(.trailing, 20)
                                    
                                    
                                }
                                .frame(width: geo.size.width * 0.7)
                                .padding([.leading, .trailing], 15)
                                .scaleEffect(1.3)
                                .zIndex(1)
                                //.padding(.top, 5)
                                
                                
                            }.frame(maxHeight: .infinity, alignment: .bottom)
                              
                               
                        }
                        
                    }.frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                        .offset(y: -20)
                        .zIndex(1)
                   
                        
                        
                    
                    
                    
                    
                    
                }.navigationBarBackButtonHidden(true)
                    .onAppear{
                        questionBoxWidth = geo.size.width * 0.65
                        withAnimation(.spring()){
                            animatingBear = true
                        }
                        
                        audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                        
                        
                    }
                    .onReceive(timer) { _ in
                        guard let player = audioManager.player, !isEditing else {return}
                        value = player.currentTime
                        
                    
                    }
                    .onChange(of: questionNumber){ newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            correctChosen = false
                        }
                        correctChosen = true
                    }
                
                NavigationLink(destination:    listeningActivityQuestionsIPAD(isPreview: false, listeningActivityVM: listeningActivityVM),isActive: $showDialogueQuestions,label:{}
                ).isDetailLink(false)

                
            }
            
        }
        
    }

struct radioButtonsLAComprehensionIPAD: View {
    
    var correctAnswer: String
    var choicesIn: [String]
    var totalQuestions: Int

    @Binding var questionNumber: Int
    @Binding var wrongChosen: Bool
    @Binding var correctChosen: Bool
    @Binding var showDialogueQuestions: Bool
    @Binding var geoSize: CGFloat
    
    var body: some View{
        VStack(spacing: 8) {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctLAComprehensionButtonIPAD(choice: choicesIn[i], totalQuestions: totalQuestions, questionNumber: $questionNumber, correctChosen: $correctChosen, showDiag: $showDialogueQuestions, geoSize: $geoSize).padding(.bottom, 2)
                } else {
                    incorrectLAComprehensionButtonIPAD(choice: choicesIn[i], correctChosen: $correctChosen, wrongChosen: $wrongChosen, geoSize: $geoSize, questionNumber: $questionNumber).padding(.bottom, 2)
                }
            }
        }
        
        
    }
}

struct userCheckNavigationPopUpListeningActivityIPAD: View{
    @Binding var showUserCheck: Bool
    
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View{
        
        
        ZStack{
            VStack{
                
                
                Text("Are you Sure you want to Leave the Page?")
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 17))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                
                Text("You will be returned to the 'Select Audio Page' and progress on this exercise will be lost")
                    .font(Font.custom("Arial Hebrew", size: 15))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                
                HStack{
                    Spacer()
                    NavigationLink(destination: chooseAudio(), label: {
                        Text("Yes")
                            .font(Font.custom("Arial Hebrew", size: 15))
                            .foregroundColor(Color.blue)
                    }).simultaneousGesture(TapGesture().onEnded{
                        audioManager.player?.stop()
                    })
                    Spacer()
                    Button(action: {showUserCheck.toggle()}, label: {
                        Text("No")
                            .font(Font.custom("Arial Hebrew", size: 15))
                            .foregroundColor(Color.blue)
                    })
                    Spacer()
                }
            }
                
    
        }.frame(width: 265, height: 200)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 3)
            )
        
    }
}

struct correctLAComprehensionButtonIPAD: View {
    
    var choice: String
    var totalQuestions: Int
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var isEnabled = true
    @State var changeCorrectColor = false
    @State private var pressed: Bool = false
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var showDiag: Bool
    @Binding var geoSize: CGFloat
    
    var body: some View{
        

        Button(action: {
            changeCorrectColor = true
            isEnabled = false
   
          
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                
                if questionNumber != totalQuestions - 1 {
                    questionNumber = questionNumber + 1

                }else{
      
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showDiag = true
                    }
                    
                }
                
            }
            

        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 16))
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 10)
                    .padding([.top, .bottom], 10)
                
            }.padding([.leading, .trailing], 10)
                .frame(width:geoSize - 60)
        })
        .frame(width:geoSize - 60)
        .background(changeCorrectColor ? Color.green : Color.teal)
        .foregroundColor(Color.black)
        .cornerRadius(25)
        .shadow(radius: 5)
        .scaleEffect(pressed ? 1.10 : 1.0)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 3)
        .onChange(of: questionNumber) {newValue in
            changeCorrectColor = false
            isEnabled = true
        }
        .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring()) {
                self.pressed = pressing
            }
            if pressing {
                changeCorrectColor = true
              
            } else {
                isEnabled = false
                SoundManager.instance.playSound(sound: .correct)
              
            }
        }, perform: { })
        .enabled(isEnabled)
        
        
    }
    
}

struct incorrectLAComprehensionButtonIPAD: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var isEnabled = true
    @State var wrongChosen2 = false
    @State var selected = false
    @Binding var correctChosen: Bool
    @Binding var wrongChosen: Bool
    @Binding var geoSize: CGFloat
    @Binding var questionNumber: Int
    var body: some View{
        

        Button(action: {
            wrongChosen2 = true
            isEnabled = false
            SoundManager.instance.playSound(sound: .wrong)
            
            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                selected.toggle()
            }
            
            selected.toggle()
        
            
            
        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 16))
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 5)
                    .padding([.top, .bottom], 10)
                
            }.padding([.leading, .trailing], 10)
                .frame(width:geoSize - 60)
        })
        .frame(width:geoSize - 60)
        .background(wrongChosen2 ? Color.red : Color.teal)
        .foregroundColor(Color.black)
        .cornerRadius(25)
        .shadow(radius: 5)
        .offset(x: selected ? -3 : 0)
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 3)
        .onChange(of: questionNumber) { newValue in
           wrongChosen2 = false
            isEnabled = true
        }
        .enabled(isEnabled)

    }
    

    
}



struct listeningActivityIPAD_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
  
    static var previews: some View {
        listeningActivityIPAD(listeningActivityVM: listeningActivityVM, isPreview: true)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}

