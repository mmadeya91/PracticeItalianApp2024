//
//  ShortStoryClickDrop.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 4/15/24.
//

//
//  ShortStoryDragDropView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/29/23.
//

import SwiftUI



struct ShortStoryClickDrop: View{
    @StateObject var shortStoryDragDropVM: ShortStoryDragDropViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) var dismiss
    var isPreview: Bool
    @State var questionNumber = 0
    @State var shortStoryName: String
    @State var showPlayer = false
    @State var showUserCheck = false
    @State var progress: CGFloat = 0.0
    @State var showInfoPopUp = false
    @State var italianSentence: [String] = []
    @State var showingSheet = false
    @State var showEnglish = false
    @State var progress2 = 0
    
    @State var test = false
    
    var infoManager = InfoBubbleDataManager(activityName: "clickDropShortStory")
    
    var body: some View{
            GeometryReader {geo in
                if horizontalSizeClass == .compact {
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
                    
                    HStack{
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)){
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
                            .onChange(of: progress2){ newValue in
                                progress = (CGFloat(newValue + 1) / CGFloat(shortStoryDragDropVM.currentDragDropQuestions.count + 1))
                            }
     
                    
                        Image("italy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                        Spacer()
                    }.padding([.leading, .trailing], 15).zIndex(1)
                    
                    
                    
             
                    
                    ScrollViewReader{scroller in
                        
                        ZStack{
                          
                                userCheckNavigationPopUpClickDrop(showUserCheck: $showUserCheck)
                                    .opacity(showUserCheck ? 1.0 : 0.0)
                                    .zIndex(2)
                           
                            VStack{
                                HStack(spacing: 0){
                                    Text("Form this sentence")
                                        .font(Font.custom("Georgia", size: geo.size.height * 0.027))
                                        .padding(.bottom, 10)
                                        .padding(.top, 65)
                                    
                                    if test{
                                        PopOverView(textIn: "Try to translate the english sentence into Italian by clicking on the available words in the bottom. You can remove the words from your in progress answer by clicking on them again which will return them to the bottom area.", infoBubbleColor: Color.black, frameHeight: CGFloat(240), isInfoPopTipShown: infoManager.getActivityFirstLaunchData().isFirstLaunch).offset(y: 28)
                                    }
                                }
   
                                
                                ScrollView(.horizontal){
                                    
                                    HStack{
                                        ForEach(0..<shortStoryDragDropVM.currentDragDropQuestions.count, id: \.self) { i in
                                            VStack{
                                                
                                         
                                                
                                                
                                                shortStoryClickDropViewBuilder(charactersSet: shortStoryDragDropVM.currentDragDropChoicesList, questionNumber: $questionNumber, progress: $progress, progress2: $progress2, showPlayer: $showPlayer, dragDropStoryObjects: shortStoryDragDropVM.currentDragDropQuestions, englishSentence: shortStoryDragDropVM.currentDragDropQuestions[i].fullSentence,italianSentences: italianSentence, questionNumberCount: shortStoryDragDropVM.currentDragDropQuestions.count, totalQuestions: shortStoryDragDropVM.currentDragDropQuestions.count ).frame(width: geo.size.width)
                                                    .frame(minHeight: geo.size.height)
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                .sheet(isPresented: $showingSheet) {
                                    SheetViewClickDropTest(chosenStoryNameIn: shortStoryName, showEnglish: showEnglish, shortStoryDragDropVM: shortStoryDragDropVM)
                                }
                                .scrollDisabled(true)
                                .onChange(of: questionNumber) { newIndex in
                                    withAnimation{
                                        scroller.scrollTo(newIndex, anchor: .center)
                                    }
                                    
//                                    if questionNumber == shortStoryDragDropVM.currentDragDropQuestions.count {
//                                        showPlayer = true
//                                    }
                                }
                                
                                NavigationLink(destination: ShortStoryPlugInView(shortStoryPlugInVM: ShortStoryViewModel(currentStoryIn: shortStoryName), shortStoryName: shortStoryName, isPreview: false),isActive: $showPlayer,label:{}
                                ).isDetailLink(false).id(UUID())
                            }.zIndex(1)
                            
//                            RoundedRectangle(cornerRadius: 20)
//                                .fill(Color("WashedWhite"))
//                                .frame(width: geo.size.width * 0.93, height: geo.size.height * 0.7)
//                                .overlay( /// apply a rounded border
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .stroke(.black, lineWidth: 4)
//                                )
//                                .zIndex(0)
//                                .offset(y: (geo.size.height / 9))
                            
                            
                            
                            
                        }.onDisappear{
                            infoManager.updateCorrectInput(activity: infoManager.getActivityFirstLaunchData())
                        }

                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                test = true
                                
                                
                            }
                            shortStoryDragDropVM.setData()
                            shortStoryDragDropVM.setChoiceArrayDataSet()
                            italianSentence = shortStoryDragDropVM.setItalianSentence()
                            
                        }
                    }
                }else{
                    ShortStoryDragDropViewIPAD(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: false, shortStoryName: shortStoryName)
                }
            }.navigationBarBackButtonHidden(true)
    }
    
}



struct shortStoryClickDropViewBuilder: View {
        
    //choices
    @State var charactersSet: [[dragDropShortStoryCharacter]]
    
    @State var characters: [dragDropShortStoryCharacter] = []
    
    //for drag
    @State var shuffledRows: [[dragDropShortStoryCharacter]] = []
    //for drop
    @State var rows: [[dragDropShortStoryCharacter]] = []
    
    @State var draggingItem: dragDropShortStoryCharacter?
    @State var updating: Bool = false
    
    @State var animateWrongText: Bool = false
    
    @State var droppedCount: CGFloat = 0
    @State var showCorrect = false
    @State var showCheck = false
    @State var showButton = false
    @State var showContinue = false
    @State var buttonDisabled = false

    @Binding var questionNumber: Int
    @Binding var progress: CGFloat
    @Binding var progress2: Int
    @Binding var showPlayer: Bool
    
    
    var dragDropStoryObjects: [dragDropShortStoryObject]
    var englishSentence: String
    var italianSentences: [String]
    var questionNumberCount: Int
    var totalQuestions: Int
    
    
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                VStack {
                    
                    VStack {
                        ZStack{
                            Text(englishSentence)
                                .bold()
                                .font(Font.custom("Georgia", size: geo.size.height * 0.02))
                                .padding()
                                .frame(width:geo.size.width * 0.93, height: geo.size.width * 0.3)
                                .background(Color("espressoBrown"))
                                .cornerRadius(10)
                                .foregroundColor(Color("themeGray"))
                                .multilineTextAlignment(.center)
                                .padding([.leading, .trailing], geo.size.width * 0.035)
                                .shadow(radius: 3)
                                .zIndex(1)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width:geo.size.width * 0.93, height: geo.size.width * 0.3)
                                .foregroundColor(Color("darkEspressoBrown"))
                                .zIndex(0)
                                .offset(y:7)
                                .shadow(radius: 3)
                        }
                    }
                    VStack{
                        if showCorrect {
                            Text(italianSentences[questionNumber])
                                .font(Font.custom("Georgia", size: 22))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }else{
                            DropArea().padding(.top, 50)
                        }
                       
                    }.frame(width: geo.size.width, height: geo.size.width * 0.35)
                        
               
                        DragArea().offset(y:50)
                            .zIndex(2)
                    
                        
                    
                    Button(action: {
                        if showCheck{
                            if checkAnswer(){
                                SoundManager.instance.playSound(sound: .correct)
                                withAnimation(.easeInOut(duration: 0.1)){
                                    showCheck = false
                                }
                                showContinue = true
                                withAnimation(.easeIn(duration: 1.0)){
                                    showCorrect = true
                                    
                                }
                                
                                
                            }else{
                                SoundManager.instance.playSound(sound: .wrong)
                                animateView()
                            }
                        }else{
                            buttonDisabled = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                
                                withAnimation(.easeIn(duration: 1.0)){
                                    if questionNumber != totalQuestions - 1 {
                                        progress2 = progress2 + 1
                                        
                                    }else{
                                        progress2 = totalQuestions
                                        
                                        
                                        
                                    }
                                }
                                
                            }
                          
                         
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                                
                                
                                if questionNumber != totalQuestions - 1 {
                                    questionNumber = questionNumber + 1
                                    showCorrect = false
                                    showContinue = false
                                    buttonDisabled = false

                                }else{
                                    
                                        showPlayer = true
                                    
                                    
                                }
                                
                            }
                        }
                    }, label: {
                        
                        Text(showCheck ? "Check" : "Next")
                            .bold()
                            .font(Font.custom("Georgia", size: geo.size.height * 0.027))
                            .padding()
                            .foregroundColor(.black)
                        
                    }).disabled(buttonDisabled)
                        .zIndex(2)
                        .frame(width: 130, height: 50)
                        .buttonStyle(ThreeDButton(backgroundColor: "white"))
                        .opacity(showButton ? 1 : 0)
                    
                }//.zIndex(1)
                
            }
        }
        .padding()
        .onChange(of: questionNumber) { newIndex in
            rows.removeAll()
            shuffledRows.removeAll()
            if questionNumber == questionNumberCount {
                
            }else{
                characters = charactersSet[newIndex]
            }
            if rows.isEmpty{
                //First Creating shuffled On
                //then normal one
                //characters = characters.shuffled()
                rows = generateGrid()
                characters = characters.shuffled()
                shuffledRows = generateGrid()
                //rows = generateGrid()
             
            }
    
        }
        .onAppear{
            if questionNumber == 0{
                characters = charactersSet[0]
            }else{
                characters = charactersSet[questionNumber]
            }
            if rows.isEmpty{
                //First Creating shuffled On
                //then normal one
                //characters = characters.shuffled()
                rows = generateGrid()
                characters = characters.shuffled()
                shuffledRows = generateGrid()
                //rows = generateGrid()
            }
        }
        .offset(x: animateWrongText ? -30 : 0)
    }
    
    @ViewBuilder
    func DropArea()->some View{
        VStack(spacing: 12){
            ForEach($rows, id: \.self){$row in
                HStack(spacing:10){
                    ForEach($row){$item in
                        Button(action: {
                            
                            let indexes = findShuffledRowIndexes(itemValue: item.value)
                            
                            
                            shuffledRows[indexes.0][indexes.1].value = item.value
                            shuffledRows[indexes.0][indexes.1].isShowing = false
                            
                            item.isShowing = false
                            item.value = item.originalValue
                            item.isWrong = false
                            
                            showCheck = false
                            showButton = false
                            
                        }, label: {
                            Text(item.value)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                                .padding(.vertical, 7)
                                .padding(.horizontal, item.padding)
                                .background{
                                    ZStack{
                                        if item.isWrong {
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("darkTerracotta"))
                                            
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("terracotta"))
                                                .offset(y: -4)
                                            
                                        }else{
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                                            
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                                .offset(y: -4)
                                            
                                            
                                            //.shadow(radius: 2)
                                            //
                                            //                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            //                                            .stroke(.black, lineWidth: 3).background(.white)
                                            //                                          //.shadow(radius: 2)
                                            
                                            
                                        }
                                    }
                                } .opacity(item.isShowing ? 1 : 0)
                        }).cornerRadius(10).enabled(item.isShowing)
                            .shadow(radius: 1.5)
                        
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func DragArea()->some View {
        VStack(spacing: 20){
            ForEach(shuffledRows, id: \.self){row in
                HStack(spacing:15){
                    ForEach(row){item in
                        Button(action: {
                        
                            let indexes = findFirstBlankObject()
                            let shuffledRowIndexes = findShuffledRowIndexes(itemValue: item.value)
                            

                            
                            withAnimation(.easeIn(duration: 0.0)){
                                rows[indexes.0][indexes.1].value = item.value
                                rows[indexes.0][indexes.1].isShowing = true
                            }
                        
                            
                            
                            shuffledRows[shuffledRowIndexes.0][shuffledRowIndexes.1].isShowing = true
                            
                            
                            if isAnswerFull(){
                                showCheck = true
                                showButton = true
                            }
                            
                            
                        }, label: {
                            Text(item.value)
                                .font(.system(size: 16))
                                .padding([.leading, .trailing], 3)
                                .foregroundColor(.black)
                                .padding(.vertical, 7)
                                .padding(.horizontal, item.padding)
                                .background{
                                    ZStack{
                                        
                                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("themeGray"))
                                            
                                        
                                        RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.white)
                                            .offset(y: -4)
             
                                          //.shadow(radius: 2)
//                                       
//                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
//                                            .stroke(.black, lineWidth: 3).background(.white)
//                                          //.shadow(radius: 2)
                                        
                                    
                                    }
                                }
                                .opacity(item.isShowing ? 0 : 1)
                        }).cornerRadius(10).enabled(!item.isShowing)
                            .shadow(radius: 1.5)
        
                    }
                }
                
            }
        }
    }
    
    func checkAnswer()->Bool{
       var tempCheck = false
        var tempArray: [String] = []
        for i in 0...rows.count-1 {
            for x in 0...rows[i].count-1 {
                tempArray.append(rows[i][x].value)
             
            }
          
        }
        
        for i in 0...tempArray.count-1{
            if tempArray[i] != dragDropStoryObjects[questionNumber].answerArray[i] {
                rows[findRowIndexes(itemValue: tempArray[i]).0][findRowIndexes(itemValue: tempArray[i]).1].isWrong = true
                
                tempCheck = true
            }else{
                rows[findRowIndexes(itemValue: tempArray[i]).0][findRowIndexes(itemValue: tempArray[i]).1].isWrong = false
            }
        }
        
        if tempCheck{
            return false
        }else{
            return true
        }
        

    }
    

    
    func isAnswerFull()->Bool{
        var isFull = true
        for i in 0...rows.count-1 {
            for x in 0...rows[i].count-1 {
                    if rows[i][x].isShowing == false {
                       isFull = false
                        
                    
                      
                        
                }
             
            }
          
        }
        return isFull
    }
    
    func findFirstBlankObject()->(Int, Int){
        var indexes = (rowIndex: 0, itemIndex: 0)
        for i in 0...rows.count-1 {
            for x in 0...rows[i].count-1 {
                    if rows[i][x].isShowing == false {
                        indexes.0 = i
                        indexes.1 = x
                        
                        return indexes
                      
                        
                }
             
            }
          
        }
        return indexes
      
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
    
    
    func generateGrid()->[[dragDropShortStoryCharacter]]{
        for item in characters.enumerated() {
            let textSize = textSize(character: item.element)
            
            characters[item.offset].textSize = textSize
            
        }
        
        var gridArray: [[dragDropShortStoryCharacter]] = []
        var tempArray: [dragDropShortStoryCharacter] = []
        
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
    
    func textSize(character: dragDropShortStoryCharacter)->CGFloat{
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font : font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        return size.width + (character.padding * 2) + 15
    }
    
    func updateShuffledArray(character: dragDropShortStoryCharacter){
        for index in shuffledRows.indices{
            for subIndex in shuffledRows[index].indices{
                if shuffledRows[index][subIndex].id == character.id{
                    shuffledRows[index][subIndex].isShowing = true
                }
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
}

struct SheetViewClickDropTest: View{
    @Environment(\.dismiss) var dismiss
    
    @State var chosenStoryNameIn: String
 
    @State var showPopUpScreen: Bool = false
    
    @State var linkClickedString: String = "placeHolder"
    @State var questionNumber: Int = 0
    
    @State var showEnglish = false
    @State var geoSizeWidth = UIScreen.main.bounds.width
    
    @StateObject var shortStoryDragDropVM: ShortStoryDragDropViewModel
    
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
      
            showPopUpScreen.toggle()
        
        return .handled
    }
    
}


struct popUpViewClickDrop: View{
    
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
                        withAnimation(.easeIn(duration: 0.75)){
                            showPopUpScreen.toggle()
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20)
                        
                    })
                  Spacer()
                }.padding()
               
            }.zIndex(0)
          
            VStack{
                
                
                Text(wordLink.infinitive)
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 25))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                    .padding([.leading, .trailing], 5)
                    .underline()
                
                
                Text(wordLink.wordNameEng)
                    .font(Font.custom("Arial Hebrew", size: 20))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 5)
                
                
                if wordLink.explanation != "" {
                    Text(wordLink.explanation)
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 15)
                        .padding(.top, 5)
                     
                        .padding([.leading, .trailing], 5)
                    
                    
                    
                }
                
                
                
            }.zIndex(1)
                .frame(width: geoSizeWidth * 0.7)
                .padding([.top, .bottom], 45)
                .padding([.leading, .trailing], geoSizeWidth * 0.05)
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





struct userCheckNavigationPopUpClickDrop: View{
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

struct ShortStoryClickDrop_Previews: PreviewProvider {
    static var shortStoryDragDropVM: ShortStoryDragDropViewModel = ShortStoryDragDropViewModel(chosenStoryName: "La Mia Introduzione")
    static var previews: some View {
        ShortStoryClickDrop(shortStoryDragDropVM: shortStoryDragDropVM, isPreview: true, shortStoryName: "La Mia Introduzione")
    }
}

