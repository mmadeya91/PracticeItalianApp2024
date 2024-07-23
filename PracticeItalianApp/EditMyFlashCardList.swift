//
//  EditMyFlashCardList.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/11/24.
//

//
//  ListViewOfAvailableVerbs.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/3/23.
//

import SwiftUI
import CoreData

struct EditMyFlashCardList: View {
    
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isEmpty: Bool = false
  
    @State var showUserCheck: Bool = false
    @State var availableFlashCards: [UserMadeFlashCard] = []
    @State var search: String = ""
    @State var showCreateFlashCard: Bool = false
    @State var showingSheet: Bool = false
    @State var isEditing = false
    @State var reloadMyList = false
    @State private var refreshingID = UUID()
    @ObservedObject var editMyFlashCardListVM = EditMyFlashCardListManager()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    
    var editBtnTxt : String {
        
        if let isEditing = editMode?.wrappedValue.isEditing {
            return isEditing ? "Done" : "Edit"
        }else {
            return ""
        }
    }
    
    
    var body: some View {
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
                    
                    VStack{
                        HStack(spacing: 18){
                        
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(.leading, 25)
                                
                                
                                
                            })
                            Spacer()
                            Image("italy")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .padding(.trailing, 30)
                          
                            
                        }
                        
                    }
                    
                    
                    
                    ZStack{
                        VStack{
                            
                            
                            Text("Are you sure you want to clear your list? \n\nThis will delete all current flash cards you have in your \"MyList\"")
                               // .bold()
                                .font(Font.custom("Georgia", size: geo.size.width * 0.05))
                                .foregroundColor(Color.red)
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                                .padding(.bottom, 10)
                                .padding([.leading, .trailing], 20)

                            
                            HStack{
                                Spacer()
                                
                                Button(action: {
                                    editMyFlashCardListVM.deleteUserList()
                                    editMyFlashCardListVM.updateObservableList()
                                    showUserCheck.toggle()
                                }
                                       
                                       , label: {
                                    Text("Yes")
                                        .font(Font.custom("Georgia", size: geo.size.width * 0.04))
                                        .foregroundColor(Color.black)
                                }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 70, height: 35)
                                
                                
                                Spacer()
                                
                                
                                Button(action: {showUserCheck.toggle()}, label: {
                                    Text("No")
                                        .font(Font.custom("Georgia", size: geo.size.width * 0.04))
                                        .foregroundColor(Color.black)
                                }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: 70, height: 35)
                                Spacer()
                            }.padding(.top, 15)
                            
                        }
                        
                        
                    }.frame(width: geo.size.width * 0.85, height: geo.size.height * 0.4)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding([.leading, .trailing], geo.size.width * 0.075)
                        .padding([.top, .bottom], geo.size.height * 0.25)
                        .shadow(radius: 5)
                        .opacity(showUserCheck ? 1.0 : 0.0)
                        .zIndex(2)
                    
                    
                    VStack(alignment: .leading){
                        
                        Text("MyList")
                            .font(Font.custom("Georgia", size: 35))
                            .padding(.top, 60)
                            .frame(width: geo.size.width * 0.3)
                            .overlay(
                                Rectangle()
                                    .fill(Color("terracotta"))
                                    .frame(width: 120, height: 2.5)
                                , alignment: .bottom
                            )
                            .padding([.leading, .trailing], geo.size.width * 0.35)
                        
                        NavigationView{
                          
                            List{
                                let compactedArray: [UserFlashCardList] = editMyFlashCardListVM.fetchedUserCreatedFlashCards
                                    ForEach(0..<compactedArray.count, id: \.self) {i in
                                        VStack{
                                            
                                            let vbItal = compactedArray[i].italianLine1 ?? "defaultItal"
                                            
                                            let vbEngl = compactedArray[i].englishLine1 ?? "defaultEng"
                                            
                                            HStack{
                                                Text(vbItal + " - " + vbEngl)
                                            }
                                        }
                                    }
                                    .onDelete(perform: editMyFlashCardListVM.removeRows)
                                    .id(refreshingID)
                                    //.map { "\($0)" }
                                   // .filter { search.isEmpty ? true : $0.contains(search) }
                                
                                }//.id(UUID().uuidString)
                          
                                .overlay(Group {
                                    if editMyFlashCardListVM.isEmptyMyListFlashCardData() {
                                        Text("Oops, loos like there's no data...")
                                    }
                                })
                                .navigationBarItems(leading: HStack{
                                    Button(action: {
                                        self.isEditing.toggle()
                                    }, label: {
                                        Text(isEditing ? "Done" : "Edit")
                                            .font(Font.custom("Georgia", size: 22))
                                            .foregroundColor(.black)
                                            .frame(width: 80, height: 20)
                                            .padding(.top, 25)
                                    })
                                }, trailing: Button(action: onAdd) { Image(systemName: "plus").resizable().scaledToFill().padding(.trailing, 45).frame(width: 25, height: 25).padding(.top, 12)}.foregroundColor(.black))
                                .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                                .padding(.top, 10)
                               
                               
                                
                         
                        }.frame(width: geo.size.width * 0.8, height: geo.size.height * 0.7).cornerRadius(15)
                            .padding([.leading, .trailing], geo.size.width * 0.1)
                            
                            
                        
                        HStack(spacing: 25){
                            Spacer()
                            Button(action: {
                                showCreateFlashCard.toggle()
                            }, label: {
                                Text("Create FlashCard")
                                    .font(Font.custom("Georgia", size: 14))
                                    .foregroundColor(.black)
                                    //.frame(width: 150, height: 40)
                                    //.background(Color("terracotta"))
                                    .cornerRadius(15)
                                    //.shadow(radius: 3)
                                   // .padding(.top, 30)
                                
                            }).buttonStyle(ThreeDButton(backgroundColor: "white"))                .frame(width: 130, height: 35)
                           
                            Button(action: {
                                showUserCheck.toggle()
                            }, label: {
                                Text("Clear List")
                                    .font(Font.custom("Georgia", size: 14))
                                    .foregroundColor(.black)
                                    //.frame(width: 150, height: 40)
                                    //.background(Color("terracotta"))
                                    .cornerRadius(15)
                                    //.shadow(radius: 3)
                                   // .padding(.top, 30)
                                
                            }).buttonStyle(ThreeDButton(backgroundColor: "white"))                .frame(width: 130, height: 35)
                            Spacer()
                        }.padding(.top, 30)
                        
                    }
                    
                }.onAppear{
                    let appearance = UINavigationBarAppearance()
                    appearance.shadowImage = UIImage()
                    UINavigationBar.appearance().standardAppearance = appearance
                    appearance.backgroundEffect = nil
                    appearance.shadowColor = UIColor.white
                  
                }
            }else{
                ListViewOfAvailableVerbsIPAD()
            }
            
        
            
            
        }.sheet(isPresented: $showingSheet,  onDismiss: {
            viewContext.reset()
            self.refreshingID = UUID()}) {
                availableFlashCardsSheet(editMyFlashCardListManager: editMyFlashCardListVM)
        }
        .fullScreenCover(isPresented: $showCreateFlashCard) {
            createFlashCard(editMyListManager: editMyFlashCardListVM)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
           
            if editMyFlashCardListVM.isEmptyMyListFlashCardData() {
                isEmpty = true
            }
            
//            else{
//                editMyFlashCardListVM.loadFlashCardData()
//            }
        }
        
    }
    
    private func onAdd() {
        showingSheet.toggle()
     }
    

    
}




