//
//  shortStoryView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/5/23.
//

import SwiftUI
import SwiftUIKit

extension Button {
    func onTapEnded(_ action: @escaping () -> Void) -> some View {
        buttonStyle(ButtonPressHandler(action: action))
    }
}

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct shortStoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var audioManager: AudioManager
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var globalModel: GlobalModel
    
    @State var chosenStoryNameIn: String
    @State var progress: CGFloat = 0
    @State var progress2 = 0
    
    @State var showPopUpScreen: Bool = false
    @State var showQuestionDropdown: Bool = false
    
    @State var linkClickedString: String = "placeHolder"
    @State var questionNumber: Int = 0
    
    @State var storyHeight: CGFloat = 380
    
    @State var showShortStoryDragDrop = false
    
    @State var showEnglish = false
    
    @State var geoSizeWidth = UIScreen.main.bounds.width
    
    @StateObject var shortStoryDragDropVM: ShortStoryDragDropViewModel
    
    var storyData: shortStoryData
    var storyObj: shortStoryObject
    
    @State var questionBoxWidth = UIScreen.main.bounds.size.width
    
    @FetchRequest(
        entity: LastStoryCompleted.entity(),
        sortDescriptors: [NSSortDescriptor(key: "id", ascending: true)]
    ) var fetchedLastStoryCompleted: FetchedResults<LastStoryCompleted>
    

    var infoManager = InfoBubbleDataManager(activityName: "shortStoryView")
    
    var body: some View {
        
        
        
        GeometryReader{ geo in
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
                    VStack{
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
                                    progress = (CGFloat(newValue + 1) / CGFloat(storyObj.questionList.count + 1))
                                }
                            
                            VStack{
                                Image("italy")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                
                                
                            }
                            Spacer()
                        }
                        HStack{
                            VStack(spacing: 15){
                                
                                Button(action: {
                                    withAnimation(.easeIn){
                                        showEnglish.toggle()
                                    }
                                }, label: {
                                    Image(systemName: showEnglish ? "eye.slash" : "eye")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundColor(.black)
                                        .frame(width: 12, height: 12)
                                }).offset(x:12)
                                    .offset(y:10)
                                    .buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 35, height: 30).padding(.top, 10)
                                
                                
                                
                                PopOverView(textIn: "Read the following story to the best of your ability and try to answer the comprehension questions below. \n\nThe story is filled with highlighted links for keywords that could be useful in later exercises. Press on these links to see a detailed explanation of that word. \n\nIf you want to see the translated text, toggle the eyeball icon in the top left of the screen", infoBubbleColor: Color.black, frameHeight: CGFloat(360), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch).offset(x: 10)
                            }
                            Spacer()
                        }
                
                            
                    }.onDisappear{
                        infoManager.updateCorrectInput(activity: infoManager.getActivityFirstLaunchData())
                    }
                    
   
                    popUpView(storyObj: self.storyObj, linkClickedString: self.$linkClickedString, showPopUpScreen: self.$showPopUpScreen, geoSizeWidth: $geoSizeWidth).zIndex(2).opacity(showPopUpScreen ? 1.0 : 0)
                        .offset(y: (geo.size.height / 2) - 155).padding([.leading, .trailing], geo.size.width * 0.1)
                    
                    
                    
                    //}
                    
                    VStack(spacing: 0){
                        ZStack{
                            VStack{
                                HStack(spacing: 0){
                                Text(chosenStoryNameIn)
                                    .font(.system(size: 24))
                                    .padding(.top, 30)
                                    .overlay(
                                        Rectangle()
                                            .fill(.black)
                                            .frame(width: chosenStoryNameIn.widthOfString(usingFont: UIFont.systemFont(ofSize: 25)), height: 2.25)
                                        , alignment: .bottom
                                    ).zIndex(0)
                                    .padding(.top, 25)
                                
                             
                                    .padding(.bottom, 1)
                                

     
                                    
                            }
                            
                    
                                
                                ScrollView(.vertical, showsIndicators: false) {
                                    
                                    
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
                                    
                                }
                                
                            }.frame(width: geo.size.width - 40).background(Color("WashedWhite").opacity(0.0)).cornerRadius(20)
                                .padding(.bottom, 5)
                        }
                        
                        GroupBox{
                            
                            DisclosureGroup("Questions") {
                                
                                VStack(spacing: 0){
                                    
                                    Text(storyObj.questionList[questionNumber].question)
                                        .font(Font.custom("Georgia", size: 17))
                                        .padding([.leading, .trailing], 5)
                                        .multilineTextAlignment(.center)
                                        .padding(15)
                                        .frame(width: geo.size.width - 37)
                                        .border(width: 4, edges: [.bottom], color:Color("espressoBrown"))
                                        .padding(.bottom, 10)
                                    
                                    
                                    radioButtonsMC(correctAnswer: storyObj.questionList[questionNumber].answer, choicesIn: storyObj.choicesList[questionNumber], totalQuestionCount: storyObj.questionList.count, questionNumber: $questionNumber, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress, questionBoxWidth: $questionBoxWidth, progress2: $progress2)
                                        .padding(.top, 10)
                                        .padding(.bottom, 16)
                                    
                                    
                                    
                                }
                                .frame(width: geo.size.width - 80)
                     
                                
                                
                                
                            }
                            .tint(Color.black)
                            .font(Font.custom("Arial Hebrew", size: 16))
                            .frame(width: geo.size.width - 70)
                           
                            
                        } .padding(.bottom, 15)
                            
                        
                        
                        
                        
                    }.padding(.top, 60)
                        .padding(.leading, 20)
                        .zIndex(1)
      
                    NavigationLink(destination:  ShortStoryClickDrop(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: false, shortStoryName: chosenStoryNameIn),isActive: $showShortStoryDragDrop,label:{}
                    ).isDetailLink(false).id(UUID())
                }.onAppear{
                    questionBoxWidth = geo.size.width - 60
                    geoSizeWidth = geo.size.width
                    updatedLastCompletedEntities()
                }
                    
                
            }else{
                shortStoryViewIPAD(chosenStoryNameIn: chosenStoryNameIn, shortStoryDragDropVM: shortStoryDragDropVM)
            }
        }.navigationBarBackButtonHidden(true)
    }
    

    
    func updatedLastCompletedEntities(){
        for entity in fetchedLastStoryCompleted{
            entity.setValue(chosenStoryNameIn, forKey: "storyName")
            entity.setValue(false, forKey: "didComplete")
            
            globalModel.lastStoryCompleted.storyName = chosenStoryNameIn
            globalModel.lastStoryCompleted.didComplete = false
                
        }
        
        do {
            try viewContext.save()
            print("saved!")
           } catch {
         print(error.localizedDescription)
     }
        
    }
    
    
    
    func handleURL(_ url: URL, name: String) -> OpenURLAction.Result {
        linkClickedString = name
        withAnimation(.easeIn(duration: 0.25)){
            showPopUpScreen.toggle()
        }
        return .handled
    }
    

    
}


