//
//  SpellConjugatedVerbView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/27/23.
//

import SwiftUI
import CoreData

struct SpellConjugatedVerbView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var spellConjVerbVM: SpellConjVerbViewModel
    
    @State var progress: CGFloat = 0

    @State var userAnswer: String = ""
    @State var currentQuestionNumber = 0
    @State var pressed = false
    @State var selected = false
    @State var hintGiven: Bool = false
    @State var hintButtonText = "Hint"
    @State var animatingBear = false
    @State var isPreview:Bool
    @State var correctChosen = false
    @State var wrongChosen = false
    @State var saved = false
    @State var showAlreadyExists = false
    @State var currentVerbIta = "temp"
    @State var showFinishedActivityPage = false
    
    @Environment(\.dismiss) var dismiss
    
    var infoManager = InfoBubbleDataManager(activityName: "spellItOut")
    
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
                    
                    HStack{
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showAlreadyExists = false
                            }
                            if addVerbItem(verbToSave: currentQuestionNumber){
                                showAlreadyExists = true
                            }else{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    saved = false
                                }
                                saved = true
                            }
                        }, label: {    Image(systemName: "square.and.arrow.down")
                                .foregroundColor(.black)
                                .font(.system(size: 45))
                                .frame(width: 40, height: 40)})
                        
                        if saved {
                            Text("Saved!")
                                .font(Font.custom("Georgia", size: 15))
                        }
                    }.frame(maxHeight: .infinity, alignment: .bottomLeading).padding(15).padding(.leading, 50)
                    
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
                            .onChange(of: currentQuestionNumber){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(spellConjVerbVM.currentTenseSpellConjVerbData.count + 1))
                            }
                        
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                        Spacer()
                    }.zIndex(2)
                    
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color("WashedWhite"))
//                        .frame(width: geo.size.width * 0.9, height: 160)
//                        .offset(y: geo.size.height / 4)
//                        .padding([.leading, .trailing], geo.size.width * 0.05)
//                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                        .zIndex(0)

                    
                    VStack{
                        HStack{
                            Text(getTenseString(tenseIn: spellConjVerbVM.currentTense))
                                .font(Font.custom("Georgia", size: 20))
                                .padding(.top, 70)
                            Spacer()
                            
                            PopOverView(textIn: "Try to spell out the given verb. Spelling is important, including accents! If you get stuck, you can use the hint button to help.", infoBubbleColor: Color.black, frameHeight: CGFloat(180), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch).padding(.trailing, 13).padding(.top, 70)
                        }.padding(.leading, 20)
                        
                        
                        ScrollViewReader{scroller in
                            ScrollView(.horizontal) {
                                HStack{
                                    ForEach(0..<spellConjVerbVM.currentTenseSpellConjVerbData.count, id: \.self) {i in
                                        
                                        VStack(spacing: 0){
                                            
                                            questionView(vbItalian: spellConjVerbVM.currentTenseSpellConjVerbData[i].verbNameItalian, vbEnglish: spellConjVerbVM.currentTenseSpellConjVerbData[i].verbNameEnglish, pronoun: spellConjVerbVM.currentTenseSpellConjVerbData[i].pronoun, hintLetters: spellConjVerbVM.currentHintLetterArray).frame(width: geo.size.width)
                                            
                                              
                                            

                                            
                                        }
                                            
                                           
                                    }
                                    
                                }
                                
          
                            }.padding(.top, 50)
                            .scrollDisabled(true)
                            .onChange(of: currentQuestionNumber) { newIndex in
                                
                                if newIndex > spellConjVerbVM.currentTenseSpellConjVerbData.count - 1 {
                                    showFinishedActivityPage = true
                                }else{
                                    currentVerbIta = spellConjVerbVM.currentTenseSpellConjVerbData[newIndex].verbNameItalian
                                    withAnimation{
                                        scroller.scrollTo(newIndex, anchor: .center)
                                    }
                                }
                            }
                        }
                        
                        VStack{
                            textFieldView(userAnswer: $userAnswer, correctChosen: $correctChosen, wrongChosen: $wrongChosen, currentQuestionNumber: $currentQuestionNumber, hintGiven: $hintGiven, hintButtonText: $hintButtonText, progress: $progress, spellConjVerbVM: spellConjVerbVM)
                            
                            hintButton(hintGiven: $hintGiven, hintButtonText: $hintButtonText, spellConjVerbVM: spellConjVerbVM)
                        }.padding(.top, 80)
                        
                    
                       
                        Text(currentVerbIta + " is already in MyList!")
                            .font(Font.custom("Georgia", size: 16))
                            .padding(.top, 3)
                            .padding([.top, .bottom], 5)
                            .padding([.leading, .trailing], 15)
                            .background(Color("WashedWhite"))
                            .foregroundColor(.black)
                            .opacity(showAlreadyExists ? 1 : 0)
                            .padding(.top, 7)
                            
                        
                    }
                    
                 
                    
