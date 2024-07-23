//
//  verbConjMultipleChoiceView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/1/23.
//

import SwiftUI
import CoreData

struct verbConjMultipleChoiceViewIPAD: View{
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var globalModel = GlobalModel()
    @ObservedObject var verbConjMultipleChoiceVM: VerbConjMultipleChoiceViewModel
    
    @State private var pressed = false
    @State private var progress: CGFloat = 0.0
    @State private var counter: Int = 0
    @State private var myListIsEmpty: Bool = false
    @State var isPreview: Bool
    @State var animatingBear = false
    @State var saved = false
    @State var correctChosen = false
    @State var wrongChosen = false
    @State var currentVerbIta = "temp"
    @State var showAlreadyExists: Bool = false
    @State var showFinishedActivityPage = false
    
    var body: some View {
        
        
        GeometryReader{geo in
      
                ZStack(alignment: .topLeading){
                    Image("verticalNature")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                     
                    HStack(spacing: 18){
                        Spacer()
                        NavigationLink(destination: chooseVerbList(), label: {
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
                            .onChange(of: counter){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count + 1))
                            }
                        
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                        Spacer()
                    }
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("WashedWhite"))
                        .frame(width: geo.size.width * 0.9, height: 350)
                        .padding([.leading, .trailing], geo.size.width * 0.05)
                        .shadow(radius: 15)
                        .offset(y: geo.size.height / 3)
                        .zIndex(0)
                    
                    Text(getTenseString(tenseIn: verbConjMultipleChoiceVM.currentTense))
                        .font(Font.custom("Chalkboard SE", size: 35))
                        .frame(width: geo.size.width * 0.2)
                        .underline()
                        .padding([.leading, .trailing], geo.size.width * 0.4)
                        .offset(y: 100)
                
                    HStack{
                        Button(action: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showAlreadyExists = false
                            }
                            if addVerbItem(verbToSave: counter){
                                showAlreadyExists = true
                            }else{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    saved = false
                                }
                                saved = true
                            }
                            
                        }, label: {
                            Image("save")
                                .resizable()
                                .scaledToFit()
                            .frame(width: 95, height: 95)
                            
                            
                        })
                    }.frame(maxHeight: geo.size.height, alignment: .bottomLeading).padding(15).padding(.bottom, 40)
                    
                    VStack{
 
                        
                        ScrollViewReader {scroller in
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(0..<verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count, id: \.self) { i in
                                        
                                        VStack{
                                            
                                            
                                            (Text(verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].verbNameIt) +
                                            Text(" - ") +
                                            Text(verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].pronoun) +
                                            Text("\n" + verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].verbNameEng))  .bold()
                                                .font(Font.custom("Arial Hebrew", size: 30))
                                                .frame(width:geo.size.width * 0.6, height: 100)
                                                .padding()
                                                .background(Color.teal)
                                                .cornerRadius(10)
                                                .foregroundColor(Color.white)
                                                .multilineTextAlignment(.center)
                                                .overlay( /// apply a rounded border
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(.black, lineWidth: 4)
                                                )
                                            
                                                .padding(.bottom, 20)
                                             
                                            
                                            
                                            
                                            choicesViewIPAD(choicesIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].choiceList, correctAnswerIn: verbConjMultipleChoiceVM.currentTenseMCConjVerbData[i].correctAnswer, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen).offset(x:3)
                                        }
                                        .frame(width: geo.size.width)
                                        .frame(minHeight: geo.size.height)
                                        
                                    }
                                    
                                }.offset(y: -100)
                            }
                            .scrollDisabled(true)
                            .frame(width: geo.size.width)
                            .frame(minHeight: geo.size.height)
                            .onChange(of: counter) { newIndex in
                                if newIndex == verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showFinishedActivityPage = true
                                    }
                                    progress = CGFloat(verbConjMultipleChoiceVM.currentTenseMCConjVerbData.count)
                                }else{
                                    currentVerbIta = verbConjMultipleChoiceVM.currentTenseMCConjVerbData[newIndex].verbNameIt
                                    withAnimation{
                                        scroller.scrollTo(newIndex, anchor: .center)
                                    }
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        
                       
          
                        
                        Text(currentVerbIta + " is already in MyList!")
                            .font(Font.custom("Arial Hebrew", size: 20))
                            .padding(.top, 3)
                            .padding([.top, .bottom], 5)
                            .padding([.leading, .trailing], 15)
                            .background(Color("WashedWhite"))
                            .foregroundColor(.black)
                            .cornerRadius(15)
                            .opacity(showAlreadyExists ? 1 : 0)
                            .offset(y:-330)
                        
                        
                        
                    }
                    .zIndex(1)
                    
                    
                    Image("sittingBear")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.55, height: geo.size.height * 0.18)
                        .offset(x: 390, y: animatingBear ? geo.size.height / 1.07 : 750)
                    
                    
                    if saved {
                        
                        Image("bubbleChatSaved")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .offset(x: 350, y: (geo.size.height / 1.25))
                        
                    }
                    
                    if correctChosen{
                        
                        let randomInt = Int.random(in: 1..<4)
                        
                        Image("bubbleChatRight"+String(randomInt))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .offset(x: 350, y: (geo.size.height / 1.25))
                    }
                    
                    if wrongChosen{
                        
                        let randomInt2 = Int.random(in: 1..<4)
                        
                        Image("bubbleChatWrong"+String(randomInt2))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .offset(x: 350, y: (geo.size.height / 1.25))
                    }
                    
                    
                    NavigationLink(destination: ActivityCompletePageIPAD(),isActive: $showFinishedActivityPage,label:{}
                    ).isDetailLink(false)
                    
                }
                .onAppear{
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


struct choicesViewIPAD: View{
    
    var choicesIn: [String]
    var correctAnswerIn: String
    @Binding var counter: Int
    @Binding var wrongChosen: Bool
    @Binding var correctChosen: Bool
    
    var body: some View{
        VStack(spacing: 25){
            HStack(spacing: 25){
                multipleChoiceButtonIPAD(choiceString: choicesIn[0], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
                multipleChoiceButtonIPAD(choiceString: choicesIn[1], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
            }
            HStack(spacing: 25){
                multipleChoiceButtonIPAD(choiceString: choicesIn[2], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
                multipleChoiceButtonIPAD(choiceString: choicesIn[3], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
            }
            HStack(spacing: 25){
                multipleChoiceButtonIPAD(choiceString: choicesIn[4], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
                multipleChoiceButtonIPAD(choiceString: choicesIn[5], correctAnswer: correctAnswerIn, counter: $counter, wrongChosen: $wrongChosen, correctChosen: $correctChosen)
            }
        }
        
    }
}


struct multipleChoiceButtonIPAD: View{
    
    var choiceString: String
    var correctAnswer: String
    @Binding var counter: Int
    @Binding var wrongChosen: Bool
    @Binding var correctChosen: Bool
    
    var body: some View{
        
        let isCorrect: Bool = choiceString.elementsEqual(correctAnswer)
        
        if isCorrect {
            correctMCButtonIPAD(choiceString: choiceString, counter: $counter, correctChosen: $correctChosen)
        } else {
            incorrectMCButtonIPAD(choiceString: choiceString, wrongChosen: $wrongChosen)
        }
        
    }
}



struct incorrectMCButtonIPAD: View {
    
    var choiceString: String
    
    @State var defColor = Color.teal
    @State private var pressed: Bool = false
    @State var selected = false
    @Binding var wrongChosen: Bool

    
    var body: some View {
        
        Button(action: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                wrongChosen = false
            }
            
            defColor = Color("wrongRed")
            wrongChosen = true
            
            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                selected.toggle()
            }
            SoundManager.instance.playSound(sound: .wrong)
            selected.toggle()
            
            
        }, label: {
            Text(choiceString)
                .font(Font.custom("Arial Hebrew", size: 25))
                .padding([.top, .bottom], 10)
                .padding(.top, 6)
                .padding([.leading, .trailing], 2)
            
        }).frame(width:300)
             .background(defColor)
             .foregroundColor(Color.white)
             .cornerRadius(20)
             .overlay( /// apply a rounded border
                 RoundedRectangle(cornerRadius: 20)
                     .stroke(.black, lineWidth: 4)
             )
         
             .shadow(radius: 5)
             .padding(.trailing, 5)
             .offset(x: selected ? -5 : 0)
  

    }
}

struct correctMCButtonIPAD: View {
    
    var choiceString: String
    
    @State var defColor = Color.teal
    @State private var pressed: Bool = false
    @State var selected = false
    @Binding var counter: Int
    @Binding var correctChosen: Bool
    
    var body: some View {
        
        Button(action: {
            
        }, label: {
            Text(choiceString)
                .font(Font.custom("Arial Hebrew", size: 25))
                .padding([.top, .bottom], 10)
                .padding(.top, 6)
                .padding([.leading, .trailing], 2)
            
            
        }).frame(width:300)
            .background(defColor)
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.black, lineWidth: 4)
            )
        
            .shadow(radius: 5)
            .padding(.trailing, 5)
            .scaleEffect(pressed ? 1.25 : 1.0)
            .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.75)) {
                    self.pressed = pressing
                }
                if pressing {
    
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        counter += 1
                        correctChosen = false
                    }
                    defColor = Color("correctGreen")
                    SoundManager.instance.playSound(sound: .correct)
                    correctChosen = true
                 
                  
                }
            }, perform: { })
    }
}

struct verbConjMultipleChoiceIPAD_Previews: PreviewProvider {
    static var _verbConjMultipleChoiceVM = VerbConjMultipleChoiceViewModel()
    static var previews: some View {
        verbConjMultipleChoiceViewIPAD(verbConjMultipleChoiceVM: _verbConjMultipleChoiceVM, isPreview: true).environmentObject(GlobalModel())
    }
}



