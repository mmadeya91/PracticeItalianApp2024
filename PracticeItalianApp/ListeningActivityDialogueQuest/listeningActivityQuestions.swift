//
//  SwiftUIView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/10/23.
//

import SwiftUI

struct listeningActivityQuestions: View {
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var blankSpace: String = ""
    @State private var userInput: String = ""
    
    @State var currentQuestionNumber: Int = 0
    @State var currentDialogueQuestion: Int = 0
    @State var hintGiven: Bool = false
    @State var hintButtonText = "Hint!"
    @State var isQuestionDialogue = false
    @State var wrongSelected = false
    @State var changeColorOnWrongSelect = false
    @State var showPutInOrder = false
    @State var progress: CGFloat = 0.0
    @State var isPreview: Bool
    @State var animatingBear = false
    @State var correctChosen = false
    @State var wrongChosen = false
    @State var showUserCheck: Bool = false
    @State var showInfoPopUp = false
    @State var showingSheet = false
    @State var questionsFinished = false
    
    @ObservedObject var listeningActivityVM: ListeningActivityViewModel
    
    @State var placeHolderArray: [FillInDialogueQuestion] = [FillInDialogueQuestion]()
    
    @State var correctRandomInt = 1
    @State var wrongRandomInt = 1
    
    let infoText:Text =  (Text("Lines of audio from the dialogue will play one by one. Some of them will be missing important keywords that you must figure out and input in the text box. \n\nNot all of the dialogues pose a question, in that case use the  ") +
                         Text(Image(systemName: "arrow.forward.circle")) +
                         Text("  button to continue forward. If you need to hear a portion of the dialogue again, just use the  ") +
                         Text(Image(systemName: "arrow.triangle.2.circlepath")) +
                         Text("  button. If you are having trouble, there are hints available to you as well. \n\nRemember, spelling is important! including accents! It may be usefull to switch the keyboard on your phone to 'Italian' to make things easier."))
    
    var infoManager = InfoBubbleDataManager(activityName: "dialogueQuestionView")
    
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
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.5)){
                                showUserCheck.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        })
                        GeometryReader{proxy in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(.gray.opacity(0.25))
                                
                                Capsule()
                                    .fill(Color("ForestGreen"))
                                    .frame(width: proxy.size.width * CGFloat(progress))
                            }
                        }.frame(height: 11)
                            .onChange(of: currentDialogueQuestion){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(listeningActivityVM.audioAct.numberofDialogueQuestions))
                            }
                        
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                        Spacer()
                    }.zIndex(1)
                    
//                    Image("bearHead")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geo.size.height * 0.1, height: geo.size.height * 0.1)
//                        .offset(x: geo.size.width - geo.size.width * 0.35, y: geo.size.height - geo.size.height * 0.12)
//                        .opacity(correctChosen || wrongChosen ? 1.0 : 0.0)
//                    
                    Button(action: {
                        showPutInOrder = true
                    }, label: {
                            Text("Continue")
                            .font(Font.custom("Georgia", size: 17))
                        
                    })
                        .zIndex(2)
                        .frame(width: geo.size.width * 0.28, height: 40)
                        .buttonStyle(ThreeDButton(backgroundColor: "white"))
                        .opacity(questionsFinished ? 1 : 0)
                        .padding([.leading, .trailing], geo.size.width * 0.36)
                        .padding(.top, geo.size.height * 0.7)
                        
                    
                    
                    HStack{
                        
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
                                
                        })
                        
                        PopOverViewBottom(textIn: infoText, infoBubbleColor: Color.black, frameHeight: CGFloat(500), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch)
                    }.frame(maxHeight: .infinity, alignment: .bottomLeading)
                        .padding(15)
                        .padding(.leading, 30)
