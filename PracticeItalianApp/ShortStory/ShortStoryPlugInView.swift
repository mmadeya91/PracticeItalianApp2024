//
//  ShortStoryPlugInView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 9/7/23.
//


import SwiftUI
import WrappingHStack

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

struct ShortStoryPlugInView: View{
    
    @StateObject var shortStoryPlugInVM: ShortStoryViewModel
    @ObservedObject var globalModel = GlobalModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var questionNumber = 0
    @State var shortStoryName: String
    @State var showPlayer = false
    @State var isPreview: Bool
    @State var progress: CGFloat = 0
    @State var correctChosen: Bool = false
    @State var animateBear: Bool = false
    @State var selected: Bool = false
    @State var showUserCheck: Bool = false
    @State var showFinishedActivityPage = false
    @State var showContinue = false
    @State var showInfoPopUp = false
    
    @State var showHint = false
    @State var showingSheet = false
    @State var showEnglish = false
    
    @State var progress2 = 0
    
    var infoManager = InfoBubbleDataManager(activityName: "plugInShortStory")
    
    @State var correctRandomInt = 0
    var body: some View{
        GeometryReader {geo in
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
                    
                    ZStack(alignment: .topLeading){
                        HStack{
                            Button(action: {
                                withAnimation(.easeIn(duration: 0.25)){
                                    showInfoPopUp.toggle()
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 25))
                                    .foregroundColor(.black)
                                
                            })
                        }.frame(maxHeight: .infinity, alignment: .topLeading).padding(15).padding(.top, 10)
                        
                        VStack{
                            
                            
                            Text("Try to complete the sentence by choosing the correct word to fill the blank. If you are stuck, hints are available to you. If you need to reference the short story or keywords/ideas, you may do so by clicking the book icon in the bottom left corner.")
                                .font(Font.custom("Georgia", size: geo.size.height * 0.027))
                                .multilineTextAlignment(.center)
                                .padding(25)
                        }.padding(.top, 50)
                    }.frame(width: geo.size.width * 0.82, height: geo.size.width * 0.82)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .shadow(radius: 20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 3)
                        )
                        .opacity(showInfoPopUp ? 1.0 : 0.0)
                        .offset(x: ((geo.size.width / 2) - geo.size.width * 0.4), y: (geo.size.height / 2) - geo.size.width * 0.5)
                        .zIndex(2)
                    
                    HStack(spacing: 0){
                        Spacer()
                        Text("Complete the Sentence")
                            .font(Font.custom("Georgia", size: geo.size.height * 0.027))
                            .padding(.bottom, 15)
                            .padding(.top, 45)
                        
                        PopOverView(textIn: "Try to complete the sentence by choosing the correct word to fill the blank. If you are stuck, hints are available to you.", infoBubbleColor: Color.black, frameHeight: CGFloat(180), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch).offset(y: 15)
                        Spacer()
                    }.offset(y: 40).zIndex(1)
                        
                     
                     
                    
                    VStack{
                        Spacer()
                        HStack{
                            Button(action: {
                                withAnimation(Animation.spring()){
                                    showingSheet.toggle()
                                }
                            }, label: {
                                Image(systemName: "book.closed.fill")
                                    .foregroundColor(.black)
                                    .font(.system(size: 35))
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(width: 35, height: 35)
                            })
                        }
                    }.zIndex(1).padding(.bottom, 15).padding(.leading, 40)
                    
                    HStack(spacing: 18){
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)){
                                showUserCheck.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        }).zIndex(1)
                        
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
                                progress = (CGFloat(newValue + 1) / CGFloat(shortStoryPlugInVM.currentPlugInQuestions.count + 1))
                            }
                                            
                                            
                                            
                                            
         
                        
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                        Spacer()
                    }.zIndex(1)
                    
                    
                    HStack{
                        Spacer()
                        if !showContinue {
                            if showHint == true{
                                Text(showHint ? shortStoryPlugInVM.currentHints[questionNumber] : "Hint")
                                    .font(Font.custom("Georgia", size: 17))
                                    .foregroundColor(.black)
                                    .padding(25)
                                    .padding(.top, 5)
                                    .frame(height: 40)
                            }else{
                                Button(action: {
                                    
                                    showHint = true
                                    
                                }, label: {
                                    Text("Hint")
                                        .font(Font.custom("Georgia", size: 17))
                                        .foregroundColor(.black)
                                    
                                }).buttonStyle(ThreeDButton(backgroundColor: "white"))
                                    .frame(width: 90, height: 40)
                            }
                        }else{
                          
                            
                            Button(action: {
                                questionNumber += 1
                                showContinue = false
                            }, label: {
                                Text("Next")
                                    //.bold()
                                    .font(Font.custom("Georgia", size:17))
                                    //.padding()
                                    .foregroundColor(.black)
                            }).buttonStyle(ThreeDButton(backgroundColor: "white"))
                                .frame(width: 90, height: 40)
                        }

                            
                        Spacer()
                    }.zIndex(2)
                        .padding(.top, geo.size.height * 0.68)
                    
                    
               