struct popUpView: View{
    
    var storyObj: shortStoryObject
    
    @Binding var linkClickedString: String
    @Binding var showPopUpScreen: Bool
    @Binding var geoSizeWidth: CGFloat
    
    var body: some View{
        
        let wordLink: WordLink = storyObj.collectWordExpl(ssO: storyObj, chosenWord: linkClickedString)
        
        
        
        ZStack(alignment: .topLeading){
            VStack{
                HStack{
                    Button(action: {
                       
                            showPopUpScreen.toggle()
                        
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20)
                            .padding(7)
                            .padding(.leading, 5)
                        
                    })
                  Spacer()
                }.padding()
               
            }.zIndex(0)
          
            VStack{
                
                
                Text(wordLink.infinitive)
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 23))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    //.padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                    
                
                Rectangle()
                    .fill(Color("terracotta"))
                    .frame(width: 240, height: 4)
                    .offset(y: -5)
                
                
                Text(wordLink.wordNameEng)
                    .font(Font.custom("Arial Hebrew", size: 17))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 5)
                    .padding(.top, 10)
                
                
                if wordLink.explanation != "" {
                    
                    Text(wordLink.explanation)
                        .font(Font.custom("Arial Hebrew", size: 17))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 5)
                     
                        .padding([.leading, .trailing], 5)
                    
                    
                    
                }
                
                
                
            }.zIndex(1)
                .frame(width: geoSizeWidth * 0.75)
                .padding(.top, 15)
                .padding([.top, .bottom], 45)
                .padding([.leading, .trailing], geoSizeWidth * 0.0525)
        }.frame(width: geoSizeWidth * 0.8)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 3)
            )
        
    }
}


struct radioButtonsMC: View {
    
    var correctAnswer: String
    var choicesIn: [String]
    var totalQuestionCount: Int
    
    @State var correctChosen: Bool = false
    @Binding var questionNumber: Int
    @Binding var showShortStoryDragDrop: Bool
    @Binding var progress: CGFloat
    @Binding var questionBoxWidth: CGFloat
    @Binding var progress2: Int
    
    var body: some View{
        VStack(spacing: 20) {
            ForEach(0..<choicesIn.count, id: \.self) { i in
                if choicesIn[i].elementsEqual(correctAnswer) {
                    correctShortStoryButton(choice: choicesIn[i], totalQuestions: totalQuestionCount, questionNumber: $questionNumber, correctChosen: $correctChosen, showShortStoryDragDrop: $showShortStoryDragDrop, progress: $progress, questionBoxWidth: $questionBoxWidth, progress2: $progress2)
                        //.padding(.bottom, 5)
                } else {
                    incorrectShortStoryButton(choice: choicesIn[i], correctChosen: $correctChosen, questionBoxWidth: $questionBoxWidth, questionNumber: $questionNumber)
                        //.padding(.bottom, 5)
                }
            }
        }
        
        
    }
}

