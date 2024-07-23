//
//  ListViewOfAvailableVerbs.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/3/23.
//

import SwiftUI



struct ListViewOfAvailableVerbs: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isEmpty: Bool = false
  
    @State var showUserCheck = false
    @State var showCreateVerb: Bool = false
    @State var showingSheet: Bool = false
    @State var isEditing = false
    @State var reloadMyList = false
    @State private var refreshingID = UUID()
    @ObservedObject var editVerbListManager = EditVerbListManager()
    
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
                    }.zIndex(0)
                    
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
                    }.zIndex(0)
                    
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
                            
                            
                            Text("Are you sure you want to clear your list? \n\nThis will delete all current verbs you have in your \"MyList\"")
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
                                    editVerbListManager.deleteUserList()
                                    editVerbListManager.updateObservableList()
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
                                    let compactedArray: [UserVerbList] = editVerbListManager.fetchedUserVerbList
                                    ForEach(0..<compactedArray.count, id: \.self) {i in
                                        VStack{
                                            
                                            let vbItal = compactedArray[i].verbNameItalian ?? "defaultItal"
                                            
                                            let vbEngl = compactedArray[i].verbNameEnglish ?? "defaultEng"
                                            
                                            HStack{
                                                Text(vbItal + " - " + vbEngl)
                                            }
                                        }
                                    }
                                    .onDelete(perform: editVerbListManager.removeRows)
                                    .id(refreshingID)
                                    
                                }
                                .overlay(Group {
                                    if editVerbListManager.isEmptyMyListVerbData() {
                                        Text("Oops, loos like there's no data...")
                                    }
                                })
                                .navigationBarItems(leading: HStack{
                                    Button(action: {
                                        self.isEditing.toggle()
                                    }, label: {
                                        Text(isEditing ? "Done" : "Edit")
                                            .font(Font.custom("Georgia", size: 25))
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
                            
                            
                        
//                        HStack{
//                            
//                            Button(action: {
//                                showCreateVerb.toggle()
//                            }, label: {
//                                Text("Create Verb")
//                                    .font(Font.custom("Futura", size: 17))
//                                    .foregroundColor(.black)
//                                    .frame(width: 150, height: 40)
//                                    .background(Color("terracotta"))
//                                    .cornerRadius(15)
//                                    .shadow(radius: 3)
//                                    .padding(.top, 30)
//                                
//                            })
//                            
//                        }.frame(width: 390, height: 50)
                        
                    }
                    
                }.onAppear{
                    let appearance = UINavigationBarAppearance()
                    appearance.shadowImage = UIImage()
                    UINavigationBar.appearance().standardAppearance = appearance
                    appearance.backgroundEffect = nil
                    appearance.shadowColor = UIColor.white
                  
                }
            }else{
               // ListViewOfAvailableVerbsIPAD()
            }
            
        
            
            
        }.sheet(isPresented: $showingSheet, onDismiss: {
            viewContext.reset()
            self.refreshingID = UUID()}) {
                availableVerbsSheet(editVerbListManager: editVerbListManager)
        }
        .onAppear{
           
            if editVerbListManager.isEmptyMyListVerbData() {
                isEmpty = true
            }
        }
        
    }
    
    private func onAdd() {
        showingSheet.toggle()
     }
    
}

struct availableVerbsSheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State var search: String = ""
    
    @State var showCreateVerb: Bool = false
    @State var showingSheet: Bool = false
    @State var listViewVerbs = [listViewVerbObject]()
    @State var saved: Bool = true
    
    var editVerbListManager: EditVerbListManager
    
    var filteredVerbs: [listViewVerbObject] {
           if search.isEmpty {
              listViewVerbs
           } else {
               listViewVerbs.filter { $0.verbNameEnglish.localizedStandardContains(search) }
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
        
                        Text("Choose from the available 1000 most common Italian verbs to add to your unique practice list!")
                            .font(Font.custom("Georgia", size: 17))
                            .multilineTextAlignment(.center)
                            .padding(15)
                            .frame(width: geo.size.width * 0.7)
                            .padding([.leading, .trailing], geo.size.width * 0.1)
                            
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
                        ForEach(0..<filteredVerbs.count, id: \.self) {i in
                            HStack{
                                Text(filteredVerbs[i].verbNameItalian + " - " + filteredVerbs[i].verbNameEnglish)
                                Spacer()
                                Toggle("", isOn: self.$listViewVerbs[i].isToggled)
                            }
                        }
                    }.searchable(text: $search, prompt: "Search")
                    .frame(width: geo.size.width * 0.86, height: geo.size.height * 0.6)
                        .padding([.leading, .trailing], geo.size.width * 0.07)
         
                        
                    .onAppear{
                        listViewVerbs = createListViewObjects()
                    }
                    .padding(.top, 10)
                    
       
                        
                        Button(action: {
                            saved = false
                            for ver in listViewVerbs {
                                if ver.isToggled{
                                    editVerbListManager.addNewUserAddedVerb(verbNameItal: ver.verbNameItalian, verbNameEngl: ver.verbNameEnglish, presente: ver.presentConjList, passatoProssimo: ver.passatoProssimo, futuro: ver.futuro, imperfetto: ver.imperfetto, condizionale: ver.presCondizionale, imperativo: ver.imperativo)
                                }
                                
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                saved = true
                            }
                        }, label: {
                            Text(saved ? "Save" : "Save Succesful!")
                                .font(Font.custom("Georgia", size: 20))
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
                
            }.onDisappear{
                editVerbListManager.updateObservableList()
            }
        }
    }

    
    func createListViewObjects()->[listViewVerbObject]{
        var tempArray:[listViewVerbObject] = [listViewVerbObject]()
        for verbObj in editVerbListManager.allAvailableVerbs.unique(map: {$0.verb.verbName}) {
            tempArray.append(listViewVerbObject(verbNameItalian: verbObj.verb.verbName, verbNameEnglish: verbObj.verb.verbEngl, presentConjList: verbObj.presenteConjList, passatoProssimo: verbObj.passatoProssimoConjList, futuro: verbObj.futuroConjList, imperfetto: verbObj.imperfettoConjList, presCondizionale: verbObj.presenteCondizionaleConjList, imperativo: verbObj.imperativoConjList))
        }
        return tempArray
    }
    
    
    struct listViewVerbObject: Identifiable{
        var id = UUID().uuidString
        var isToggled = false
        var verbNameItalian: String
        var verbNameEnglish: String
        var presentConjList: [String]
        var passatoProssimo: [String]
        var futuro: [String]
        var imperfetto: [String]
        var presCondizionale: [String]
        var imperativo: [String]
    }
    
}

struct ListViewOfAvailableVerbs_Previews: PreviewProvider {
    static var previews: some View {
        ListViewOfAvailableVerbs().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