//                    
//                    Image("bearHead")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geo.size.height * 0.1, height: geo.size.height * 0.1)
//                        .offset(x: geo.size.width - geo.size.width * 0.35, y: geo.size.height - geo.size.height * 0.12)
//                        .opacity(correctChosen ? 1.0 : 0.0)
                    
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
                    
                    
                   
                        userCheckNavigationPopUpPlugIn(showUserCheck: $showUserCheck)
                            .opacity(showUserCheck ? 1.0 : 0.0)
                            .zIndex(2)
                          
                
                    
                    ScrollViewReader{scroller in
                        VStack{
                            
                            ScrollView(.horizontal){
                                
                                HStack{
                                    ForEach(0..<shortStoryPlugInVM.currentPlugInQuestions.count, id: \.self) { i in
                                        VStack{
                                            
                                            
                                            
                                            ShortStoryPlugInViewBuilder(plugInQuestion: shortStoryPlugInVM.currentPlugInQuestions[i], plugInChoices: shortStoryPlugInVM.currentPlugInQuestionsChoices[i], correctRandomInt: $correctRandomInt,questionNumber: $questionNumber, selected: $selected, correctChosen: $correctChosen, showHint: $showHint, progress2: $progress2, showContinue: $showContinue, totalQuestions: shortStoryPlugInVM.currentPlugInQuestions.count).frame(width: geo.size.width)
                                                .frame(minHeight: geo.size.height)
                                            
                                        }
                                        
                                    }
                                }
                                
                            }.offset(y: -85)
                                .scrollDisabled(true)
                                .onChange(of: questionNumber) { newIndex in
                                    if questionNumber == shortStoryPlugInVM.currentPlugInQuestions.count  {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                            
                                            showFinishedActivityPage = true
                                        }
                                    }else{
                                        
                                        withAnimation{
                                            scroller.scrollTo(newIndex, anchor: .center)
                                        }
                                    }
                                    
                      
                                }
                            
                            
                        }.zIndex(2)
    
                        
                        NavigationLink(destination:  ActivityCompleteShortStory(finishedStoryName: shortStoryPlugInVM.currentStory),isActive: $showFinishedActivityPage,label:{}
                        ).isDetailLink(false).id(UUID())
                        
                    }
                    .sheet(isPresented: $showingSheet) {
                        SheetViewPlugIn(chosenStoryNameIn: shortStoryName, showEnglish: showEnglish, shortStoryDragDropVM: shortStoryPlugInVM)
                    }
                    .onDisappear{
                                    infoManager.updateCorrectInput(activity: infoManager.getActivityFirstLaunchData())
                                }
                    .onAppear{
                        if isPreview {
                            shortStoryPlugInVM.setShortStoryData()
                            
                        }
                        shortStoryPlugInVM.setShortStoryData()
                        withAnimation(.spring()){
                            animateBear = true
                        }
                    }.offset(x: selected ? -5 : 0)
                }.navigationBarBackButtonHidden(true)
                    
            }else{
                ShortStoryPlugInViewIPAD(shortStoryPlugInVM: shortStoryPlugInVM, shortStoryName: shortStoryName, isPreview: false)
            }
        }
    }
    
    struct incorrectPlugInButton: View{
        @Binding var selected: Bool
        @State var pressed = false
        
        var wrongAnswer: String
        
        var body: some View {
            Button(action: {
                pressed = true
                withAnimation((Animation.default.repeatCount(5).speed(6))) {
                    selected.toggle()
                }
                
                selected.toggle()
                SoundManager.instance.playSound(sound: .wrong)
            },label: {
                Text(wrongAnswer)
                    .font(Font.custom("ArialHebrew", size: 14))
                    .padding(9)
                    .padding([.leading, .trailing], 8)
                    //.padding(.top, 4)
                    .foregroundColor(.black)
                    .background(
                        ZStack{
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(pressed ? Color("darkTerracotta") : Color("themeGray"))
                            
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(pressed ? Color("terracotta") : .white)
                                .offset(y: -4)
                        }
                    )
                
                
                
            })//.shadow(radius: 1)
        }
    }
    
    
    
    struct ShortStoryPlugInViewBuilder: View {
        var plugInQuestion: FillInBlankQuestion
        var plugInChoices: [pluginShortStoryCharacter]
        @Binding var correctRandomInt: Int
        
        @Binding var questionNumber: Int
        
        @State private var frames: [CGRect] = [CGRect]()
        
        @State var characters: [plugInCharacter] = []
        @State var shuffledRows: [[plugInCharacter]] = []
        
        @State private var correctAnswers: [String] = ["nasce"]
        @State private var animateCorrect = false
        
        @Namespace private var namespace
        
        @State private var fillingBlank = false
        @State private var answer = "placeHolder"
        @Binding var selected: Bool
        @Binding var correctChosen: Bool
        @Binding var showHint: Bool
        @Binding var progress2: Int
        @Binding var showContinue: Bool
        @State var wrongChosen = false
        
        var totalQuestions: Int
        
        func setCharacterData(){
            var tempArray: [plugInCharacter] = []
            for i in 0...plugInChoices.count - 1 {
                tempArray.append(plugInCharacter(value: plugInChoices[i].value, isCorrect: plugInChoices[i].isCorrect))
                
            }
            
            characters = tempArray
        }
        
        func generateGrid()->[[plugInCharacter]]{
            for item in characters.enumerated() {
                let textSize = textSize(character: item.element)
                
                characters[item.offset].textSize = textSize
                
            }
            
            var gridArray: [[plugInCharacter]] = []
            var tempArray: [plugInCharacter] = []
            
            var currentWidth: CGFloat = 0
            
            let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 35
            
            for character in characters {
                currentWidth += character.textSize
                
                if currentWidth < totalScreenWidth{
                    tempArray.append(character)
                }else {
                    gridArray.append(tempArray)
                    tempArray = []
                    currentWidth = character.textSize
                    tempArray.append(character)
                }
            }
            
            if !tempArray.isEmpty{
                gridArray.append(tempArray)
            }
            
            return gridArray
        }
        
        func textSize(character: plugInCharacter)->CGFloat{
            let font = UIFont.systemFont(ofSize: character.fontSize)
            
            let attributes = [NSAttributedString.Key.font : font]
            
            let size = (character.value as NSString).size(withAttributes: attributes)
            
            return size.width + (character.padding * 2) + 15
        }
        
        
        func buttonForAnswer(correctAnswer: String) -> some View {
            Button(action: {
                answer = correctAnswer
                withAnimation(.linear(duration: 1)) {
                    fillingBlank = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    withAnimation(.easeIn(duration: 1.0)){
                        if questionNumber != totalQuestions  {
                            progress2 = progress2 + 1
                            
                        }else{
                            progress2 = totalQuestions
                            
                            
                            
                        }
                    }
                    
                }
              
             
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
                    
                    
                    if questionNumber != totalQuestions  {
                        //questionNumber = questionNumber + 1
                        showContinue = true
                        correctChosen = false
                        showHint = false

                    }else{
                        
                           // showPlayer = true
                        
                        
                    }
                    
                }


                SoundManager.instance.playSound(sound: .correct)
                correctRandomInt = Int.random(in: 1..<4)
                correctChosen = true
            },label: {
                Text(correctAnswer)
                    .font(Font.custom("Georgia", size: 14))
                    .padding(9)
                    .padding([.leading, .trailing], 8)
                    .offset(y: -2)
                    .foregroundColor(.black)
                    .background(
                        ZStack{
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                            
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                .offset(y: -4)
                        }
                    )//.shadow(radius: 1)
                   
                
                
            })
            .opacity(fillingBlank ? 0.0 : 1)
            .background {
                
                // This is the text that floats to the blank space
                Text(correctAnswer)
                    .font(Font.custom("Georgia", size:  fillingBlank ? 14 : 14))
                    .foregroundColor(fillingBlank ? Color("ForestGreen") : Color.black)
                   // .font(Font.custom("ArialHebrew", size: 14))
                    .padding(4.5)
                    .padding([.leading, .trailing], 5)
                    .padding(.bottom, 5)
                    .foregroundColor(.black)
                    .background(
                        ZStack{
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                            
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                .offset(y: -4)
                        }
                    ).compositingGroup()
                    .matchedGeometryEffect(
                        id: answer == correctAnswer && fillingBlank ? correctAnswer : correctAnswer,
                        in: namespace,
                        properties: .position,
                        isSource: false
                    )
            }
           
        }
        
