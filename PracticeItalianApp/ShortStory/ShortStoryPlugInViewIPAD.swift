//
//  ShortStoryPlugInView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 9/7/23.
//


import SwiftUI
import WrappingHStack

struct ShortStoryPlugInViewIPAD: View{
    
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
    
    @State var showHint = false
    
    var body: some View{
        GeometryReader {geo in
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
                            
                        }).zIndex(1)
                        
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
                                progress = (CGFloat(newValue) / CGFloat(shortStoryPlugInVM.currentPlugInQuestions.count))
                            }
                        
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Spacer()
                    }.zIndex(2)
                    
               
                        RoundedRectangle(cornerRadius: 20)
                        .fill(Color("DarkNavy").opacity(0.9))
                            .frame(width: geo.size.width * 0.93, height: geo.size.height * 0.35)
                            .zIndex(0)
                            .padding([.leading, .trailing], geo.size.width * 0.035)
                            .padding([.top, .bottom], geo.size.height * 0.3)
                            .shadow(radius: 15)
                    
                    HStack{
                        Spacer()
                        Text(showHint ? shortStoryPlugInVM.currentHints[questionNumber] : "Give me a Hint!")
                            .font(Font.custom("Arial Hebrew", size: 25))
                            .padding(25)
                            .padding(.top, 5)
                            .frame(height: 60)
                            .background(Color("WashedWhite")).cornerRadius(25)
                            .shadow(radius: 15)
                            .onTapGesture{
                                withAnimation(.easeIn(duration: 1)){
                                    showHint = true
                                }
                            }
                            
                            .zIndex(2)
                        Spacer()
                    }.frame(width: geo.size.width).zIndex(2)
                        .padding(.top, geo.size.height * 0.7)
                    
                       
               
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.35)
                        .offset(x: geo.size.width - geo.size.width * 0.4, y: animateBear ? geo.size.height - geo.size.height * 0.125 : 9000)
                        .zIndex(0)
                    
                    if correctChosen{
                        
                        let randomInt = Int.random(in: 1..<4)
                        
                        Image("bubbleChatRight"+String(randomInt))
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.height * 0.14, height: geo.size.height * 0.14)
                            .offset(x: geo.size.width - geo.size.width * 0.5, y: geo.size.height - geo.size.height * 0.16)
                    }
                    
                    
                    if showUserCheck {
                        userCheckNavigationPopUpPlugInIPAD(showUserCheck: $showUserCheck)
                            .transition(.slide)
                            .animation(.easeIn)
                            .zIndex(2)
                           
                    }
                    
                    ScrollViewReader{scroller in
                        VStack{
                            Text("Find the missing word")
                                .font(.system(size: 25))
                                .bold()
                                .offset(y: 150)
                            
                            ScrollView(.horizontal){
                                
                                HStack{
                                    ForEach(0..<shortStoryPlugInVM.currentPlugInQuestions.count, id: \.self) { i in
                                        VStack(spacing: 0){

                                            
                                            ShortStoryPlugInViewBuilderIPAD(plugInQuestion: shortStoryPlugInVM.currentPlugInQuestions[i], plugInChoices: shortStoryPlugInVM.currentPlugInQuestionsChoices[i],questionNumber: $questionNumber, selected: $selected, correctChosen: $correctChosen, showHint: $showHint)
                                            
                                               
                                            
                                            
                                        }.frame(width: geo.size.width, height: geo.size.height * 0.8)
                                            .padding([.top, .bottom], geo.size.height * 0.1)
                                          
                                        
                                    }
                                }
                                
                            }.offset(y: -185)
                                .scrollDisabled(true)
                                .onChange(of: questionNumber) { newIndex in
                                    if questionNumber == shortStoryPlugInVM.currentPlugInQuestions.count {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                            
                                            showFinishedActivityPage = true
                                        }
                                    }else{
                                        
                                        withAnimation{
                                            scroller.scrollTo(newIndex, anchor: .center)
                                        }
                                    }
                                    
                      
                                }
                            
                            
                        }.zIndex(2)
    
                        
                        NavigationLink(destination:  ActivityCompletePageIPAD(),isActive: $showFinishedActivityPage,label:{}
                        ).isDetailLink(false)
                        
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
                    
        }
    }
    
    
    
    
    struct ShortStoryPlugInViewBuilderIPAD: View {
        var plugInQuestion: FillInBlankQuestion
        var plugInChoices: [pluginShortStoryCharacter]
        
        @Binding var questionNumber: Int
        
        @State private var frames: [CGRect] = [CGRect]()
        
        @State private var correctAnswers: [String] = ["nasce"]
        @State private var animateCorrect = false
        
        @Namespace private var namespace
        
        @State private var fillingBlank = false
        @State private var answer = "placeHolder"
        @Binding var selected: Bool
        @Binding var correctChosen: Bool
        @Binding var showHint: Bool
        
        func buttonForAnswer(correctAnswer: String) -> some View {
            Button(action: {
                answer = correctAnswer
                withAnimation(.linear(duration: 1)) {
                    fillingBlank = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    
                    questionNumber += 1
                    correctChosen = false
                    showHint = false
                }
                SoundManager.instance.playSound(sound: .correct)
                correctChosen = true
            },label: {
                Text(correctAnswer)
                    .font(Font.custom("ArialHebrew", size: 30))
                    .padding(9)
                    .padding([.leading, .trailing], 8)
                    .padding(.top, 4)
                    .foregroundColor(.black)
                    .background(Color("WashedWhite")).cornerRadius(20).shadow(radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                    )
                    .shadow(radius: 10)
                
                
            })
            .opacity(fillingBlank ? 0.0 : 1)
            .background {
                
                // This is the text that floats to the blank space
                Text(correctAnswer)
                    .font(Font.custom("ArialHebrew", size: 28))
                    .foregroundColor(fillingBlank ? Color("pastelGreen") : Color.black)
                    .matchedGeometryEffect(
                        id: answer == correctAnswer && fillingBlank ? correctAnswer : correctAnswer,
                        in: namespace,
                        properties: .position,
                        isSource: false
                    )
            }
        }
        
        func buttonForIncorrect(wrongAnswer: String) -> some View {
            Button(action: {
                withAnimation((Animation.default.repeatCount(5).speed(6))) {
                    selected.toggle()
                }
                
                selected.toggle()
                SoundManager.instance.playSound(sound: .wrong)
            },label: {
                Text(wrongAnswer)
                    .font(Font.custom("ArialHebrew", size: 30))
                    .padding(9)
                    .padding([.leading, .trailing], 8)
                    .padding(.top, 4)
                    .foregroundColor(.black)
                    .background(Color("WashedWhite")).cornerRadius(20).shadow(radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.black, lineWidth: 1)
                    )
                    .shadow(radius: 10)
                
                
            })
        }
        
        var body: some View {
            
            
            GeometryReader { geo in
                ZStack{
                    
                    VStack{
                        VStack{
                            let sentenceArray: [String] = plugInQuestion.question.components(separatedBy: " ")
                            
                            WrappingHStack(0..<sentenceArray.count, id:\.self) {i in
                                
                                
                                if plugInQuestion.missingWords.contains(sentenceArray[i]) {
                                    
                                    if sentenceArray[i].elementsEqual(plugInQuestion.missingWords[0]){
                                        missingTextViewIPAD(numberOfWords: plugInQuestion.missingWords.count, sentenceArray: sentenceArray, i: i, fillingBlank: $fillingBlank, namespace: namespace)
                                    }
                                    
                                    
                                }else {
                                    Text(String(sentenceArray[i]))
                                        .font(Font.custom("ArialHebrew", size: 28))
                                        .padding(1)
                                        .padding(.top, 6)
                                }
                            }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.125)
                                .frame(maxHeight: .infinity, alignment: .topLeading)
                                .padding([.leading, .trailing], 12)
                                .padding(.top, 10)
                              
                                //.offset(y: -30)
                               
                            
                        }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.2)
                            .background(Color("WashedWhite")).cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 3)
                            )
                            .padding([.leading, .trailing], geo.size.width * 0.05)
                          
                        VStack {
                            VStack{
                                HStack(spacing: 35) {
                                    
                                    ForEach(0..<3) {i in
                                        if plugInChoices[i].isCorrect {
                                            
                                            buttonForAnswer(correctAnswer: plugInChoices[i].value)
                                        }else{
                                            buttonForIncorrect(wrongAnswer: plugInChoices[i].value)
                                        }
                                    }
                                }
                                HStack(spacing: 35) {
                                    
                                    ForEach(3..<6) {i in
                                        if plugInChoices[i].isCorrect {
                                            
                                            buttonForAnswer(correctAnswer: plugInChoices[i].value)
                                        }else{
                                            buttonForIncorrect(wrongAnswer: plugInChoices[i].value)
                                        }
                                    }
                                }.padding(.top, 15)
                            }.padding([.leading, .trailing], 15)
                            
                        }.padding(.top, 40)
                        
                        
                        
                        
                    }.frame(width: geo.size.width)
                        .frame(minHeight: geo.size.height)
                    
                    
                    
                    
                }
                
                
            }.offset(x: selected ? -5 : 0)
        }
        
        struct missingTextViewIPAD: View{
     
            var numberOfWords: Int
            var sentenceArray: [String]
            var i: Int
            
            @Binding var fillingBlank: Bool
            
            let namespace: Namespace.ID
            
            var body: some View{
                
                switch numberOfWords {
                case 1:
                    Text(sentenceArray[i])
                        .font(Font.custom("ArialHebrew", size: 28))
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
                case 2:
                    Text(sentenceArray[i] + sentenceArray[i+1])
                        .font(Font.custom("ArialHebrew", size: 28))
                        .foregroundColor(.secondary.opacity(0.0))
                        .opacity(fillingBlank ? 0 : 1)
                        .background(alignment: .bottom) {
                            VStack {
                                Divider().background(.primary)
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
                        .font(Font.custom("ArialHebrew", size: 28))
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
                        .font(Font.custom("ArialHebrew", size: 28))
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
    
    struct userCheckNavigationPopUpPlugInIPAD: View{
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
                        
                        Text("You will be returned to the 'select story page' and progress on this exercise will be lost.")
                            .font(Font.custom("Arial Hebrew", size: 20))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                            .padding([.leading, .trailing], 25)
                        
                        HStack{
                            Spacer()
                            NavigationLink(destination: availableShortStories(), label: {
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
                    
                    
                }.frame(width: geo.size.width * 0.5, height: geo.size.height * 0.3)
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
    
}

struct ShortStoryPlugInViewIPAD_Previews: PreviewProvider {
    static var shortStoryPlugInVM = ShortStoryViewModel(currentStoryIn: "La Mia Famiglia")
    static var previews: some View {
        ShortStoryPlugInViewIPAD(shortStoryPlugInVM: shortStoryPlugInVM, shortStoryName: "La Mia Famiglia", isPreview: true).environmentObject(GlobalModel())
    }
}