//                    Image("sittingBear")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: geo.size.width * 0.6, height: geo.size.height * 0.2)
//                        .offset(x: 190, y: animatingBear ? geo.size.height / 1.07 : 750)
//                    
               
                    
//                    if saved {
//                        
//                        Image("bubbleChatSaved")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 40)
//                            .offset(x: 150, y: (geo.size.height / 1.14))
//                        
//                    }
                     
                
                    
//                    if correctChosen{
//                        
//                        let randomInt = Int.random(in: 1..<4)
//                        
//                        Image("bubbleChatRight"+String(randomInt))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 100, height: 40)
//                            .offset(x: 150, y: (geo.size.height / 1.14))
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
//                            .offset(x: 150, y: (geo.size.height / 1.14))
//                    }
                    
                    NavigationLink(destination:  activityCompleteVerbExercises(),isActive: $showFinishedActivityPage,label:{}
                    ).isDetailLink(false).id(UUID())
                    
                }.navigationBarBackButtonHidden(true).ignoresSafeArea(.keyboard)
                .onAppear{
                    withAnimation(.spring()){
                        animatingBear = true
                    }
                    if isPreview {
                        spellConjVerbVM.currentTense = 0
                        spellConjVerbVM.setSpellVerbData()
                        spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[0].hintLetterArray)
                        currentVerbIta = spellConjVerbVM.currentTenseSpellConjVerbData[0].verbNameItalian
                    }else{
                        currentVerbIta = spellConjVerbVM.currentTenseSpellConjVerbData[0].verbNameItalian
                    }
                }
            }else{
                SpellConjugatedVerbViewIPAD(spellConjVerbVM: spellConjVerbVM, isPreview: false)
            }
        }
        
        
        
    }
    
    func addVerbItem(verbToSave: Int)-> Bool {
        
        if itemExistsSpellVerb(spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].verbNameItalian) {
            return true
        }else{
            
            let newUserMadeVerb = UserVerbList(context: viewContext)
            newUserMadeVerb.verbNameItalian = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].verbNameItalian
            newUserMadeVerb.verbNameEnglish = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].verbNameEnglish
            newUserMadeVerb.presente = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].pres
            newUserMadeVerb.passatoProssimo = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].pass
            newUserMadeVerb.futuro = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].fut
            newUserMadeVerb.imperfetto = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].imp
            newUserMadeVerb.imperativo = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].impera
            newUserMadeVerb.condizionale = spellConjVerbVM.currentTenseSpellConjVerbData[verbToSave].cond
            
            do {
                try viewContext.save()
            } catch {
                print("error saving")
            }
            return false
            
        }
        
    }
    
    private func itemExistsSpellVerb(_ item: String) -> Bool {
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

struct textFieldView: View{
    @Binding var userAnswer: String
    @Binding var correctChosen: Bool
    @Binding var wrongChosen: Bool
    @Binding var currentQuestionNumber: Int
    @Binding var hintGiven: Bool
    @Binding var hintButtonText: String
    @Binding var progress: CGFloat
    
    var spellConjVerbVM: SpellConjVerbViewModel
    
    var body: some View{
        VStack{
            TextField("", text: $userAnswer)
                .background(Color.white.cornerRadius(10))
                .font(Font.custom("Georgia", size: 30))
            //.shadow(color: Color.black, radius: 3, x: 0, y:4)
                .frame(width: 320)
                .overlay(
                    RoundedRectangle(cornerRadius:0)
                        .stroke(.black, lineWidth: 2)
                )
                .onSubmit{
                    if userAnswer != "" {
                        
                        if correctChosen || wrongChosen {
                            correctChosen = false
                            wrongChosen = false
                        }
                        
                        if  userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().elementsEqual(spellConjVerbVM.currentTenseSpellConjVerbData[currentQuestionNumber].correctAnswer.lowercased()) {
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                currentQuestionNumber += 1
                                correctChosen = false
                                
                                progress = (CGFloat(currentQuestionNumber) / CGFloat(spellConjVerbVM.currentTenseSpellConjVerbData.count))
                                
                                spellConjVerbVM.setHintLetter(letterArray: spellConjVerbVM.currentTenseSpellConjVerbData[currentQuestionNumber].hintLetterArray)
                                
                                hintGiven = false
                                hintButtonText = "Hint!"
                                userAnswer = ""
                            }
                            spellConjVerbVM.showHint()
                            correctChosen = true
                            SoundManager.instance.playSound(sound: .correct)
                            
                        }else {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                wrongChosen = false
                            }
                            SoundManager.instance.playSound(sound: .wrong)
                            wrongChosen = true
                        }
                    }
                }
        }
    }
}

