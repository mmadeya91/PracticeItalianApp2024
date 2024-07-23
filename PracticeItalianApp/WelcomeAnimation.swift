//
//  WelcomeAnimation.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 5/9/24.
//

import SwiftUI



struct WelcomeAnimation: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var globalModel: GlobalModel



    @State var animate: Bool = false
    @State var showBearAni: Bool = false
    @State private var var_x = 1


    var body: some View {
                        GeometryReader{ geo in
                            ZStack(alignment: .topLeading){
                               Color("ForestGreen")
                                    .ignoresSafeArea()
    
        
        
                               
                                    GifImage("italAppGif")
                                        .offset(y: 200)
                                        //.animation(.linear(duration: 11 ))
                                       // .onAppear { self.var_x *= -1}
        
                               
        
        
                            }.onAppear{
                                if !globalModel.appHasBeenOpened{
                                    SoundManager.instance.playSound(sound: .introMusic)
                                }
                            }
                        }
    
    }
}

#Preview {
    WelcomeAnimation().environmentObject(GlobalModel())
}