//                    
//                    if correctChosen{
//                 
//                            
//                            Image("bubbleChatRight"+String(correctRandomInt))
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: geo.size.width * 0.19, height: geo.size.width * 0.19)
//                                .offset(x: geo.size.width - geo.size.width * 0.57, y: geo.size.height - geo.size.height * 0.15)
//                        
//                    }
//                    
//                    if wrongChosen{
//                        
//
//                        Image("bubbleChatWrong"+String(wrongRandomInt))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 40)
//                            .offset(x: 15, y: -280)
//                    }
                    
                    if showUserCheck {
                        userCheckNavigationPopUpListeningActivity(showUserCheck: $showUserCheck)
                            .opacity(showUserCheck ? 1.0 : 0.0)
                            .zIndex(2)
                    }
                    
                 
                    
                    
                    ScrollViewReader {scrollView in
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            ForEach(0..<placeHolderArray.count, id: \.self) {i in
                                
                                HStack{
                                    if placeHolderArray[i].speakerNumber == 2 {
                                        Spacer()
                                    }
                                    if placeHolderArray[i].isQuestion {
                                        
                                        
                                        dialogueCaptionBoxWithQuestion(questionPart1: placeHolderArray[i].questionPart1, questionPart2: placeHolderArray[i].questionPart2, correctChosen: placeHolderArray[i].correctChosen, answer: placeHolderArray[i].answer, speakerNumber: placeHolderArray[i].speakerNumber, isConversation: listeningActivityVM.audioAct.isConversation, speaker1Image: listeningActivityVM.audioAct.speaker1Image, speaker2Image: listeningActivityVM.audioAct.speaker2Image, userInput: $userInput, currentQuestionNumber: $currentQuestionNumber)
                                            .padding([.leading, .trailing], 10).transition(.opacity)
                                        
                                        
                                        
                                    }else {
                                        
                                        
                                        dialogueCaptionBoxNoQuestion(fullSentence: placeHolderArray[i].fullSentence, questionNumber: i, speakerNumber: placeHolderArray[i].speakerNumber, isConversation: listeningActivityVM.audioAct.isConversation, speaker1Image: listeningActivityVM.audioAct.speaker1Image, speaker2Image: listeningActivityVM.audioAct.speaker2Image, currentQuestionNumber: $currentQuestionNumber)
                                            .padding([.leading, .trailing], 10).transition(.opacity)
                                        
                                        
                                    }
                                    if placeHolderArray[i].speakerNumber == 1{
                                        Spacer()
                                    }
                                    
                                    
                                }.padding(.top, 15).padding(.bottom, 5)
                                
//                                
//                                .transition(placeHolderArray[i].speakerNumber == 1 ? .slide : .backslide).animation(.easeIn(duration: 1.2)).padding(.top, 15).padding(.bottom, 5)
//                            
                                
                            }.animation(.easeIn(duration: 0.75))
                        }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.45)
                            .background(.white.opacity(1.0)).cornerRadius(20).padding(.top, 10)
                            .shadow(radius: 2)
                            .padding(.top, 55)
                       
                            
                        
                        //BLANK SPACES FOR HINT LETTERS
                        VStack(spacing: 0){
                            //FORWARD BUTTON FOR NON QUESTION DIALOGUE BOXES
                            HStack{
                                Button(action: {
                                  
                                        currentQuestionNumber += 1
                                    
                                    if currentQuestionNumber > listeningActivityVM.audioAct.audioCutFileNames.count - 1{
                                        questionsFinished = true
                                    }else{
                                        if currentQuestionNumber <= listeningActivityVM.audioAct.fillInDialogueQuestionElement.count - 1{
                                            placeHolderArray.append(listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                            
                                            if listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber].isQuestion {
                                                listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                                
                                                isQuestionDialogue = true
                                            }else {
                                                listeningActivityManager.resetCurrentHintLetterArray()
                                                isQuestionDialogue = false
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) {
                                                scrollView.scrollTo(currentQuestionNumber)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
                                            }
                                        }
                                        
                                        hintGiven = false
                                        hintButtonText = "Hint"
                                        userInput = ""
                                    }
                                        
                                    }, label: {
                                        Image(systemName: "play.circle")
                                            .resizable()
                                            .scaledToFill()
                                            .foregroundColor(.black)
                                            .frame(width: 30, height: 30)
                                        
                                    })
                                    .opacity(isQuestionDialogue || questionsFinished ? 0.0 : 1.0)
                                    .disabled(audioManager.isPlaying || isQuestionDialogue ? true : false)
                                
                                
                          
                                Spacer()
                                //CREATES BLANK UNDERLINED LETTERS FOR HINT BUTTON
                                HStack{
                                    
                                    ForEach($listeningActivityManager.currentHintLetterArray, id: \.self) { $answerArray in
                                        Text(answerArray.letter)
                                            .font(Font.custom("Georgia", size: 17))
                                            .foregroundColor(.black.opacity(answerArray.showLetter ? 1.0 : 0.0))
                                            .overlay(
                                                Rectangle()
                                                    .fill(Color.black)
                                                    .frame(width: 12, height: 1)
                                                , alignment: .bottom
                                            ).opacity(isQuestionDialogue ? 1.0 : 0.0)
                                        
                                    }
                                    
                                }.frame(width:geo.size.width * 0.6, height: 40)
                                    .zIndex(0)
                                
                                Spacer()
                                
                                Button(action: {
                                    
                                    audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
                                    
                                }, label: {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(.black)
                                        .frame(width: 30, height: 30)
                                    
                                }).disabled(audioManager.isPlaying ? true : false)
                                
                            }
                            .padding([.leading, .trailing], 35)
                            .padding(.top, 60)
                            .opacity(questionsFinished ? 0.0 : 1.0)
                            
                            
                            //HINT BUTTON
                            Button(action: {
                                if !hintGiven {
                                    var array = [Int](0...listeningActivityManager.currentHintLetterArray.count-1)
                                    array.shuffle()
                                    if listeningActivityManager.currentHintLetterArray.count == 2 {
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        hintButtonText = "Show Me!"
                                        hintGiven = true
                                    }
                                    if listeningActivityManager.currentHintLetterArray.count == 3 {
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        
                                        hintButtonText = "Show Me!"
                                        hintGiven = true
                                    }
                                    if listeningActivityManager.currentHintLetterArray.count > 3 {
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        listeningActivityManager.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                                        
                                        hintButtonText = "Show Me!"
                                        hintGiven = true
                                    }
                                    
                                }else{
                                    
                                    listeningActivityManager.showHint()
                                }
                                
                            }, label: {
                                
                                Text(hintButtonText)
                                    .font(Font.custom("Georgia", size: 18))
                                    .frame(height: 40)
                                    .foregroundColor(.black)
                                   // .padding(25)
                                
                            })
                                .disabled(isQuestionDialogue ? false : true)
                                .opacity(questionsFinished || isQuestionDialogue == false ? 0.0 : 1.0)
                                .frame(width: 120, height: 1)
                                .buttonStyle(ThreeDButton(backgroundColor: "white"))
                                .padding(25)
                                .padding(.top, 10)
                            
                            //HSTACK OF TEXT FIELD AND ENTER BUTTON
                            HStack(spacing: 0){

                                
                                TextField("", text: $userInput)
                                    .background(Color.white.cornerRadius(10))
                                    .font(Font.custom("Georgia", size: 30))
                                    .frame(width:geo.size.width * 0.8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius:0)
                                            .stroke(.black, lineWidth: 2)
                                    )
                                    .padding([.leading, .trailing], 15)
                                    .offset(x: wrongSelected ? -5 : 0)
                                    .onSubmit {
                                        if userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber].answer.lowercased()
                                        {
                                            SoundManager.instance.playSound(sound: .correct)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                correctChosen = false
                                            }
                                            
                                            correctRandomInt = Int.random(in: 1..<4)
                                            correctChosen = true
                                            
                                            placeHolderArray[currentQuestionNumber].correctChosen = true
                                            currentQuestionNumber += 1
                                            currentDialogueQuestion += 1
                                            if currentQuestionNumber > listeningActivityVM.audioAct.audioCutFileNames.count - 1{
                                                questionsFinished = true
                                            }else{
                                                placeHolderArray.append(listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                                if listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber].isQuestion {
                                                    listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                                    
                                                    isQuestionDialogue = true
                                                }else {
                                                    listeningActivityManager.resetCurrentHintLetterArray()
                                                    isQuestionDialogue = false
                                                }
                                                hintGiven = false
                                                hintButtonText = "Hint"
                                                userInput = ""
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                                    scrollView.scrollTo(currentQuestionNumber)
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
                                                }
                                            }
                                            
                                            
                                        } else {
                                            SoundManager.instance.playSound(sound: .wrong)
                                            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                                                wrongSelected.toggle()
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                changeColorOnWrongSelect.toggle()
                                            }
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                wrongChosen = false
                                            }
                                            
                                            wrongRandomInt = Int.random(in: 1..<4)
                                            wrongChosen = true
                                            
                                            changeColorOnWrongSelect.toggle()
                                        }
                                    }.disabled(audioManager.isPlaying ? true : false)
                                    .opacity(questionsFinished || isQuestionDialogue == false ? 0.0 : 1.0)
                                
                                
                            }//.padding(.bottom, 30)
                                .padding([.leading, .trailing], 10)
                                .padding(.top, 35)
                                
                            
                        }.offset(y:-50)
                        
               
                    }
                    
                    let LAPutDialogueInOrderVM = LAPutDialogueInOrderViewModel(dialoguePutInOrderVM: dialoguePutInOrderObj(stringArray: listeningActivityVM.audioAct.putInOrderSentenceArray[0].fullSentences))
                    
                    NavigationLink(destination: LAPutDialogueInOrder(LAPutDialogueInOrderVM: LAPutDialogueInOrderVM, listeningActivityVM: listeningActivityVM),isActive: $showPutInOrder,label:{}
                    ).isDetailLink(false).id(UUID())
                    
                }.navigationBarBackButtonHidden(true)
                //.ignoresSafeArea(.keyboard, edges: .bottom)
                    .sheet(isPresented: $showingSheet) {
                        SheetViewListeningActivity(listeningActivityVM: listeningActivityVM)
                    }
                    .onDisappear{
                        infoManager.updateCorrectInput(activity: infoManager.getActivityFirstLaunchData())
                    }
                    .onAppear{
                        withAnimation(.spring()){
                            animatingBear = true
                        }
                        
               
                        listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: listeningActivityVM.audioAct.fillInDialogueQuestionElement[0])
                        placeHolderArray.append(listeningActivityVM.audioAct.fillInDialogueQuestionElement[0])
                        isQuestionDialogue = listeningActivityVM.audioAct.fillInDialogueQuestionElement[0].isQuestion
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[0], isPreview: isPreview)
                    }
                    
                }
                .onChange(of: audioManager.isPlaying){
                    newValue in
                    
                    if newValue == false {
                        if currentQuestionNumber == listeningActivityVM.audioAct.audioCutFileNames.count - 1  && isQuestionDialogue == false{
                            
                            questionsFinished = true
                        }
                    }
                }
            }else{
                listeningActivityQuestionsIPAD(isPreview: false, listeningActivityVM: listeningActivityVM)
            }
        }//.ignoresSafeArea(.keyboard)
    }
    
}