struct hintButton: View {
    @Binding var hintGiven: Bool
    @Binding var hintButtonText: String
    
    var spellConjVerbVM: SpellConjVerbViewModel
    
    var body: some View{
        HStack{
            Button(action: {
                
                let currentHLACount = spellConjVerbVM.currentHintLetterArray.count
                
                if !hintGiven {
                    var array = [Int](0...currentHLACount-1)
                    array.shuffle()
                    if currentHLACount == 1 {
                        spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                    }
                    if currentHLACount == 2 {
                        spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                        spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                    }
                    
                    if currentHLACount > 2 {
                        spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                        spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                        spellConjVerbVM.currentHintLetterArray[array.popLast()!].showLetter.toggle()
                    }
                    
                    hintButtonText = "Show Me!"
                    hintGiven = true
                }else{
                    
                    spellConjVerbVM.showHint()
                }
                
            }, label: {
                
                Text(hintButtonText)
                    .font(Font.custom("Georgia", size: 15))
                    .foregroundColor(.black)
                    .frame(width:100, height: 40)
                    //.padding(.top, 40)
                   // .shadow(radius: 5)
                
                
            }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width:100, height: 40).padding(.top, 40).foregroundColor(.white)
        
        }
        
    }
}



struct questionView: View {
    var vbItalian: String
    var vbEnglish: String
    var pronoun: String
    var hintLetters: [hintLetterObj]
    var body: some View {
        
        VStack{
            ZStack{
                (Text(vbItalian) +
                 Text(" - ") +
                 Text(pronoun) +
                 Text("\n(" + vbEnglish + ")")).bold()
                    .bold()
                    .font(Font.custom("Georgia", size: 19))
                    .padding()
                    .frame(width:300, height: 100)
                    .background(Color("espressoBrown"))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .zIndex(1)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width:300, height:100)
                    .foregroundColor(Color("darkEspressoBrown"))
                    .zIndex(0)
                    .offset(y:7)
                    .shadow(radius: 3)
                
                
            }
            
            HStack(spacing: 10){
                
                ForEach(hintLetters, id: \.self) { answerArray in
                    Text(answerArray.letter)
                        .font(Font.custom("Georgia", size: 15))
                        .foregroundColor(.black.opacity(answerArray.showLetter ? 1.0 : 0.0))
                        .overlay(
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: 12, height: 1)
                            , alignment: .bottom
                        )
                    //.offset(y: 20)
                        .zIndex(2)
                    
                }
            }.padding(.top, 30).frame(width: UIScreen.main.bounds.width - 30)
        }
    }
    
}




struct SpellConjugatedVerbView_Previews: PreviewProvider {
    static var _spellConjVerbVM = SpellConjVerbViewModel()
    static var previews: some View {
        SpellConjugatedVerbView(spellConjVerbVM: _spellConjVerbVM, isPreview: true)
    }
}
