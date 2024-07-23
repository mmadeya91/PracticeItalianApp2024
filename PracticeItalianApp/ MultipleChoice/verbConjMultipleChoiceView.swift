//
//  verbConjMultipleChoiceView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import SwiftUI
import CoreData

struct verbConjMultipleChoiceView: View{
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var globalModel = GlobalModel()
    @ObservedObject var verbConjMultipleChoiceVM: VerbConjMultipleChoiceViewModel
    
    @State private var pressed = false
    @State private var progress: CGFloat = 0.0
    @State private var questionNumber: Int = 0
    @State private var myListIsEmpty: Bool = false
    @State var isPreview: Bool
    @State var animatingBear = false
    @State var saved = false
    @State var correctChosen = false
    @State var wrongChosen = false
    @State var currentVerbIta = "temp"
    @State var showAlreadyExists: Bool = false
    @State var showFinishedActivityPage = false
    @State var totalQuestions = 0
    @State var questionBoxWidth = UIScreen.main.bounds.width
    @State var progress2 = 0
    
    @Environment(\.dismiss) var dismiss
  
    var infoManager = InfoBubbleDataManager(activityName: "multipleChoice")
    
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
                    
                    VStack{
                        Spacer()
                        HStack{
                            Button(action: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    showAlreadyExists = false
                                }
                                if addVerbItem(verbToSave: questionNumber){
                                    showAlreadyExists = true
                                }else{
                                    saved = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        saved = false
                                    }
                                    
                                }
                                
                            }, label: {
                                Image(systemName: "square.and.arrow.down")
                                    .foregroundColor(.black)
                                    .font(.system(size: 45))
                                    .frame(width: 40, height: 40)
                                
                                
                            })
                        }
                    }.frame(maxHeight: geo.size.height, alignment: .bottomLeading).padding(15)
                        .offset(x: 40, y: -20)
                       .zIndex(1)
                    