struct correctShortStoryButton: View {
    
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
          
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                
                
                if questionNumber != totalQuestions - 1 {
                    questionNumber = questionNumber + 1

                }else{
                    
                        showShortStoryDragDrop = true
                    
                    
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
                
                   
                
            }.padding([.leading, .trailing], 10).frame(width:questionBoxWidth - 30)
        })
        .frame(width:questionBoxWidth - 30, height: 38)

        .buttonStyle(ThreeDMultipleChoiceButtonCorrect(isPressed: changeCorrectColor))
        .onChange(of: questionNumber) {newValue in
            changeCorrectColor = false
            isEnabled = true
        }
        .enabled(isEnabled)
        

//        Button(action: {
//            changeCorrectColor = true
//            isEnabled = false
//            isPressing = true
//
//            SoundManager.instance.playSound(sound: .correct)
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                isPressing = false
//            }
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
//                
//                withAnimation(.easeIn(duration: 1.0)){
//                    if questionNumber != totalQuestions - 1 {
//                        progress2 = progress2 + 1
//                        
//                    }else{
//                        progress2 = totalQuestions
//                        
//                        
//                        
//                    }
//                }
//                
//            }
//          
//         
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                
//                
//                if questionNumber != totalQuestions - 1 {
//                    questionNumber = questionNumber + 1
//
//                }else{
//                    
//                        showShortStoryDragDrop = true
//                    
//                    
//                }
//                
//            }
//            
//            
//    
//         
//
//        }, label: {
//            
//            HStack{
//                Text(choice)
//                    .font(Font.custom("Futura", size: 15))
//                    .foregroundColor(.black)
//                    .padding(.top, 3)
//                    .offset(y: isPressing ? 5 : 0)
//                   
//                
//            }.padding([.leading, .trailing], 10).frame(width:questionBoxWidth - 40, height: 38)
//        })
//        .frame(width:questionBoxWidth - 40, height: 38)
//        .background(      ZStack{
//            let offset:CGFloat = 5
//           
//          
//          
//            
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(.black)
//                .offset(y:5)
//                //.offset(y: configuration.isPressed ? offset : 0)
//            
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(changeCorrectColor ? Color("ForestGreen") : .white)
//                .offset(y: isPressing ? offset : 0)
//         
//                
//             
//            
//        })
//
//        .padding([.leading, .trailing], 10)
//        .shadow(radius: 1)
//        .onChange(of: questionNumber) {newValue in
//            changeCorrectColor = false
//            isEnabled = true
//        }
//        .enabled(isEnabled)
        
        
    }
    
}

struct incorrectShortStoryButton: View {
    
    var choice: String
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var selected = false
    @State var wrongChosen = false
    @State var isEnabled = true
    @State var isPressing = false
    @Binding var correctChosen: Bool
    @Binding var questionBoxWidth: CGFloat
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
                
                   
                
                
            }.padding([.leading, .trailing], 10).frame(width:questionBoxWidth - 30)
        })
        .frame(width:questionBoxWidth-30, height: 38)

        .offset(x: selected ? -5 : 0)
        .buttonStyle(ThreeDMultipleChoiceButtonIncorrect(isPressed: wrongChosen))
        .padding([.leading, .trailing], 10)
        .onChange(of: questionNumber) { newValue in
           wrongChosen = false
            isEnabled = true
        }
        .enabled(isEnabled)

    }
    
}

struct ButtonPressHandler: ButtonStyle {
    var action: () -> ()
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ?
                  Color.blue.opacity(0.7) : Color.blue)   // just to look like system
            .onChange(of: configuration.isPressed) {
                if $0 {
                    action()
                }
            }
    }
}


struct textModifer : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Georgia", size: 18))
            .padding(.top, 40)
            .padding(.leading, 30)
            .padding(.trailing, 30)
            .lineSpacing(20)
        
    }
}


struct shortStoryView_Previews: PreviewProvider {
    static var  storyData: shortStoryData { shortStoryData(chosenStoryName: "Il Mio Fine Settimana")}
    
    static var storyObj: shortStoryObject {storyData.collectShortStoryData(storyName: storyData.chosenStoryName)}
    
    
    static var previews: some View {
        shortStoryView(chosenStoryNameIn: "Il Mio Fine Settimana", shortStoryDragDropVM: ShortStoryDragDropViewModel(chosenStoryName: "Il Mio Fine Settimana"), storyData: storyData, storyObj: storyObj).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(GlobalModel())
    }
}


