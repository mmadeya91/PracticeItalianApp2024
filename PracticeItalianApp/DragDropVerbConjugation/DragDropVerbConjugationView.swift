//
//  DragDropVerbConjugationView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/30/23.
//

import SwiftUI

struct DragDropVerbConjugationView: View {
    @StateObject var dragDropVerbConjugationVM: DragDropVerbConjugationViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isPreview: Bool
    @State var questionNumber = 0
    @State var wrongChosen = false
    @State var correctChosen = false
    @State var animatingBear = false
    @State var showFinishedActivityPage = false
    @State var showUserCheck = false
    @State var progress: CGFloat = 0.0
    
    var infoManager = InfoBubbleDataManager(activityName: "clickDropConjTable")
    
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
                    
                    HStack(spacing: 18){
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
                            .onChange(of: questionNumber){ newValue in
                                progress = (CGFloat(newValue) / CGFloat(dragDropVerbConjugationVM.currentTenseDragDropData.count-1))
                            }
                        
                        
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                        
                    }.padding([.leading, .trailing], 25).zIndex(1)
                    //                HStack{
                    //                    Button(action: {
                    //                        withAnimation(.linear){
                    //                            showUserCheck.toggle()
                    //                        }
                    //                    }, label: {
                    //                        Image(systemName: "xmark")
                    //                            .font(.system(size: 25))
                    //                            .foregroundColor(.gray)
                    //
                    //                    })
                    //
                    //
                    //                        GeometryReader{proxy in
                    //                            ZStack(alignment: .leading) {
                    //                                Capsule()
                    //                                    .fill(.gray.opacity(0.25))
                    //
                    //                                Capsule()
                    //                                    .fill(Color.green)
                    //                                    .frame(width: proxy.size.width * CGFloat(progress))
                    //                            }
                    //                        }.frame(height: 13)
                    //                            .onChange(of: questionNumber){ newValue in
                    //                                progress = (CGFloat(newValue) / 4)
                    //                            }
                    //
                    //                        Image("italyFlag")
                    //                            .resizable()
                    //                            .scaledToFit()
                    //                            .frame(width: 40, height: 40)
                    //                        Spacer()
                    //                }.padding([.leading, .trailing], 15).zIndex(1)
                    ScrollViewReader{scroller in
                        
                        ZStack{
                            VStack(spacing: 0){
                                HStack{
                                    Text(getTenseString(tenseIn: dragDropVerbConjugationVM.currentTense))
                                        .font(Font.custom("Georgia", size: 20))
                                        .padding(.bottom, 15)
                                        .padding(.leading, 20)
                                    Spacer()
                                    
                                    PopOverView(textIn: "Try to complete the conjugation table by clicking on the available conjugated verbs. They will populate the table in order and you can check your answer when the table is full. If you have made a mistake, click on the verb again that is now in the table and it will return that word back to the selection pool.", infoBubbleColor: Color.black, frameHeight: CGFloat(240), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch).padding(.trailing, 13)
                                }
                                
                                ScrollView(.horizontal){
                                    
                                    HStack{
                                        ForEach(0..<dragDropVerbConjugationVM.currentTenseDragDropData.count / 3, id: \.self) { i in
                                            VStack{
                                                dragDropViewBuilder(tense: dragDropVerbConjugationVM.currentTense, currentVerb: dragDropVerbConjugationVM.currentTenseDragDropData[i].currentVerb, characters: dragDropVerbConjugationVM.currentTenseDragDropData[i].choices , leftDropCharacters: dragDropVerbConjugationVM.currentTenseDragDropData[i].dropVerbListLeft, rightDropCharacters: dragDropVerbConjugationVM.currentTenseDragDropData[i].dropVerbListRight, questionNumber: $questionNumber, correctChosen: $correctChosen, wrongChosen: $wrongChosen, dragDropQuestionObjects: dragDropVerbConjugationVM.currentTenseDragDropData).frame(width: geo.size.width)
                                                    .frame(minHeight: geo.size.height)
                                            }.offset(y: -10)
                                                
                                            //.offset(y:-90)
                                            
                                        }
                                    }
                                    
                                }.padding(.top, 20)
                                .scrollDisabled(true)
                                .onChange(of: questionNumber) { newIndex in
                                    
                                    if newIndex == dragDropVerbConjugationVM.currentTenseDragDropData.count / 3 {
                                        showFinishedActivityPage = true
                                    }else{
                                        
                                        withAnimation{
                                            scroller.scrollTo(newIndex, anchor: .center)
                                        }
                                    }
                                    
                                    
                                }
                                
                                
                            }.zIndex(2)
                            
              
                        }
                        .offset(y: 50)
                       
                        
                        //                    Image("sittingBear")
                        //                        .resizable()
                        //                        .scaledToFill()
                        //                        .frame(width: 200, height: 100)
                        //                        .offset(x: 130, y: animatingBear ? 350 : 750)
                        //
                        //                    if correctChosen{
                        //
                        //                        let randomInt = Int.random(in: 1..<4)
                        //
                        //                        Image("bubbleChatRight"+String(randomInt))
                        //                            .resizable()
                        //                            .scaledToFill()
                        //                            .frame(width: 100, height: 40)
                        //                            .offset(y: 280)
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
                        //                            .offset(y: 280)
                        //                    }
                        
                        NavigationLink(destination:  activityCompleteVerbExercises(),isActive: $showFinishedActivityPage,label:{}
                        ).isDetailLink(false).id(UUID())
                        
                    }.onAppear{
                        withAnimation(.spring()){
                            animatingBear = true
                        }
                        if isPreview {
                            dragDropVerbConjugationVM.currentTense = 0
                            dragDropVerbConjugationVM.setNonMyListDragDropData()
                        }
                    }
                }
            }else{
                DragDropVerbConjugationViewIPAD(dragDropVerbConjugationVM: dragDropVerbConjugationVM, isPreview: false)
            }
        }
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



