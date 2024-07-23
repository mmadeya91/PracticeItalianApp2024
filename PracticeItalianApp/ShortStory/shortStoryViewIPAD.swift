//
//  shortStoryViewIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/2/24.
//

import SwiftUI


struct shortStoryViewIPAD: View {
    @EnvironmentObject var audioManager: AudioManager
    
    @State var chosenStoryNameIn: String
    @State var progress: CGFloat = 0
    
    @State var showPopUpScreen: Bool = false
    @State var showQuestionDropdown: Bool = false
    
    @State var linkClickedString: String = "placeHolder"
    @State var questionNumber: Int = 0
    
    @State var storyHeight: CGFloat = 380
    
    @State var showShortStoryDragDrop = false
    
    @State var showEnglish = false
    
    @StateObject var shortStoryDragDropVM: ShortStoryDragDropViewModel
    
    var storyData: shortStoryData { shortStoryData(chosenStoryName: chosenStoryNameIn)}
    
    var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
    
    @State var questionBoxWidth = UIScreen.main.bounds.size.width
    
    
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment: .topLeading){
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .zIndex(0)
                
                HStack(spacing: 16){
                    Spacer()
                    NavigationLink(destination: availableShortStories(), label: {
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
                            progress = (CGFloat(newValue) / CGFloat(storyObj.questionList.count + 1))
                        }
                    
                    Image("italyFlag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                    Spacer()
                }.zIndex(1).frame(width: geo.size.width)
                

                
                
                //if showPopUpScreen{
                popUpViewIPAD(storyObj: self.storyObj, linkClickedString: self.$linkClickedString, showPopUpScreen: self.$showPopUpScreen).zIndex(2)
                    .padding([.leading, .trailing], geo.size.width * 0.2)
                    .offset(x: showPopUpScreen ? 0 : -950, y: (geo.size.height / 2) - 155)
                
                
                
                // }
                
                VStack(spacing: 0){
                    ZStack{
                        HStack{
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
                                    .frame(width: 30, height: 30)
                            })
                        }.frame(maxHeight: .infinity, alignment: .topTrailing).padding(.top, 30).padding(.trailing, 50).zIndex(2)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                         
                                Text(chosenStoryNameIn)
                                    .font(Font.custom("Arial Hebrew", size: geo.size.height * 0.034))
                                    .padding(.top, 30)
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: 220, height: 2)
                                        , alignment: .bottom
                                    ).zIndex(0)
                                    .padding(.leading, 10)
                
                            if !showEnglish {
                                Text(.init("    " + storyObj.storyString))
                                    .font(Font.custom("Arial Hebrew", size: geo.size.height * 0.025))
                                    .padding(.top, 40)
                                    .padding(.leading, 50)
                                    .padding(.trailing, 50)
                                    .lineSpacing(20)
                                    .environment(\.openURL, OpenURLAction { url in
                                        handleURL(url, name: url.valueOf("word")!)
                                        
                                    })
                            }else{
                                Text(.init("    " + storyObj.storyStringEnglish))
                                    .font(Font.custom("Arial Hebrew", size: geo.size.height * 0.025))
                                    .padding(.top, 40)
                                    .padding(.leading, 50)
                                    .padding(.trailing, 50)
                                    .lineSpacing(20)
                            }
                            
                        }
                        
                    }.frame(width: geo.size.width * 0.8).background(Color("WashedWhite")).cornerRadius(20).padding(.bottom, 25)
                        .padding(.top, 50)
                        .padding([.leading, .trailing], geo.size.width * 0.1)
                        .shadow(radius: 15)
                    
                    GroupBox{
                  
                        DisclosureGroup("Questions") {
      
                            VStack(spacing: 0){
                                
                                Text(storyObj.questionList[questionNumber].question)
                                    .multilineTextAlignment(.center)
                                    .padding([.leading,.trailing], 20)
                                    .padding()
                                    .padding(.top, 5)
                                    .frame(width: geo.size.width * 0.6)
                                    .border(width: 4, edges: [.bottom], color:Color("DarkNavy"))
                                    .padding(.bottom, 10)
                                
                                
                                radioButtonsMCIPAD(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.questionList[questionNumber].choices.shuffled(), totalQuestions: storyObj.questionList.count, questionNumber: $questionNumber, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress, questionBoxWidth: $questionBoxWidth)
                                    .padding([.top, .bottom], 15)
                                
                                
                            }
                            .frame(width: geo.size.width * 0.6)
                            .padding(.top, 10)
                            
                            
                        }
                        .tint(Color.black)
                        .font(Font.custom("Arial Hebrew", size: geo.size.height * 0.022))
                        .frame(width: geo.size.width * 0.6)
                   
                    
                    } .padding(.bottom, 25)
                        .padding(.top, 25)
                        .padding([.leading, .trailing], geo.size.width * 0.2)
                    
                    
                     
                    
                }.padding(.top, 60)
                    //.padding(.leading, 20)
                    .zIndex(1)
 
                    
                NavigationLink(destination:  ShortStoryDragDropViewIPAD(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: false, shortStoryName: chosenStoryNameIn),isActive: $showShortStoryDragDrop,label:{}
                                                      ).isDetailLink(false)
                    
            }.onAppear{
                questionBoxWidth = geo.size.width * 0.6
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func handleURL(_ url: URL, name: String) -> OpenURLAction.Result {
        linkClickedString = name
        withAnimation(.easeIn(duration: 0.75)){
            showPopUpScreen.toggle()
        }
        return .handled
    }
    
}


