//
//  listeningActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/19/23.
//

import SwiftUI


struct listeningActivity: View {
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
    @State var showingSheet = false
    @State var progress2 = 0
    
    @State var questionBoxWidth: CGFloat = 0.0
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common)
        .autoconnect()
    
 
    
    
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
                        Spacer()
                        NavigationLink(destination: ContentView(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                            
                        }).id(UUID())
                        
                        GeometryReader{proxy in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.gray.opacity(0.25))
                                
                                Capsule()
                                    .fill(Color("ForestGreen"))
                                    .frame(width: proxy.size.width * CGFloat(progress))
                            }
                        }.frame(height: 11)
                            .onChange(of: progress2){ newValue in
                                progress = (CGFloat(newValue + 1) / CGFloat(listeningActivityVM.audioAct.comprehensionQuestions.count + 1))
                            }
                        
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                        Spacer()
                    }.zIndex(1)
                    
                    
                    
                    VStack(spacing: 0){
                        VStack{
                            if !questionsExpanded{
                                  
                                Image(listeningActivityVM.audioAct.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geo.size.height * 0.12, height: geo.size.height * 0.12)
                                
                                
                            }
                            GroupBox{
   
                                
                            
                                DisclosureGroup("Questions", isExpanded: $questionsExpanded) {
                                    
                                    
                                    
                                    
                                    VStack{
                                        
                                        
                                        Text(listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].question)
                                            .font(Font.custom("Georgia", size: 17))
                                            .multilineTextAlignment(.center)
                                            .padding(15)
                                            .frame(width: geo.size.width - 37)
                                            .border(width: 4, edges: [.bottom], color:Color("espressoBrown"))
                                            .padding(.bottom, 10)
                                           
                                        
                                        
                                        radioButtonsLAComprehension(correctAnswer: listeningActivityVM.audioAct.comprehensionQuestions[questionNumber].answer, choicesIn: listeningActivityVM.audioAct.comprehensionQuestionChoices[questionNumber], totalQuestions: listeningActivityVM.audioAct.comprehensionQuestions.count, questionBoxWidth: questionBoxWidth, questionNumber: $questionNumber, wrongChosen: $wrongChosen, correctChosen: $correctChosen, showDialogueQuestions: $showDialogueQuestions, progress2: $progress2)   .padding(.top, 10)
                                            .padding(.bottom, 16)
                                        
                                        
                                        
                                        
                                        
                                    }
                                    .frame(width: geo.size.width * 0.85)
                                    .padding(.top, 10)
                                    
                                    
                                }
                                .tint(Color.black)
                                .font(Font.custom("Georgia", size: 16))
                                .frame(width: geo.size.width * 0.85)
                                
                            } .padding(.bottom, 15)
                                .padding(.top, 10)
                               
                            
                            //                        }.background(  RoundedRectangle(cornerRadius: 10)
                            //                            .fill(Color("DarkNavy"))
                            //                            .overlay( /// apply a rounded border
                            //                                RoundedRectangle(cornerRadius: 15)
                            //                                    .stroke(.black, lineWidth: 4)
                            //                                    )
                            //                                .shadow(radius: 10)
                            //                                .padding([.leading, .trailing], 10)
                            //                                .zIndex(0))
                            
       
                        }.offset(y: geo.size.height / 9.8)
                        
                        
                        
                        
                        
                        
                        if let player = audioManager.player  {
                            VStack{
                                HStack{
                                    Text(listeningActivityVM.audioAct.title)
                                        .font(Font.custom("Georgia", size: 18))
                                        .frame(height: 80)
                                        .multilineTextAlignment(.center)
                                        .padding(.leading, 30)
                                     
                                    
                                    Button(action: {
                                        withAnimation(Animation.spring()){
                                            showingSheet.toggle()
                                        }
                                    }, label: {
                                        Image(systemName: "newspaper")
                                            .font(.system(size: 25))
                                            .foregroundColor(.black)
                                            .edgesIgnoringSafeArea(.all)
                                            .frame(width: 35, height: 35)
                                            
                                    })
                                }.offset(y:10)
                                   
                                VStack(spacing: 0){
                                    
                                    Slider(value: $value, in: 0...player.duration) { editing
                                        in
                                        
                                        print("editing", editing)
                                        isEditing = editing
                                        
                                        if !editing {
                                            player.currentTime = value
                                        }
                                    }
                                    .scaleEffect(1)
                                    .frame(width: 260, height: 20)
                                    .tint(.orange)
                                
                                    
                                    
                                    HStack{
                                        Text(DateComponentsFormatter.positional
                                            .string(from: player.currentTime) ?? "0:00")
                                        
                                        Spacer()
                                        
                                        Text(DateComponentsFormatter.positional
                                            .string(from: player.duration - player.currentTime) ?? "0:00")
                                        
                                    }.padding(15)
                                }.padding([.leading, .trailing], 35)
                                   
                                
                                HStack{
                                    let color: Color = audioManager.isLooping ? .teal : .black
                                    let tortoiseColor: Color = audioManager.isSlowPlayback ? .teal : .black
                                    
                                    PlaybackControlButton(systemName: "repeat", color: color) {
                                        audioManager.toggleLoop()
                                    }.padding(.leading, 40)
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
                                    }.padding(.trailing, 40)
                                    
                                    
                                }
                                .padding([.leading, .trailing], 15)
                                //.padding(.top, 5)
                                
                                
                            }.frame(maxHeight: .infinity, alignment: .bottom)
                               
                        }
                        
                    }.frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                        .offset(y: -20)
                        
                        
                    
                    
                    
                    
                    
                }.sheet(isPresented: $showingSheet) {
                   SheetViewListeningActivity(listeningActivityVM: listeningActivityVM)
                }
                .onDisappear(perform: {audioManager.player?.stop()})
                    .navigationBarBackButtonHidden(true)
                    .onAppear{
                        
                        questionBoxWidth = geo.size.width - 70
                        withAnimation(.spring()){
                            animatingBear = true
                        }
                        
                        audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                        
                        audioManager.setAudioName(nameIn: listeningActivityVM.audioAct.title) 
                        
                        
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
                
                NavigationLink(destination:    listeningActivityQuestions(isPreview: false, listeningActivityVM: listeningActivityVM),isActive: $showDialogueQuestions,label:{}
                ).isDetailLink(false).id(UUID())
            }else{
                listeningActivityIPAD(listeningActivityVM: listeningActivityVM, isPreview: false)
            }
            
        }
        
    }
    
}