struct dragDropViewBuilder: View{
    
    var tense: Int
    var currentVerb: Verb
    
    @State var progress: CGFloat = 0
    //choices list
    @State var characters: [VerbConjCharacter]
    @State var leftDropCharacters: [VerbConjCharacter]
    @State var rightDropCharacters: [VerbConjCharacter]
    
    @State var draggingItem: VerbConjCharacter?
    
    //for drag
    @State var shuffledRows: [[VerbConjCharacter]] = []
    //for drop
    @State var rows: [[VerbConjCharacter]] = []
    
    @State var animateWrongText: Bool = false
    
    @State var droppedCount: CGFloat = 0
    @State var updating: Bool = false
    @State var showCorrect = false
    @State var showCheck = false
    @State var showContinue = false
    @Binding var questionNumber: Int
    @Binding var correctChosen: Bool
    @Binding var wrongChosen: Bool
    
    var dragDropQuestionObjects: [dragDropQuestionObject]
    
    @State var dropCounter = 1
    
    var body: some View {
        GeometryReader{geo in
            ZStack(alignment: .topLeading){
                VStack{
                    
                    VStack{
                        ZStack{
                            Text(currentVerb.verbName + "\n" + currentVerb.verbEngl)
                                .bold()
                                    .font(Font.custom("Georgia", size: geo.size.height * 0.023))
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
                        }
                    
                        
                        VStack{
                            HStack{
                                
                                LeftDropArea()
                               Spacer()
                                RightDropArea()
                             
                                
                            }
                        }
                        .padding(.top, 25)
                    }.padding(.bottom, 15)
                    //.padding(.top, 5)
 
                        DragArea().offset(y:10)
                            .zIndex(2).opacity(showCheck || showContinue ? 0 : 1)
                    
                    
                    Button(action: {
                        if showCheck{
                            if !checkAnswer(){
                                SoundManager.instance.playSound(sound: .correct)
                                showCheck = false
                                withAnimation(.easeIn(duration: 0)){
                                    showCorrect = true
                                    showContinue = true
                                }
                                
                                
                            }else{
                                SoundManager.instance.playSound(sound: .wrong)
                                animateView()
                            }
                        }else{
                            questionNumber = questionNumber + 1
                            progress = progress + 1
                            showContinue = false
                        }
                    }, label: {
                        Text(showCheck ? "Check" : "Continue")
                            .bold()
                            .font(Font.custom("Georgia", size: geo.size.height * 0.027))
                            .padding()
                            //.background(Color("ForestGreen"))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                           
                    }).opacity(showCheck || showContinue ? 1 : 0)
                        .buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 150, height: 40)
                        .zIndex(2).offset(y: -60)
                }
                .padding()
                .onAppear{
                    if rows.isEmpty{
                        //First Creating shuffled On
                        //then normal one
                        characters = characters.shuffled()
                        rows = generateGrid()
                        shuffledRows = generateGrid()
                        rows = generateGrid()
                    }
                }
                .offset(x: animateWrongText ? -30 : 0)
            }
        }
    }
    
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
            animateWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
                animateWrongText = false
            }
        }
    }
    
    @ViewBuilder
    func LeftDropArea()->some View{
        VStack(spacing:13){
            ForEach($leftDropCharacters){$item in
                Button(action: {
                    
                    let indexes = findShuffledRowIndexes(itemValue: item.value)

                    
                    shuffledRows[indexes.0][indexes.1].value = item.value
                    shuffledRows[indexes.0][indexes.1].isShowing = false
                    item.isWrong = false
                    item.isShowing = false
                    item.value = item.originalValue
                    
                    showCheck = false
                    
                }, label: {
                    Text(item.isShowing ? item.value : item.pronoun)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.vertical, 7)
                        .padding(.horizontal, item.padding)
                        .frame(width: ((UIScreen.main.bounds.width / 2) - 35), height: 35)
                        .background{
                            ZStack{
                                if item.isWrong {
                                    
                                    RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color("darkTerracotta"))
                                    
                                    
                                    RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color("terracotta"))
                                        .offset(y: -4)
                                    
                                }else{
                                    
                                    RoundedRectangle(cornerRadius: 8, style: .continuous).fill(item.isShowing ? Color("themeGray") : Color("darkThemeGray"))//.opacity(0.7)
                                    
                                    
                                    RoundedRectangle(cornerRadius: 8, style: .continuous).fill(item.isShowing ? .white : Color("dragDropGray"))
                                        .offset(y: -4)
                                    
                                    
                                    //.shadow(radius: 2)
                                    //
                                    //                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    //                                            .stroke(.black, lineWidth: 3).background(.white)
                                    //                                          //.shadow(radius: 2)
                                    
                                    
                                }
                            }
//                        } .opacity(item.isShowing ? 1 : 0)
//                        .background{
//                            RoundedRectangle(cornerRadius: 13, style: .continuous)
//                                .stroke(.black, lineWidth: 3).background(item.isWrong ? Color("terracotta") : item.isShowing ? .white : Color("LightGrey").opacity(0.7))
                        } .opacity(item.isShowing ? 1 : 1)
                        }).cornerRadius(8).enabled(item.isShowing)
                    .shadow(radius: 1.5)

            }
        }
        
    }
    