//                    Image("sittingBear")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 200, height: 100)
//                        .offset(x: 195, y: animatingBear ? geo.size.height - 35: 750)
//                    
                    
                    HStack(spacing: 18){
                        Spacer()
                        
                        Button(action: {dismiss()}, label: {
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
                            .onChange(of: progress2){ newValue in
                                progress = (CGFloat(newValue + 1) /
                                            CGFloat(verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count + 1))
                            }
                        
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                        Spacer()
                    }.zIndex(2)
                    
                    
                    if saved {
                        Text("Saved")
                            .font(Font.custom("Georgia", size: 20))
                            .frame(width: 100, height: 40)
                            .offset(x: 150, y: geo.size.height - 85)
//                        Image("bubbleChatSaved")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 40)
//                            .offset(x: 150, y: geo.size.height - 85)
                        
                    }
                    
//                    if correctChosen{
//                        
//                        let randomInt = Int.random(in: 1..<4)
//                        
//                        Image("bubbleChatRight"+String(randomInt))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 40)
//                            .offset(x: 150, y: geo.size.height - 85)
//                    }
//                    
//                    if wrongChosen{
//                        
//                        let randomInt2 = Int.random(in: 1..<4)
//                        
//                        Image("bubbleChatWrong"+String(randomInt2))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 40)
//                            .offset(x: 150, y: geo.size.height - 85)
//                    }
                    
 
                    VStack{
                        ZStack{
                            HStack{
                                Text(getTenseString(tenseIn: verbConjMultipleChoiceVM.currentTense))
                                    .font(Font.custom("Georgia", size: 20))
                                    .padding(.top, 70)
                                Spacer()
                          
                            }.padding(.leading, 20)
                        }
                        
                        ScrollViewReader {scroller in
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(0..<verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count, id: \.self) { i in
                                        
                                        
                                        
                                        
                                        
                                        
                                        VStack(spacing: 0){
                                            ZStack{
                                                (Text(verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].verbNameIt) +
                                                 Text(" - ") +
                                                 Text(verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].pronoun) +
                                                 Text("\n" + verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].verbNameEng))
                                                .bold()
                                                .font(Font.custom("Georgia", size: geo.size.height * 0.02))
                                                .padding()
                                                .frame(width:290, height: 90)
                                                .background(Color("espressoBrown"))
                                                .cornerRadius(10)
                                                .foregroundColor(.white)
                                                .multilineTextAlignment(.center)
                                                .zIndex(1)
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .frame(width:290, height:90)
                                                    .foregroundColor(Color("darkEspressoBrown"))
                                                    .zIndex(0)
                                                    .offset(y:7)
                                                    .shadow(radius: 3)
                                                
                                                
                                                
                                            }.padding(.top, 50)
                                          
                                            
                                            choicesView(choicesIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].choiceList, correctAnswerIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].correctAnswer, totalQuestions: verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count, i: i, verbConjMultipleChoiceVM: verbConjMultipleChoiceVM, questionNumber: $questionNumber, wrongChosen: $wrongChosen, correctChosen: $correctChosen, showActivityComplete: $showFinishedActivityPage, questionBoxWidth: $questionBoxWidth, progress2: $progress2).frame(width: geo.size.width).offset(y: -15)
                                            
                                                
                                        }
                    
                                        
                                    }
                                    
                                }
                            }.padding(.bottom, geo.size.height * 0.2)
                            .scrollDisabled(true)
                            //.frame(width: geo.size.width)
                            //.frame(minHeight: geo.size.height)
                            .onChange(of: questionNumber) { newIndex in
                               
                                    withAnimation{
                                        scroller.scrollTo(newIndex, anchor: .center)
                                    }
                                
                                
                                
                            }
                            
                            
                            
                        }
                        
                       
          
                        
                        Text(currentVerbIta + " is already in MyList!")
                            .font(Font.custom("Georgia", size: 20))
                            .padding(.top, 3)
                            .padding([.top, .bottom], 5)
                            .padding([.leading, .trailing], 15)
                            .background(Color("WashedWhite"))
                            .foregroundColor(.black)
                            .cornerRadius(15)
                            .opacity(showAlreadyExists ? 1 : 0)
                            .offset(y:-330)
                        
                        
                        
                    }
                    
                    NavigationLink(destination:  activityCompleteVerbExercises(),isActive: $showFinishedActivityPage,label:{}
                    ).isDetailLink(false).id(UUID())

                    
                }
                .onAppear{
                    questionBoxWidth = geo.size.width * 0.95 / 2
                    withAnimation(.easeIn){
                        animatingBear = true
                    }
                    if isPreview{
                        verbConjMultipleChoiceVM.setMultipleChoiceData()
                        currentVerbIta = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[0].verbNameIt
                    }else{
                        currentVerbIta = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[0].verbNameIt
                    }
                }
                .navigationBarBackButtonHidden(true)
            }else{

                verbConjMultipleChoiceViewIPAD(verbConjMultipleChoiceVM: verbConjMultipleChoiceVM, isPreview: false)
            }
        }
    }
    
    func addVerbItem(verbToSave: Int)->Bool {
        
        if itemExists(verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].verbNameIt) {
            return true
        }else{
            
            let newUserMadeVerb = UserVerbList(context: viewContext)
            newUserMadeVerb.verbNameItalian = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].verbNameIt
            newUserMadeVerb.verbNameEnglish = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].verbNameEng
            newUserMadeVerb.presente = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].pres
            newUserMadeVerb.passatoProssimo = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].pass
            newUserMadeVerb.futuro = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].fut
            newUserMadeVerb.imperfetto = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].imp
            newUserMadeVerb.imperativo = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].impera
            newUserMadeVerb.condizionale = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[verbToSave].cond
            
            
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }
            
            return false
        }
        
        
    }
    
    private func itemExists(_ item: String) -> Bool {
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserVerbList")
          fetchRequest.predicate = NSPredicate(format: "verbNameItalian == %@", item)
          return ((try? viewContext.count(for: fetchRequest)) ?? 0) > 0
      }
    
    func getTenseString(tenseIn: Int)->String{
        switch tenseIn {
        case 0:
            return "Presente"
        case 1:
            return "Passato Prossimo"
        case 2:
            return "Futuro"
        case 3:
            return "Imperfetto"
        case 4:
            return "Presente Condizionale"
        case 5:
            return "Imperativo"
        default:
            return "No Tense"
        }
    }
    
}



struct choicesView: View{
    
    var choicesIn: [String]
    var correctAnswerIn: String
    var totalQuestions: Int
    var i: Int
    var verbConjMultipleChoiceVM: VerbConjMultipleChoiceViewModel
    @Binding var questionNumber: Int
    @Binding var wrongChosen: Bool
    @Binding var correctChosen: Bool
    @Binding var showActivityComplete: Bool
    @Binding var questionBoxWidth: CGFloat
    @Binding var progress2: Int
    