struct radioButtonsLAComprehension: View {
    
    var correctAnswer: String
    var choicesIn: [String]
    var totalQuestions: Int
    var questionBoxWidth: CGFloat

    @Binding var questionNumber: Int
    @Binding var wrongChosen: Bool
    @Binding var correctChosen: Bool
    @Binding var showDialogueQuestions: Bool
    @Binding var progress2: Int
    
    var body: some View{
        VStack(spacing: 20) {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctLAComprehensionButton(choice: choicesIn[i], totalQuestions: totalQuestions, questionBoxWidth: questionBoxWidth, questionNumber: $questionNumber, correctChosen: $correctChosen, showDiag: $showDialogueQuestions, progress2: $progress2)//.padding(.bottom, 2)
                } else {
                    incorrectLAComprehensionButton(choice: choicesIn[i], questionBoxWidth: questionBoxWidth, correctChosen: $correctChosen, questionNumber: $questionNumber)//.padding(.bottom, 2)
                }
            }
        }
        
        
    }
}

struct SheetViewListeningActivity: View{
    @Environment(\.dismiss) var dismiss
    @State var showEnglish = false
    @State var showTranscription = true
    var listeningActivityVM: ListeningActivityViewModel
    var body: some View{
        GeometryReader{ geo in
            
            ZStack(alignment: .topLeading){
                Image("Screen Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                HStack{
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .tint(Color.black)
                        
                    }).padding().zIndex(2).padding(.top, 15)
                    
                    Spacer()
                    Button(action: {
                        withAnimation(.easeIn){
                            showEnglish.toggle()
                        }
                    }, label: {
                        Image(systemName: showEnglish ? "eye.slash" : "eye")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.black)
                            .frame(width: 15, height: 15)
                    })
                        .offset(y:10)
                        .buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 38, height: 35)
                        .padding(.trailing, 25)
                }.zIndex(2).padding(.top, 10)
                
                HStack{
                  
                    Button(action: {
                        showTranscription = true
                    }, label: {
                        Text("Transcription")
                            .font(Font.custom("Georgia", size: 25))
                            .padding(.top, 40)
                            .foregroundColor(Color.black)
                            .overlay(
                                Rectangle()
                                    .fill(Color("terracotta"))
                                    .frame(width: 145, height: 3)
                                    .opacity(showTranscription ? 1.0 : 0)
                                , alignment: .bottom
                            )
                    })
                    Spacer()
                    Button(action: {
                        showTranscription = false
                    }, label: {
                        Text("Keywords")
                            .font(Font.custom("Georgia", size: 25))
                            .padding(.top, 40)
                            .foregroundColor(Color.black)
                            .overlay(
                                Rectangle()
                                    .fill(Color("terracotta"))
                                    .frame(width: 113, height: 3)
                                    .opacity(showTranscription ? 0 : 1.0)
                                , alignment: .bottom
                            )
                    })
                  
                }.frame(width: geo.size.width * 0.8, height: 20).padding([.leading, .trailing], geo.size.width * 0.1).padding(.top, 95)
                
                if showTranscription{
                    ScrollView(showsIndicators: false){
                        VStack{
                            if !showEnglish {
                                Text(listeningActivityVM.audioAct.audioTranscriptItalian)
                                    .font(Font.custom("Arial Hebrew", size: 18))
                                    .padding(.top, 40)
                                    .padding(.leading, 30)
                                    .padding(.trailing, 30)
                                    .lineSpacing(20)
                            }else{
                                Text(listeningActivityVM.audioAct.audioTranscriptEnglish)
                                    .font(Font.custom("Arial Hebrew", size: 18))
                                    .padding(.top, 40)
                                    .padding(.leading, 30)
                                    .padding(.trailing, 30)
                                    .lineSpacing(20)
                            }
                        }
                    }.padding(.top, 160)
                }else{
                    ScrollView(showsIndicators: false){
                        Text(buildKeyWordSection())
                            .font(Font.custom("Georgia", size: 18))
                            .padding(.top, 40)
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                            .lineSpacing(20)
                          
                    }.padding(.top, 160)
                }
                
            }
        }
    }
    
    func buildKeyWordSection()->String{
        var keyWordString = ""
        for i in 0...listeningActivityVM.audioAct.keywords.count-1{
            var tempString = ""
            tempString = listeningActivityVM.audioAct.keywords[i].wordItalian + " - " + listeningActivityVM.audioAct.keywords[i].wordEnglish
            
            keyWordString += tempString + "\n"
        }
        
        return keyWordString
    }
}

