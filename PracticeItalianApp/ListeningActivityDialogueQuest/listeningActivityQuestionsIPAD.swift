//
//  listeningActivityQuestionsIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/4/24.
//

import SwiftUI

struct listeningActivityQuestionsIPAD: View {
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.dismiss) var dismiss
    
    @State private var blankSpace: String = ""
    @State private var userInput: String = ""
    
    @State var currentQuestionNumber: Int = 0
    @State var questionCount: Int = 0
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
    
    @ObservedObject var listeningActivityVM: ListeningActivityViewModel
    
    @State var placeHolderArray: [FillInDialogueQuestion] = [FillInDialogueQuestion]()
    
    var body: some View {
        GeometryReader{geo in
  
            ZStack(alignment: .topLeading){
                
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .zIndex(0)
                
                HStack(spacing: 18){
                    Spacer()
                    Button(action: {
                        withAnimation(.linear){
                            showUserCheck.toggle()
                        }
                    }, label: {
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
                        .onChange(of: questionCount){ newValue in
                            progress = (CGFloat(newValue) / CGFloat(listeningActivityVM.audioAct.numberofDialogueQuestions))
                        }
                    
                    Image("italyFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                    Spacer()
                }
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.35)
                    .offset(x: geo.size.width - geo.size.width * 0.4, y: animatingBear ? geo.size.height - geo.size.height * 0.14 : 9000)
                    .zIndex(0)
                
                HStack{
                    Button(action: {
                        withAnimation(.linear){
                            showInfoPopUp.toggle()
                        }
                    }, label: {
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                        
                    })
                }.frame(maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(25)
                
                if correctChosen{
                    
                    let randomInt = Int.random(in: 1..<4)
                    
                    Image("bubbleChatRight"+String(randomInt))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 80)
                        .offset(x: geo.size.width - geo.size.width * 0.5, y: geo.size.height - geo.size.height * 0.14)
                }
                
                if wrongChosen{
                    
                    let randomInt2 = Int.random(in: 1..<4)
                    
                    Image("bubbleChatWrong"+String(randomInt2))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 80)
                        .offset(x: geo.size.width - geo.size.width * 0.5, y: geo.size.height - geo.size.height * 0.14)
                }
                
                if showUserCheck {
                    userCheckNavigationListeningDiagIPAD(showUserCheck: $showUserCheck)
                        .transition(.slide)
                        .animation(.easeIn)
                        .padding(.leading, 5)
                        .padding(.bottom, 250)
                        .zIndex(2)
                    
                }
                
                ZStack(alignment: .topLeading){
                    HStack{
                        Button(action: {
                            withAnimation(.easeIn(duration: 0.75)){
                                showInfoPopUp.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 35))
                                .foregroundColor(.black)
                            
                        })
                    }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
                    
                    VStack{
                        
                        
                        (Text("Lines of audio from the dialogue will play one by one. Some of them will be missing important keywords that you must figure out and input in the text box. \n\nNot all of the dialogues pose a question, in that case use the  ") +
                         Text(Image(systemName: "arrow.forward.circle")) +
                         Text("  button to continue forward. If you need to hear a portion of the dialogue again, just use the  ") +
                         Text(Image(systemName: "arrow.triangle.2.circlepath")) +
                         Text("  button. If you are having trouble, there are hints available to you as well. \n\nRemember, spelling is important! including accents! It may be usefull to switch the keyboard on your phone to 'Italian' to make things easier."))
                                .multilineTextAlignment(.center)
                                .padding(35)
                                .offset(y: 30)
                                .font(.system(size:25))
                                
                    }.padding(.top, 10)
                }.frame(width: geo.size.width * 0.6, height: geo.size.width * 0.91)
                    .background(Color("WashedWhite"))
                    .cornerRadius(20)
                    .shadow(radius: 20)
                    .overlay( /// apply a rounded border
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 3)
                    )
                    .offset(x: showInfoPopUp ? ((geo.size.width / 2) - geo.size.width * 0.3): -550, y: (geo.size.height / 8))
                    .zIndex(2)
            
                
                //entire scroll view is being reloaded per question
                //causing the transition to refire for each one
                //need to somehow only add the new question to scrollview
                //instead of readding all of them + the new one
                ScrollViewReader {scrollView in
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        ForEach(0..<placeHolderArray.count, id: \.self) {i in
                            
                            HStack{
                                if placeHolderArray[i].speakerNumber == 2 {
                                    Spacer()
                                }
                                if placeHolderArray[i].isQuestion {
                                    
                                    
                                    dialogueCaptionBoxWithQuestionIPAD(questionPart1: placeHolderArray[i].questionPart1, questionPart2: placeHolderArray[i].questionPart2, correctChosen: placeHolderArray[i].correctChosen, answer: placeHolderArray[i].answer, speakerNumber: placeHolderArray[i].speakerNumber, isConversation: listeningActivityVM.audioAct.isConversation, speaker1Image: listeningActivityVM.audioAct.speaker1Image, speaker2Image: listeningActivityVM.audioAct.speaker2Image, userInput: $userInput, currentQuestionNumber: $currentQuestionNumber)
                                        .padding([.leading, .trailing], 15)
                                    
                                    
                                    
                                }else {
                                    
                                    
                                    dialogueCaptionBoxNoQuestionIPAD(fullSentence: placeHolderArray[i].fullSentence, questionNumber: i, speakerNumber: placeHolderArray[i].speakerNumber, isConversation: listeningActivityVM.audioAct.isConversation, speaker1Image: listeningActivityVM.audioAct.speaker1Image, speaker2Image: listeningActivityVM.audioAct.speaker2Image, currentQuestionNumber: $currentQuestionNumber)
                                        .padding([.leading, .trailing], 15)
                                    
                                    
                                }
                                if placeHolderArray[i].speakerNumber == 1{
                                    Spacer()
                                }
                                
                                
                            }.transition(placeHolderArray[i].speakerNumber == 1 ? .slide : .backslide).animation(.easeIn(duration: 0.75)).padding(.top, 15).padding(.bottom, 5)
                        }
                    }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.45)
                        .background(Color("WashedWhite")).cornerRadius(20).padding(.top, 10)
                        .shadow(radius: 10)
                        .padding(.top, 95)
                    
                    //BLANK SPACES FOR HINT LETTERS
                    VStack(spacing: 0){
                        //FORWARD BUTTON FOR NON QUESTION DIALOGUE BOXES
                        HStack{
                           
                            
                            
                            Button(action: {
                                currentQuestionNumber += 1
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
                                    }
                                }
        
                                hintGiven = false
                                hintButtonText = "Hint!"
                                userInput = ""
                                
                                
                            }, label: {
                                Image(systemName: "arrow.forward.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.black)
                                    .frame(width: 50, height: 50)
                                
                            })
                            .opacity(isQuestionDialogue ? 0.0 : 1.0)
                            .disabled(isQuestionDialogue ? true : false)
                         
                            
                            
                            Spacer()
                            //CREATES BLANK UNDERLINED LETTERS FOR HINT BUTTON
                            HStack{
                                
                                ForEach($listeningActivityManager.currentHintLetterArray, id: \.self) { $answerArray in
                                    Text(answerArray.letter)
                                        .font(Font.custom("Chalkboard SE", size: 30))
                                        .foregroundColor(.black.opacity(answerArray.showLetter ? 1.0 : 0.0))
                                        .underline(color: .black.opacity(isQuestionDialogue ? 1.0 : 0.0))
                                    
                                }
                                
                            }.frame(width:200, height: 40)
                            
                            Spacer()
                            
                            Button(action: {
                                
                                audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
                                
                            }, label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.black)
                                    .frame(width: 50, height: 50)
                                
                            })
                            
                        }.frame(width: geo.size.width * 0.8)
                            .padding([.leading, .trailing], geo.size.width * 0.1)
                        .padding(.top, 50)
                        .offset(y: 15)
                        
                        
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
                                .font(Font.custom("Chalkboard SE", size: 25))
                                .padding()
                                .padding(.bottom, 5)
                                .padding([.leading, .trailing], 15)
                                .foregroundColor(.white)
                                
                            
                        }).frame(height: 50)
                            .background(Color("DarkNavy"))
                            .cornerRadius(20)
                            .shadow(radius: 15)
                            .disabled(isQuestionDialogue ? false : true)
                            .padding(.top, 40)
                            .padding(.bottom, 26)
                    
                        
                        //HSTACK OF TEXT FIELD AND ENTER BUTTON
                        HStack(spacing: 0){
                            
                            TextField("", text: $userInput)
                                .background(Color.white.cornerRadius(10))
                                .font(Font.custom("Marker Felt", size: 50))
                                .shadow(color: changeColorOnWrongSelect ? Color.red : Color.black, radius: 12, x: 0, y:10)
                                .padding([.leading, .trailing], 15)
                                .offset(x: wrongSelected ? -5 : 0)
                                .onSubmit {
                                    if userInput.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber].answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                                    {
                                        SoundManager.instance.playSound(sound: .correct)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            correctChosen = false
                                        }
                                  
                                        correctChosen = true
                                        
                                        placeHolderArray[currentQuestionNumber].correctChosen = true
                                        questionCount += 1
                                        currentQuestionNumber += 1
                                        placeHolderArray.append(listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                        if listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber].isQuestion {
                                            listeningActivityManager.setCurrentHintLetterArray(fillInBlankDialogueObj: listeningActivityVM.audioAct.fillInDialogueQuestionElement[currentQuestionNumber])
                                            
                                            isQuestionDialogue = true
                                        }else {
                                            listeningActivityManager.resetCurrentHintLetterArray()
                                            isQuestionDialogue = false
                                        }
                                        hintGiven = false
                                        hintButtonText = "Hint!"
                                        userInput = ""
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                                            scrollView.scrollTo(currentQuestionNumber)
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                            audioManager.startPlayer(track: listeningActivityVM.audioAct.audioCutFileNames[currentQuestionNumber])
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
                                        
                                        wrongChosen = true
                                        
                                        changeColorOnWrongSelect.toggle()
                                    }
                                }
                            
                        }.padding(.bottom, 50)
                            .padding([.leading, .trailing], 10)
                            .frame(width: geo.size.width * 0.7)
                            .zIndex(2)
                        
                        
                    }.offset(y:-50)
   

                }
                
                let LAPutDialogueInOrderVM = LAPutDialogueInOrderViewModel(dialoguePutInOrderVM: dialoguePutInOrderObj(stringArray: listeningActivityVM.audioAct.putInOrderSentenceArray[0].fullSentences))
                
                NavigationLink(destination: LAPutDialogueInOrderIPAD(LAPutDialogueInOrderVM: LAPutDialogueInOrderVM),isActive: $showPutInOrder,label:{}
                                                  ).isDetailLink(false)
                
            }.navigationBarBackButtonHidden(true)
            .onChange(of: currentQuestionNumber) { questionNumber in
                 
                     if questionNumber > listeningActivityVM.audioAct.audioCutFileNames.count - 1{
                         showPutInOrder = true
                     }
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
            
        }
    }
    
}