struct dialogueCaptionBoxWithQuestion: View {
    
    var questionPart1: String
    var questionPart2: String
    var correctChosen: Bool
    var answer: String
    var speakerNumber: Int
    var isConversation: Bool
    var speaker1Image: String
    var speaker2Image: String
    
    @Binding var userInput: String
    @Binding var currentQuestionNumber: Int
    

    
    var body: some View{
        if speakerNumber == 1 {
            HStack{
                ImageOnCircleListening(icon: speaker1Image, radius: 18, isSpeaker1: true)
                    .padding(.trailing, 10)
                HStack {
                    Text(questionPart1)
                        .font(Font.custom("Georgia", size: 13)) +
                    Text(answer)
                        .foregroundColor(.green.opacity(correctChosen ? 1.0 : 0.0))
                        .underline(color: .black.opacity(1.0))
                        .font(Font.custom("Georgia", size: 13))
                    +
                    Text(questionPart2)
                        .font(Font.custom("Georgia", size: 13))
                }.frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                                
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                .offset(y: -4)
 
    
                        }
                    }
                    .cornerRadius(10)
                    .shadow(radius: 1.5)
                
            }
        }else{
            HStack{
                HStack {
              
                        Text(questionPart1)
                            .font(Font.custom("Georgia", size: 13)) +
                        Text(answer)
                        .foregroundColor(.green.opacity(correctChosen ? 1.0 : 0.0))
                            .underline(color: .black.opacity(1.0))
                            .font(Font.custom("Georgia", size: 13))
                        +
                        Text(questionPart2)
                            .font(Font.custom("Georgia", size: 13))

                }.frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                                
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                .offset(y: -4)
 
    
                        }
                    }
                    .cornerRadius(10)
                    .shadow(radius: 1.5)
                
                ImageOnCircleListening(icon: speaker2Image, radius: 18, isSpeaker1: false)
                    .padding(.trailing, 10)
                
            }
            
        }
    }
}