struct userCheckNavigationPopUpListeningActivity: View{
    @Binding var showUserCheck: Bool
    
    @EnvironmentObject var audioManager: AudioManager
    
    var body: some View{
        GeometryReader{geo in
            ZStack{
                VStack{
                    
                    
                    Text("Are you Sure you want to Leave the Page?")
                        .bold()
                        .font(Font.custom("Georgia", size: geo.size.width * 0.05))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 15)
                    
                    
                    Text("You will be returned to the 'Select Audio Page' and progress on this exercise will be lost")
                        .font(Font.custom("Georgia", size: geo.size.width * 0.04))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 15)
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: ContentView(), label: {
                            Text("Yes")
                                .font(Font.custom("Georgia", size: 15))
                                .foregroundColor(Color.black)
                        }).id(UUID()).simultaneousGesture(TapGesture().onEnded{
                            audioManager.player?.stop()
                        }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 70, height: 35)
                        Spacer()
                        Button(action: {showUserCheck.toggle()}, label: {
                            Text("No")
                                .font(Font.custom("Georgia", size: 15))
                                .foregroundColor(Color.black)
                        }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 70, height: 35)
                        Spacer()
                    }
                    
                }
                
                
            }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.35)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 3)
                )
                .padding([.leading, .trailing], geo.size.width * 0.1)
                .padding([.top, .bottom], geo.size.height * 0.25)
            
            
        }
    }
}