struct popUpViewIPAD: View{
    
    var storyObj: shortStoryObject
    
    @Binding var linkClickedString: String
    @Binding var showPopUpScreen: Bool
    
    var body: some View{
        
        let wordLink: WordLink = storyObj.collectWordExpl(ssO: storyObj, chosenWord: linkClickedString)
        
        
        
        ZStack{
            HStack{
                Button(action: {
                    withAnimation(.easeIn(duration: 0.75)){
                        showPopUpScreen.toggle()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .frame(width: 25, height: 25)
                    
                })
                Spacer()
            }.frame(maxHeight: .infinity, alignment: .topLeading).padding(.top, 25).padding(.leading, 25)
            VStack{
                
                
                Text(wordLink.infinitive)
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 30))
                    .foregroundColor(Color.black)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                    .underline()
                
                
                Text(wordLink.wordNameEng)
                    .font(Font.custom("Arial Hebrew", size: 25))
                    .foregroundColor(Color.black)
                    .padding([.leading, .trailing], 5)
                
                
                if wordLink.explanation != "" {
                    Text(wordLink.explanation)
                        .font(Font.custom("Arial Hebrew", size: 25))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                        .padding([.leading, .trailing], 5)
                    
                    
                    
                }
                
                
                
            }.zIndex(0)
        }.frame(width: UIScreen.main.bounds.width * 0.6, height: 300)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 3)
            )
        
    }
}


struct radioButtonsMCIPAD: View {
    
    var correctAnswer: String
    var choicesIn: [String]
    var totalQuestions: Int
    
    @State var correctChosen: Bool = false
    @Binding var questionNumber: Int
    @Binding var showShortStoryDragDrop: Bool
    @Binding var progress: CGFloat
    @Binding var questionBoxWidth: CGFloat
    
    var body: some View{
        VStack(spacing: 15) {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctShortStoryButtonIPAD(choice: choicesIn[i], totalQuestions: totalQuestions, questionNumber: $questionNumber, correctChosen: $correctChosen, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress, questionBoxWidth: $questionBoxWidth)
                        //.padding(.bottom, 5)
                } else {
                    incorrectShortStoryButtonIPAD(choice: choicesIn[i], correctChosen: $correctChosen, questionBoxWidth: $questionBoxWidth, questionNumber: $questionNumber)
                        //.padding(.bottom, 5)
                }
            }
        }
        
        
    }
}

struct correctShortStoryButtonIPAD: View {
    
    var choice: String
    var totalQuestions: Int
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State private var pressed: Bool = false
    @State var changeCorrectColor = false
    @State var isEnabled = true
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var showShortStoryDragDrop: Bool
    @Binding var progress: CGFloat
    @Binding var questionBoxWidth: CGFloat
   
    
    var body: some View{
        

        Button(action: {
            changeCorrectColor = true
            isEnabled = false
   
          
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                
                if questionNumber != totalQuestions - 1 {
                    questionNumber = questionNumber + 1

                }else{
                    progress = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showShortStoryDragDrop = true
                    }
                    
                }
                
            }
            
            
    
         

        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 23))
                    .padding(.top, 3)
                   
                
            }.padding([.leading, .trailing], 10).frame(width:questionBoxWidth - 20, height: 40)
        })
        .frame(width:questionBoxWidth - 40, height: 50)
        .background(changeCorrectColor ? .green : .teal)
        .foregroundColor(Color.black)
        .cornerRadius(15)
        .scaleEffect(pressed ? 1.10 : 1.0)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .onChange(of: questionNumber) {newValue in
            changeCorrectColor = false
            isEnabled = true
        }
        .padding([.leading, .trailing], 10)
        .onLongPressGesture(minimumDuration: 0.1, maximumDistance: .infinity, pressing: { pressing in
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



struct incorrectShortStoryButtonIPAD: View {
    
    var choice: String
    
    @State var enableButton = true
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var selected = false
    @State var wrongChosen = false
    @Binding var correctChosen: Bool
    @Binding var questionBoxWidth: CGFloat
    @Binding var questionNumber: Int
    
    var body: some View{
        

        Button(action: {
            wrongChosen = true
            enableButton = false
            SoundManager.instance.playSound(sound: .wrong)
            
            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                selected.toggle()
            }
            
            selected.toggle()
        
        
        
        
            
        }, label: {
            
            HStack{
                Text(choice)
                    .font(Font.custom("Arial Hebrew", size: 23))
                    .padding(.top, 5)
             
 
            }.padding([.leading, .trailing], 20)
        })
        .frame(width:questionBoxWidth - 40, height: 50)
        .background(wrongChosen ? .red : .teal)
        .foregroundColor(Color.black)
        .cornerRadius(15)
        .offset(x: selected ? -5 : 0)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .padding([.leading, .trailing], 10)
        .onChange(of: questionNumber) { newValue in
            wrongChosen = false
            enableButton = true
        }
        .enabled(enableButton)

    }

    
}

struct textModiferIPAD : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Hebrew", size: 18))
            .padding(.top, 40)
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .lineSpacing(20)
        
    }
}


struct shortStoryViewIPAD_Previews: PreviewProvider {
    static var previews: some View {
        shortStoryViewIPAD(chosenStoryNameIn: "La Mia Introduzione", shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: "La Mia Introduzione"))
            .environmentObject(AudioManager())
    }
}