    @State var characters: [plugInCharacter] = []
    @State var shuffledRows: [[plugInCharacter]] = []
    
//    var plugInQuestion: FillInBlankQuestion
//    var plugInChoices: [pluginShortStoryCharacter]
    
    struct plugInCharacter: Identifiable, Hashable, Equatable {
        var id = UUID().uuidString
        var value: String
        var padding: CGFloat = 12
        var textSize: CGFloat = .zero
        var fontSize: CGFloat = 19
        var isCorrect: Bool
    }
    
    func setCharacterData(){
        var tempArray: [plugInCharacter] = []
        for i in 0...choicesIn.count - 1 {
            tempArray.append(plugInCharacter(value: choicesIn[i], isCorrect: choicesIn[i] == correctAnswerIn ? true : false))
            
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
    
   

    
    var body: some View{
        GeometryReader{geo in
            VStack{
 
                
                
              
                    
                    VStack(spacing: 25) {
                        ForEach(shuffledRows, id: \.self){row in
                            HStack(spacing:20){
                                ForEach(row){item in
                                    if item.isCorrect{
                                        correctMCButton(choice: item.value, totalQuestions: totalQuestions, padding: item.padding, questionNumber: $questionNumber, correctChosen: $correctChosen, showActivityComplete: $showActivityComplete, questionBoxWidth: $questionBoxWidth, progress2: $progress2)
                                    }else{
                                        incorrectMCButton(choice: item.value, padding: item.padding, correctChosen: $correctChosen, questionBoxWidth: $questionBoxWidth, questionNumber: $questionNumber)
                                    }
                    
                                }
                            }
                            
                        }
                        
                    }.padding(.top, 40)
                
               
            }.frame(width: geo.size.width)
                .frame(minHeight: geo.size.height)
            .onAppear{
                setCharacterData()
                shuffledRows = generateGrid()
            }
        }
        
    }
}


struct incorrectMCButton: View {
    
    var choice: String
    var padding: CGFloat
    
    @State var isEnabled = true
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State var selected = false
    @State var wrongChosen = false
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
                    .font(.system(size: 19))
                    .padding(.bottom, 3)
                    .padding([.leading, .trailing], 3)
                    .foregroundColor(.black)
                    .padding(.vertical, 7)
                    .padding(.horizontal, padding)
                    .background{
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(wrongChosen ? Color("darkTerracotta") : Color("themeGray"))
                                
                            
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(wrongChosen ? Color("terracotta") : .white)
                                .offset(y: -4)

                        }
                    }
                
                   
                
                
            }.shadow(radius: 1)
        })


        .offset(x: selected ? -5 : 0)
        .onChange(of: questionNumber) { newValue in
           wrongChosen = false
            isEnabled = true
        }
        .enabled(isEnabled)

    }
}

struct correctMCButton: View {
    var choice: String
    var totalQuestions: Int
    var padding: CGFloat
    
    @State var colorOpacity = 0.0
    @State var chosenOpacity = 0.0
    @State private var pressed: Bool = false
    @State var changeCorrectColor = false
    @State var isEnabled = true
    @State var isPressing = false
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var showActivityComplete: Bool
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
          
         
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                
                if questionNumber != totalQuestions - 1 {
                    questionNumber = questionNumber + 1

                }else{
                    
                        showActivityComplete = true
                    
                    
                }
                
            }
            
            
    
         

        }, label: {
            
            HStack{
                Text(choice)
                .font(.system(size: 19))
                .padding([.leading, .trailing], 3)
                .padding(.bottom, 3)
                .foregroundColor(.black)
                .padding(.vertical, 7)
                .padding(.horizontal, padding)
                .background{
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(changeCorrectColor ? Color("darkForestGreen") : Color("themeGray"))
                            
                        
                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(changeCorrectColor ? Color("ForestGreen") : .white)
                            .offset(y: -4)

                    }
                }
                
                   
                
            }.shadow(radius: 1)
        })
        .onChange(of: questionNumber) {newValue in
            changeCorrectColor = false
            isEnabled = true
        }
        .enabled(isEnabled)
        
    }
}




struct verbConjMultipleChoice_Previews: PreviewProvider {
    static var _verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
    static var previews: some View {
        verbConjMultipleChoiceView(verbConjMultipleChoiceVM: _verbConjMultipleChoiceVM, isPreview: true).environmentObject(GlobalModel())
    }
}