struct correctLAComprehensionButton: View {
    
    var choice: String
    var totalQuestions: Int
    var questionBoxWidth: CGFloat
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var enableButton = true
    @State var changeCorrectColor = false
    @State private var pressed: Bool = false
    @State var isPressing = false
    @State var isEnabled = true
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var showDiag: Bool
    @Binding var progress2: Int
    
    var body: some View{
        

        Button(action: {
            changeCorrectColor = true
            isEnabled = false
         

            SoundManager.instance.playSound(sound: .correct)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                
                withAnimation(.easeIn(duration: 1.0)){
                    if questionNumber != totalQuestions - 1 {
                        progress2 = progress2 + 1
                        
                    }else{
                        progress2 = totalQuestions
                        
                        
                        
                    }
                }
                
            }
          
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                
                if questionNumber != totalQuestions - 1 {
                    questionNumber = questionNumber + 1

                }else{
                    
                        showDiag = true
                    
                    
                }
                
            }
            
            
    
         

        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Georgia", size: 15))
                    .padding([.top, .bottom], 10)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 3)
                
                   
                
            }.padding([.leading, .trailing], 10).frame(width:questionBoxWidth)
        })
        .frame(width:questionBoxWidth - 40, height: 38)

        .buttonStyle(ThreeDMultipleChoiceButtonCorrect(isPressed: changeCorrectColor))
        .onChange(of: questionNumber) {newValue in
            changeCorrectColor = false
            isEnabled = true
        }
        .enabled(isEnabled)
        
        
    }
    
}

struct incorrectLAComprehensionButton: View {
    
    var choice: String
    var questionBoxWidth: CGFloat
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var enableButton = true
    @State var wrongChosen2 = false
    @State var selected = false
    @State var isEnabled = true
    @State var isPressing = false
    @State var wrongChosen = false
    @Binding var correctChosen: Bool
    @Binding var questionNumber: Int
    
    var body: some View{
        

        Button(action: {
                wrongChosen = true
                isEnabled = false
         
                SoundManager.instance.playSound(sound: .wrong)
                
                withAnimation((Animation.default.repeatCount(5).speed(6))) {
                    selected.toggle()
                }
                
                selected.toggle()
            

            
            
        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Georgia", size: 15))
                    .padding([.top, .bottom], 10)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 3)
                
                   
                
                
            }.padding([.leading, .trailing], 10).frame(width:questionBoxWidth)
        })
        .frame(width:questionBoxWidth-40, height: 38)

        .offset(x: selected ? -5 : 0)
        .buttonStyle(ThreeDMultipleChoiceButtonIncorrect(isPressed: wrongChosen))
        .padding([.leading, .trailing], 10)
        .onChange(of: questionNumber) { newValue in
           wrongChosen = false
            isEnabled = true
        }
        .enabled(isEnabled)

    }
    
    func resetColors() {
        colorOpacity = 0.0
        chosenOpacity = 0.0
    }
    
}



struct listeningActivity_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
  
    static var previews: some View {
        listeningActivity(listeningActivityVM: listeningActivityVM, isPreview: true)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}