struct availableFlashCardsSheet: View {
   
    @Environment(\.dismiss) var dismiss
    
 
    @State var search = ""
    @State var showCreateVerb: Bool = false
    @State var showingSheet: Bool = false
    @State var listViewWords = [listViewWordObject]()
    @State var saved: Bool = true
    var editMyFlashCardListManager: EditMyFlashCardListManager
    
    var filteredFlashCards: [listViewWordObject] {
        if search.isEmpty {
           listViewWords
        } else {
            listViewWords.filter { $0.englishLine1.localizedStandardContains(search) }
        }
    }
    
    
    var body: some View{
        GeometryReader{ geo in
            ZStack(alignment: .topLeading){
                
                Image("Screen Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
         
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 25))
                        .foregroundColor(.black)
                    
                }).padding(15).padding(.top, 10)
                   
                VStack{
        
                        Text("Choose from the available 1000 most common Italian words. \n\nAny flashcard you create yourself can also be found in this list.")
                            .font(Font.custom("Georgia", size: 15))
                            .multilineTextAlignment(.center)
                            .padding(15)
                            .frame(width: geo.size.width * 0.8)
                            .padding([.leading, .trailing], geo.size.width * 0.1)
                            .padding(.bottom, 5)
                            
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .padding(.leading, CGFloat(10.0))
                        TextField("Search", text: $search, onEditingChanged: { active in
                            print("Editing changed: \(active)")
                        }, onCommit: {
                            print("Commited: \(self.search)")
                        })
                        .padding(.vertical, CGFloat(4.0))
                        .padding(.trailing, CGFloat(10.0))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(Color.secondary, lineWidth: 1.0)
                    )
                    .padding([.leading, .trailing], 25)
                    .padding([.top, .bottom], 5)
                       
