//
//  ListeningActivityView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/8/23.
//

import SwiftUI

struct ListeningActivityView: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    //@StateObject var listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
    @State private var showPlayer2 = false
    
    var shortStoryName: String
    var isPreview: Bool
    
    var body: some View {
        GeometryReader{geo in
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
                            .frame(width: geo.size.width * 0.1, height: geo.size.height * 0.45)
                            .offset(x: geo.size.width * 0.05, y: geo.size.height * 0.1)
                          
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
                    NavigationLink(destination: ContentView(), label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                        
                    }).padding(.leading, 25).id(UUID())
                    
                    Spacer()
                    
                    Image("italy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .padding(.trailing, 30)
                        
                }
                
                
                
                ZStack{
                    VStack{
                        VStack{
                            VStack{
                                
                                VStack(spacing: 0){
                                    Image(listeningActivityVM.audioAct.image)
                                        .resizable()
                                        .scaledToFill()
                                        .edgesIgnoringSafeArea(.all)
                                        .frame(width: geo.size.width * 0.15, height: geo.size.height * 0.15)
                                        .padding(.bottom, 15)
                                    
                                    
                                    Text(listeningActivityVM.audioAct.title)
                                        .font(Font.custom("Georgia", size: 25))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .frame(width: geo.size.width * 0.8)
                                        .padding(.bottom, 20)
                                    
                                    Rectangle()
                                        .fill(Color("terracotta"))
                                        .frame(width: geo.size.width * 0.85, height:6)
                                        .edgesIgnoringSafeArea(.horizontal)
                                        .padding(.bottom, 10)
                                }.offset(y: -15)
                                
                                VStack(alignment: .leading){
                                    Text("Conversation")
                                    
                                    Text(DateComponentsFormatter.abbreviated.string(from: listeningActivityVM.audioAct.duration) ??
                                         listeningActivityVM.audioAct.duration.formatted() + "S")
                                }.padding(.trailing, 200)
                                    .padding(.bottom, 25)
                                    .offset(y: 10)
                                
                            }
                            
                            Button(action: {
                                showPlayer2 = true
                                //audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                            }
                                   , label: {
                                Label("Play", systemImage: "play.fill")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 10)
                                    .frame(width: 310, height: 50)
                                    // .background(Color("ForestGreen"))
//                                    .cornerRadius(20)
//                                    .overlay( /// apply a rounded border
//                                        RoundedRectangle(cornerRadius: 20)
//                                            .stroke(.black, lineWidth: 3)
//                                    )
                                   // .shadow(radius: 5)
                            }).padding(.bottom, 35).buttonStyle(ThreeDButton(backgroundColor: "white")) .frame(width: 280, height: 50)
                                .padding(.top, 10)
                            
                            VStack{
                                Text(String(listeningActivityVM.audioAct.description))
                                    .font(Font.custom("Georgia", size: 18))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(width: geo.size.width * 0.82, height: 10)
                            }.padding(.top, 90)
                            
                            Text("Audio and Transcriptions by Virginia Billie")
                                .font(Font.custom("Arial Hebrew", size: 14))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding([.leading, .trailing], 20)
                                .frame(width: 320, height: 70)
                                //.background(Color("WashedWhite"))
                                .cornerRadius(20)
                            
                               .offset(y:100)
                            
                        }.zIndex(1)
                            .padding(20)
                        
                        
                        
                        
                        
                    }
                    
                    NavigationLink(destination: listeningActivity(listeningActivityVM: listeningActivityVM),isActive: $showPlayer2,label:{}
                    ).isDetailLink(false).id(UUID())
                    
                }  .ignoresSafeArea()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .navigationBarBackButtonHidden(true)
                
            }else{
                ListeningActivityView2IPAD(listeningActivityVM: listeningActivityVM, shortStoryName: shortStoryName, isPreview: false)
            }
        }
    
        
        
    }
}

struct ImageOnCircle: View {
    
    let icon: String
    let radius: CGFloat
    var squareSide: CGFloat {
        2.0.squareRoot() * radius
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("WashedWhite"))
                .frame(width: radius * 2, height: radius * 2)
                .overlay(Circle().stroke(.black, lineWidth: 3))
            Image(icon)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
        }
    }
}

struct ListeningActivityView_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.appartamento)
    static var previews: some View {
        ListeningActivityView(listeningActivityVM: listeningActivityVM, shortStoryName: "appartamento", isPreview: true)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}