//    func getCorrectPerson(personIn: Int)->String{
//
//        switch personIn {
//        case 1:
//            return "Io"
//            dropCounter = dropCounter + 1
//        case 2:
//            return "Tu"
//            dropCounter = dropCounter + 1
//        case 3:
//            return "Lui/Lei/Lei"
//            dropCounter = dropCounter + 1
//        case 4:
//            dropCounter = dropCounter + 1
//            return "Noi"
//        case 5:
//            dropCounter = dropCounter + 1
//            return "Voi"
//        case 6:
//            dropCounter = dropCounter + 1
//            return "Loro"
//        default:
//            dropCounter = dropCounter + 1
//            return "Io"
//        }
//
//    }
    
    
    @ViewBuilder
    func RightDropArea()->some View{
        VStack(spacing:13){
            ForEach($rightDropCharacters){$item in
                Button(action: {
                    
                    let indexes = findShuffledRowIndexes(itemValue: item.value)

                    
                    shuffledRows[indexes.0][indexes.1].value = item.value
                    shuffledRows[indexes.0][indexes.1].isShowing = false
                    item.isWrong = false
                    item.isShowing = false
                    item.value = item.originalValue
                    
                    showCheck = false
                    
                }, label: {
                    Text(item.isShowing ? item.value : item.pronoun)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.vertical, 7)
                        .padding(.horizontal, item.padding)
                        .frame(width: ((UIScreen.main.bounds.width / 2) - 35), height: 35)
                        .background{
                            ZStack{
                                if item.isWrong {
                                    
                                    RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color("darkTerracotta"))
                                    
                                    
                                    RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color("terracotta"))
                                        .offset(y: -4)
                                    
                                }else{
                                    
                                    RoundedRectangle(cornerRadius: 8, style: .continuous).fill(item.isShowing ? Color("themeGray") : Color("darkThemeGray")).opacity(0.7)
                                    
                                    
                                    RoundedRectangle(cornerRadius: 8, style: .continuous).fill(item.isShowing ? .white : Color("dragDropGray"))
                                        .offset(y: -4)
                                    
                                    
                                    //.shadow(radius: 2)
                                    //
                                    //                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    //                                            .stroke(.black, lineWidth: 3).background(.white)
                                    //                                          //.shadow(radius: 2)
                                    
                                    
                                }
                            }
//                        } .opacity(item.isShowing ? 1 : 0)
//                        .background{
//                            RoundedRectangle(cornerRadius: 13, style: .continuous)
//                                .stroke(.black, lineWidth: 3).background(item.isWrong ? Color("terracotta") : item.isShowing ? .white : Color("LightGrey").opacity(0.7))
                        } .opacity(item.isShowing ? 1 : 1)
                        }).cornerRadius(8).enabled(item.isShowing)
                    .shadow(radius: 1.5)

            }
        }
        
    }
    
    
    @ViewBuilder
    func DragArea()->some View {
        VStack(spacing: 20){
            ForEach(shuffledRows, id: \.self){row in
                HStack(spacing: 20){
                    ForEach(row){item in
                        Button(action: {
                        
                            let index = findFirstBlankObject()
                            let shuffledRowIndexes = findShuffledRowIndexes(itemValue: item.value)
                            

                            
                          
                                
                                if index < 3 {
                                    leftDropCharacters[index].value = item.value
                                    leftDropCharacters[index].isShowing = true
                                }else{
                                    rightDropCharacters[index-3].value = item.value
                                    rightDropCharacters[index-3].isShowing = true
                                }
                                
                                
                              
                            
                        
                            
                            
                            shuffledRows[shuffledRowIndexes.0][shuffledRowIndexes.1].isShowing = true
                            
                            
                            if isAnswerFull(){
                                showCheck = true
                            }
                            
                            
                        }, label: {
                            Text(item.value)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .padding(.vertical, 7)
                                .padding(.horizontal, item.padding)
                                .background{
                                    ZStack{
                                        
                                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color("themeGray"))
                                            
                                        
                                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill(.white)
                                            .offset(y: -4)
             
                                          //.shadow(radius: 2)
//
//                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
//                                            .stroke(.black, lineWidth: 3).background(.white)
//                                          //.shadow(radius: 2)
                                        
                                    
                                    }
                                }
                                .opacity(item.isShowing ? 0 : 1)//.shadow(radius: 1.5)
                        }).cornerRadius(8).enabled(!item.isShowing)
                            .shadow(radius: 1.5)
                    }
                }
                
            }
        }
    }
    
    
    func checkAnswer()->Bool{
       
        var answerIsWrong = false
        
        for i in 0...2 {
            if leftDropCharacters[i].value != dragDropQuestionObjects[questionNumber].answerArray[i] {
                leftDropCharacters[i].isWrong = true
                answerIsWrong = true
            }
           
          
        }
        
        for x in 0...2 {
            if rightDropCharacters[x].value != dragDropQuestionObjects[questionNumber].answerArray[x + 3] {
                
                rightDropCharacters[x].isWrong = true
                answerIsWrong = true
                
            }
        }
        
 
        
       return answerIsWrong
    }
    

    
    func isAnswerFull()->Bool{
        var isFull = true
        for i in 0...2 {
                if rightDropCharacters[i].isShowing == false {
                    isFull = false
                    
                    
                }
            }
            
        
        return isFull
    }
    
    func findFirstBlankObject()->Int{
      
        
        for i in 0...6 {
            if i < 3 {
                if leftDropCharacters[i].isShowing == false {
                    return i
                    
                    
                }
            }else{
                if rightDropCharacters[i-3].isShowing == false {
                    return i
                    
                    
                }
            }
            
        }
        
   
          
        
        return 0
    }
    
    func findRowIndexes(itemValue: String)->(Int, Int){
        var indexes = (rowIndex: 0, itemIndex: 0)
        for i in 0...rows.count-1 {
            for x in 0...rows[i].count-1 {
                    if rows[i][x].value == itemValue {
                        indexes.0 = i
                        indexes.1 = x
                        
                        return indexes
                      
                        
                }
               
            }
          
        }
        return indexes
    }
    
    func findShuffledRowIndexes(itemValue: String)->(Int, Int){
        var indexes = (rowIndex: 0, itemIndex: 0)
        for i in 0...shuffledRows.count-1 {
            for x in 0...shuffledRows[i].count-1 {
                    if shuffledRows[i][x].value == itemValue {
                        indexes.0 = i
                        indexes.1 = x
                        
                        return indexes
                        
                }
              
            }
          
        }
        
        return indexes
     
    }
    
    
    func generateGrid()->[[VerbConjCharacter]]{
        
        for item in characters.enumerated() {
            let textSize = textSize(character: item.element)
            
            characters[item.offset].textSize = textSize
            
        }
        
        var gridArray: [[VerbConjCharacter]] = []
        var tempArray: [VerbConjCharacter] = []
        
        var currentWidth: CGFloat = 0
        
        let totalScreenWidth: CGFloat = UIScreen.main.bounds.width - 15
        
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
    
    
    func textSize(character: VerbConjCharacter)->CGFloat{
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        return size.width + (character.padding * 2) + 15
    }
    
    func updateShuffledArray(character: VerbConjCharacter){
        for index in shuffledRows.indices{
            for subIndex in shuffledRows[index].indices{
                if shuffledRows[index][subIndex].id == character.id{
                    shuffledRows[index][subIndex].isShowing = true
                }
            }
        }
    }
    
}


struct DragDropVerbConjugationView_Previews: PreviewProvider {
    static var dragDropVM: DragDropVerbConjugationViewModel = DragDropVerbConjugationViewModel()
    
    static var previews: some View {
        DragDropVerbConjugationView(dragDropVerbConjugationVM:  dragDropVM, isPreview: true)
    }
}