//        func buttonForIncorrect(wrongAnswer: String) -> some View {
//            Button(action: {
//                withAnimation((Animation.default.repeatCount(5).speed(6))) {
//                    selected.toggle()
//                }
//                
//                selected.toggle()
//                SoundManager.instance.playSound(sound: .wrong)
//            },label: {
//                Text(wrongAnswer)
//                    .font(Font.custom("ArialHebrew", size: 14))
//                    .padding(9)
//                    .padding([.leading, .trailing], 8)
//                    //.padding(.top, 4)
//                    .foregroundColor(.black)
//                    .background(
//                        ZStack{
//                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
//                            
//                            
//                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
//                                .offset(y: -4)
//                        }
//                    )
//                
//                
//                
//            })//.shadow(radius: 1)
//        }
        
        var body: some View {
            
            
            GeometryReader { geo in
                ZStack{
                    
                    VStack{
                        VStack{
                            let sentenceArray: [String] = plugInQuestion.question.components(separatedBy: " ")
                            
                            WrappingHStack(0..<sentenceArray.count, id:\.self) {i in
                                
                                if plugInQuestion.missingWords.contains(sentenceArray[i]) {
                                    
                                    if sentenceArray[i].elementsEqual(plugInQuestion.missingWords[0]){
                                        missingTextView(numberOfWords: plugInQuestion.missingWords.count, sentenceArray: sentenceArray, i: i, fillingBlank: $fillingBlank, namespace: namespace)
                                    }
                                    
                                    
                                }else {
                                    Text(String(sentenceArray[i]))
                                        .font(Font.custom("Georgia", size: 17))
                                        .padding(1)
                                        .padding(.top, 6)
                                }
                            }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.125)
                                .frame(maxHeight: .infinity, alignment: .topLeading)
                                .padding([.leading, .trailing], 12)
                                .padding(.top, 10)
                            
                            
                        }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.2)
                            .background(Color("WashedWhite").opacity(0.0))
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(.black, lineWidth: 3)
//                            )
                            .padding([.leading, .trailing], geo.size.width * 0.05)
                        
                        VStack(spacing: 25) {
                            ForEach(shuffledRows, id: \.self){row in
                                HStack(spacing:20){
                                    ForEach(row){item in
                                        if item.isCorrect {
                                            buttonForAnswer(correctAnswer: item.value).shadow(radius: 0.75)
                                        }else{
                                            incorrectPlugInButton(selected: $selected, wrongAnswer: item.value).shadow(radius: 0.75)
                                        }
                        
                                    }
                                }
                                
                            }
                            
                        }.padding(.top, 40)
                        
                        
                        
                    }.frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                    
                    
                    
                    
                }.onAppear{
                    setCharacterData()
                    shuffledRows = generateGrid()
                }
                
                
            }.offset(x: selected ? -5 : 0)
        }
        
        struct missingTextView: View{
     
            var numberOfWords: Int
            var sentenceArray: [String]
            var i: Int
            
            @Binding var fillingBlank: Bool
            
            let namespace: Namespace.ID
            
            var body: some View{
                
                switch numberOfWords {
                case 1:
                    Text(sentenceArray[i])
                        .font(Font.custom("Georgia", size: 20))
                        .foregroundColor(.secondary.opacity(0.0))
                        .opacity(fillingBlank ? 0 : 1)
                        .background(alignment: .bottom) {
                            VStack {
                                Divider().background(.primary)
                                    .opacity(fillingBlank ? 0 : 1)
                            }
                        }
                        .matchedGeometryEffect(
                            id: sentenceArray[i],
                            in: namespace,
                            isSource: fillingBlank
                        )
                        .padding(.top, 5)
                case 2:
                    Text(sentenceArray[i] + sentenceArray[i+1])
                        .font(Font.custom("Georgia", size: 20))
                        .foregroundColor(.secondary.opacity(0.0))
                        .opacity(fillingBlank ? 0 : 1)
                        .background(alignment: .bottom) {
                            VStack {
                                Divider().background(.primary)
                                    .opacity(fillingBlank ? 0 : 1)
                            }
                        }
                        .matchedGeometryEffect(
                            id: sentenceArray[i] + " " + sentenceArray[i+1],
                            in: namespace,
                            isSource: fillingBlank
                        )
                        .padding(.top, 5)
                case 3:
                    Text(sentenceArray[i] + sentenceArray[i+1] + sentenceArray[i+2])
                        .font(Font.custom("Georgia", size: 20))
                        .foregroundColor(.secondary.opacity(0.0))
                        .opacity(fillingBlank ? 0 : 1)
                        .background(alignment: .bottom) {
                            VStack {
                                Divider().background(.primary)
                            }
                        }
                        .matchedGeometryEffect(
                            id: sentenceArray[i] + " " + sentenceArray[i+1] + " " + sentenceArray[i+1],
                            in: namespace,
                            isSource: fillingBlank
                        )
                        .padding(.top, 5)
                default:
                    
                    Text(sentenceArray[i])
                        .font(Font.custom("Georgia", size: 20))
                        .foregroundColor(.secondary.opacity(0.0))
                        .opacity(fillingBlank ? 0 : 1)
                        .background(alignment: .bottom) {
                            VStack {
                                Divider().background(.primary)
                            }
                        }
                        .matchedGeometryEffect(
                            id: sentenceArray[i],
                            in: namespace,
                            isSource: fillingBlank
                        )
                        .padding(.top, 5)
                }
                
            }
        }
        
        
    }
    
    struct userCheckNavigationPopUpPlugIn: View{
        @Binding var showUserCheck: Bool
        
        var body: some View{
            
            
            GeometryReader{ geo in
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
                        
                        Text("You will be returned to the 'select story page' and progress on this exercise will be lost")
                            .font(Font.custom("Georgia", size: geo.size.width * 0.04))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                            .padding([.leading, .trailing], 15)
                        
                        HStack{
                            Spacer()
                            NavigationLink(destination: availableShortStories(), label: {
                                Text("Yes")
                                    .font(Font.custom("Georgia", size: geo.size.width * 0.04))
                                    .foregroundColor(Color.black)
                            }).id(UUID()).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 70, height: 35)
                            Spacer()
                            Button(action: {showUserCheck.toggle()}, label: {
                                Text("No")
                                    .font(Font.custom("Georgia", size: geo.size.width * 0.04))
                                    .foregroundColor(Color.black)
                            }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 70, height: 35)
                            Spacer()
                        }.padding(.top, 15)
                        
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
    
    
}

struct SheetViewPlugIn: View{
    @Environment(\.dismiss) var dismiss
    
    @State var chosenStoryNameIn: String
 
    @State var showPopUpScreen: Bool = false
    
    @State var linkClickedString: String = "placeHolder"
    @State var questionNumber: Int = 0
    
    @State var showEnglish = false
    @State var geoSizeWidth = UIScreen.main.bounds.width
    
    @StateObject var shortStoryDragDropVM: ShortStoryViewModel
    
    var storyData: shortStoryData { shortStoryData(chosenStoryName: chosenStoryNameIn)}
    
    var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
    
   
    
    var body: some View {
        
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
                
                
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    
                    Text(chosenStoryNameIn)
                        .font(Font.custom("Georgia", size: 22))
                        .padding(.top, 30)
                        .overlay(
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 190, height: 1)
                            , alignment: .bottom
                        ).zIndex(0)
                        .padding(.leading, 10)
                    
                    
                    
                    
                    
                    
                    if !showEnglish {
                        Text(.init(storyObj.storyString))
                            .modifier(textModifer())
                            .environment(\.openURL, OpenURLAction { url in
                                handleURL(url, name: url.valueOf("word")!)
                                
                            })
                    }else{
                        Text(.init(storyObj.storyStringEnglish))
                            .modifier(textModifer())
                    }
                    
                }.padding(.top, 70).offset(y:30)
                
                popUpView(storyObj: self.storyObj, linkClickedString: self.$linkClickedString, showPopUpScreen: self.$showPopUpScreen, geoSizeWidth: $geoSizeWidth).zIndex(2).opacity(showPopUpScreen ? 1.0 : 0)
                    .offset(y: (geo.size.height / 2) - 155).padding([.leading, .trailing], geo.size.width * 0.1)
                
            }
        }
    }

                
                    
        
    
    
    func handleURL(_ url: URL, name: String) -> OpenURLAction.Result {
        linkClickedString = name
        withAnimation(.easeIn(duration: 0.75)){
            showPopUpScreen.toggle()
        }
        return .handled
    }
    
}

struct plugInCharacter: Identifiable, Hashable, Equatable {
    var id = UUID().uuidString
    var value: String
    var padding: CGFloat = 10
    var textSize: CGFloat = .zero
    var fontSize: CGFloat = 17
    var isCorrect: Bool
}




struct ShortStoryPlugInView_Previews: PreviewProvider {
    static var shortStoryPlugInVM = ShortStoryViewModel(currentStoryIn: "Il Mio Fine Settimana")
    static var previews: some View {
        ShortStoryPlugInView(shortStoryPlugInVM: shortStoryPlugInVM, shortStoryName: "Il Mio Fine Settimana", isPreview: true).environmentObject(GlobalModel())
    }
}