struct dialogueCaptionBoxWithQuestionIPAD: View {
    
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
                ImageOnCircleListeningIPAD(icon: speaker1Image, radius: 25, isSpeaker1: true)
                    .padding(.trailing, 20)
                    .padding(.leading, 10)
                HStack {
                    if !correctChosen {
                        Text(questionPart1)
                            .font(Font.custom("Chalkboard SE", size: 20)) +
                        Text(createBlankSpace(letterCountIn: answer.count))
                            .font(Font.custom("Chalkboard SE", size: 20))
                        +
                        Text(questionPart2)
                            .font(Font.custom("Chalkboard SE", size: 20))
                    }else {
                        Text(questionPart1)
                            .font(Font.custom("Chalkboard SE", size: 20)) +
                        
                        Text(answer).underline()
                            .font(Font.custom("Chalkboard SE", size: 20))
                            .foregroundColor(.green)
                        +
                        Text(questionPart2)
                            .font(Font.custom("Chalkboard SE", size: 20))
                    }
                }.frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
            }
        }else{
            HStack{
                HStack {
                    if !correctChosen {
                        Text(questionPart1)
                            .font(Font.custom("Chalkboard SE", size: 20)) +
                        Text(createBlankSpace(letterCountIn: answer.count))
                            .font(Font.custom("Chalkboard SE", size: 20))
                            
             
                        +
                        Text(questionPart2)
                            .font(Font.custom("Chalkboard SE", size: 20))
                    }else {
                        Text(questionPart1)
                            .font(Font.custom("Chalkboard SE", size: 20)) +
                        
                        Text(answer).underline()
                            .font(Font.custom("Chalkboard SE", size: 20))
                            .foregroundColor(.green)
                        +
                        Text(questionPart2)
                            .font(Font.custom("Chalkboard SE", size: 20))
                    }
                }.frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                ImageOnCircleListeningIPAD(icon: speaker2Image, radius: 25, isSpeaker1: false)
                    .padding(.trailing, 10)
                    .padding(.leading, 20)
            }
            
        }
    }
    
    
    func createBlankSpace(letterCountIn: Int)-> String{
       var blankWord = ""
        var hyphenArray: [String] = [String]()
        
        for _ in 0...letterCountIn - 1 {
            hyphenArray.append("_")
            
        }
        
        blankWord = hyphenArray.joined()
        return blankWord
    }
}

