//
//  chooseActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/13/23.
//

import SwiftUI




struct chooseActivity: View {
    @State var selectedTab: Tab = .Home
    @State var animatingBear = false
    @State var showChatBubble = false
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var globalModel: GlobalModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let flashCardSetAccObj = FlashCardSetAccDataManager()
    
    
    var body: some View {
                if horizontalSizeClass == .compact {
                        TabView {
                            availableShortStories()
                                .tabItem {
                                    Image(systemName: "book")
                                }
                            HomeScreen()
                                .tabItem {
                                    Image(systemName: "house")
                                }
                            
                            availableShortStories()
                                .tabItem {
                                    Image(systemName: "book")
                                }
                            
                            chooseAudio()
                                .tabItem {
                                    Image(systemName: "headphones")
                                }
                            
                            chooseFlashCardSet()
                                .tabItem {
                                    Image(systemName: "photo.stack")
                                }
                            
                            chooseVerbList()
                                .tabItem {
                                    Image(systemName: "gear")
                                }
                        }.accentColor(.red)
           
                    
      
                }else{
                    chooseActivityIPAD()
                }
         
       
   
    }
}

struct chooseActivity_Previews: PreviewProvider {
    static var previews: some View {
        chooseActivity().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(AudioManager())
            .environmentObject(GlobalModel())
        
        
    }
}