func calculateBlankSpace(answerIn: String)-> String{
    var letterCount = answerIn.count
    var blankSpace = ""
    
    for i in 0...letterCount {
        blankSpace += "_"
    }
    
    return blankSpace
}

struct dialogueCaptionBoxNoQuestion: View {
    var fullSentence: String
    var questionNumber: Int
    var speakerNumber: Int
    var isConversation: Bool
    var speaker1Image: String
    var speaker2Image: String
    
    
    @Binding var currentQuestionNumber: Int
    
    var body: some View {
        if speakerNumber == 1{
            HStack{
                ImageOnCircleListening(icon: speaker1Image, radius: 18, isSpeaker1: true)
                    .padding(.trailing, 10)
                Text(fullSentence)
                    .font(Font.custom("Georgia", size: 13))
                    .frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                                
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                .offset(y: -4)
 
    
                        }
                    }
                    .cornerRadius(10)
                    .shadow(radius: 1.5)
            }
        }else{
            HStack{
                Text(fullSentence)
                    .font(Font.custom("Georgia", size: 13))
                    .frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                                
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                .offset(y: -4)
 
    
                        }
                    }
                    .cornerRadius(10)
                    .shadow(radius: 1.5)
                
                ImageOnCircleListening(icon: speaker2Image, radius: 18, isSpeaker1: false)
                    .padding(.trailing, 10)
            }
        }
        
        
    }
}

struct ImageOnCircleListening: View {
    
    let icon: String
    let radius: CGFloat
    let isSpeaker1: Bool
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isSpeaker1 ? Color("ForestGreen").opacity(0.7) : Color("terracotta").opacity(0.7))
                .frame(width: radius * 2, height: radius * 2)
              
            Image(icon)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static let listeningActivityVM = ListeningActivityViewModel(audioAct: audioActivty.cosaDesidera)

    static var previews: some View {
        listeningActivityQuestions(isPreview: false, listeningActivityVM: listeningActivityVM)
            .environmentObject(ListeningActivityManager())
            .environmentObject(AudioManager())
    }
}