struct dialogueCaptionBoxNoQuestionIPAD: View {
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
                ImageOnCircleListeningIPAD(icon: speaker1Image, radius: 25, isSpeaker1: true)
                    .padding(.trailing, 20)
                    .padding(.leading, 10)
                Text(fullSentence)
                    .font(Font.custom("Chalkboard SE", size: 20))
                    .frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }else{
            HStack{
                Text(fullSentence)
                    .font(Font.custom("Chalkboard SE", size: 20))
                    .frame()
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                ImageOnCircleListeningIPAD(icon: speaker2Image, radius: 25, isSpeaker1: false)
                    .padding(.trailing, 10)
                    .padding(.leading, 20)
            }
        }
        
        
    }
}

struct ImageOnCircleListeningIPAD: View {
    
    let icon: String
    let radius: CGFloat
    let isSpeaker1: Bool
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isSpeaker1 ? .teal : .orange)
                .frame(width: radius * 2, height: radius * 2)
             
              
            Image(icon)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
             
              
        }
    }
}

struct userCheckNavigationListeningDiagIPAD: View{
    @Binding var showUserCheck: Bool
    
    var body: some View{
       
        GeometryReader{ geo in
            ZStack{
                VStack{
                    
                    
                    Text("Are you Sure you want to Leave the Page?")
                        .bold()
                        .font(Font.custom("Arial Hebrew", size: 23))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 25)
                    
                    Text("You will be returned to the 'choose audio page' and progress on this exercise will be lost.")
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 25)
                    
                    HStack{
                        Spacer()
                        NavigationLink(destination: chooseAudioIPAD(), label: {
                            Text("Yes")
                                .font(Font.custom("Arial Hebrew", size: 22))
                                .foregroundColor(Color.blue)
                        })
                        Spacer()
                        Button(action: {showUserCheck.toggle()}, label: {
                            Text("No")
                                .font(Font.custom("Arial Hebrew", size: 22))
                                .foregroundColor(Color.blue)
                        })
                        Spacer()
                    }.padding(.top, 25)
                    
                }
                
                
            }.frame(width: geo.size.width * 0.5, height: geo.size.height * 0.35)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.black, lineWidth: 3)
                )
                .padding([.leading, .trailing], geo.size.width * 0.25)
                .padding([.top, .bottom], geo.size.height * 0.35)
                
        }
        
    }
}

struct listeningActivityQuestionsIPAD_Previews: PreviewProvider {
    static let listeningActivityVM = ListeningActivityViewModel(audioAct: audioActivty.cosaDesidera)

    static var previews: some View {
        listeningActivityQuestionsIPAD(isPreview: false, listeningActivityVM: listeningActivityVM)
            .environmentObject(ListeningActivityManager())
            .environmentObject(AudioManager())
    }
}