                    List{
                        ForEach(0..<filteredFlashCards.count, id: \.self) {i in
                            HStack{
                                Text(filteredFlashCards[i].italianLine1 + " - " + filteredFlashCards[i].englishLine1)
                                Spacer()
                                Toggle("", isOn: self.$listViewWords[i].isToggled)
                            }
                        }
                    }.searchable(text: $search, prompt: "Search")
                    .frame(width: geo.size.width * 0.86/* height: geo.size.height * 0.6*/)
                        .padding([.leading, .trailing], geo.size.width * 0.07)
         
                        
                    .onAppear{
                        listViewWords = createListViewObjects()
                    }
                    .onDisappear{
                        editMyFlashCardListManager.updateObservableList()
                    }
                    .padding(.top, 10)
                    
       
                        
                        Button(action: {
                            saved = false
                          
                            for card in listViewWords {
                                if card.isToggled{
                                 
                                    editMyFlashCardListManager.addNewUserAddedFlashCard(engLine1: card.englishLine1, italLine1: card.italianLine1, italLine2: card.italianLine2, engLine2: card.englishLine2)
                             
                                }
                                
                            }
                            
                        
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                saved = true
                            }
                        }, label: {
                            Text(saved ? "Save" : "Save Succesful!")
                                .font(.system(size: 17))
                               // .padding(20)
                                .padding(.top, 5)
                                .foregroundColor(.black)
                               // .frame(height: 40)
                               // .background(Color("terracotta"))
                                //.cornerRadius(10)
                                .shadow(radius: 1)
                                //.padding(.top, 15)
                              
                            
                        }).buttonStyle(ThreeDButton(backgroundColor: "white")).frame(width: saved ? "Save".widthOfString(usingFont: UIFont.systemFont(ofSize: 17, weight: .bold)) + 50: "Save Succesful".widthOfString(usingFont: UIFont.systemFont(ofSize: 17, weight: .bold)) + 50, height: 40).padding(.top, 20)
                        .enabled(saved).padding(.bottom, 20)
                          
            
                    
                    
                }.padding(.top, 45)
                
            }
        }.ignoresSafeArea(.keyboard)
    }
    
    func createListViewObjects()->[listViewWordObject]{
        var tempArray:[listViewWordObject] = [listViewWordObject]()
        for flashObj in editMyFlashCardListManager.allAvailableFlashCards.unique(map: {$0.wordItal}) {
            tempArray.append(listViewWordObject(italianLine1: flashObj.wordItal, englishLine1: flashObj.wordEng, englishLine2: flashObj.gender))
        }
        return tempArray.sorted {$0.italianLine1.lowercased() < $1.italianLine1.lowercased() }
    }
    
    
    struct listViewWordObject: Identifiable{
        var id = UUID().uuidString
        var isToggled = false
        var italianLine1: String
        var italianLine2 = ""
        var englishLine1: String
        var englishLine2: String

    }
    
}

struct EditMyFlashCardList_Previews: PreviewProvider {
    static var previews: some View {
        EditMyFlashCardList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
