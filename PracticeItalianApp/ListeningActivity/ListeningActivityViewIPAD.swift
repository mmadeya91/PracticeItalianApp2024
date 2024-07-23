//
//  ListeningActivityViewIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/3/24.
//

import SwiftUI

struct ListeningActivityViewIPAD: View {
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var listeningActivityManager: ListeningActivityManager
    @StateObject var listeningActivityVM: ListeningActivityViewModel
    //@StateObject var listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.data)
    @State private var showPlayer2 = false
    
    var shortStoryName: String
    var isPreview: Bool
    
    var body: some View {
        GeometryReader{geo in
            ZStack(alignment: .topLeading){
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            HStack(spacing: 18){
                NavigationLink(destination: chooseAudio(), label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 45))
                        .foregroundColor(.black)
                    
                }).padding(.leading, 25)
                
                Spacer()
                
                Image("italyFlag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .padding(.trailing, 30)
                    .shadow(radius: 10)
            }
            
            
        
                VStack{
                    VStack{
                        
                        ImageOnCircleListeningViewIPAD(icon: listeningActivityVM.audioAct.image, radius: 120)
                        
                        
                        Text(listeningActivityVM.audioAct.title)
                            .font(.title)
                            .underline()
                            .foregroundColor(.black)
                            .padding(.bottom, 40)
                    }
                    VStack{
                            
                            VStack(alignment: .leading){
                                Text("Conversation")
                                    .font(.system(size: 26))
                                   
                                Text(DateComponentsFormatter.abbreviated.string(from: listeningActivityVM.audioAct.duration) ??
                                     listeningActivityVM.audioAct.duration.formatted() + "S")
                            }.padding(.trailing, 350).padding(.top, 15)
                              
                            
                
                        
                        Button(action: {
                            showPlayer2 = true
                            audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                        }
                               , label: {
                            Label("Play", systemImage: "play.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                                .padding(.vertical, 10)
                                .frame(width: 450, height: 60)
                                .background(Color("WashedWhite"))
                                .cornerRadius(20)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 4)
                                )
                        }).padding(.bottom, 20)
                        
                        VStack{
                            Text(String(listeningActivityVM.audioAct.description))
                                .font(.system(size: 26))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(width: 500, height: 10)
                        }.padding(.top, 70)
                        
                        Text("Audio and Transcriptions by Virginia Billie")
                            .font(Font.custom("Hebrew Arial", size: 20))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 20)
                            .frame(width: 560, height: 70)
                            .background(Color("WashedWhite"))
                            .cornerRadius(20)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 6)
                            )
                      
                        
                    }.zIndex(1)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("DarkNavy"))
                                .frame(width: 550, height: 580)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(.black, lineWidth: 4)
                                )
                                .shadow(radius: 10)
                                .padding([.leading, .trailing], 10)
                                .zIndex(0))
                    
                    
                    
                }.foregroundColor(.white)
                    .padding(.top, 300)
                
                NavigationLink(destination: listeningActivityIPAD(listeningActivityVM: listeningActivityVM),isActive: $showPlayer2,label:{}
                                                  ).isDetailLink(false)
                
            }  .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
            
        }
        
        
        
    }
}

struct ImageOnCircleListeningViewIPAD: View {
    
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
                .overlay(Circle().stroke(.black, lineWidth: 4))
            Image(icon)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .frame(width: squareSide, height: squareSide)
                .foregroundColor(.blue)
        }
    }
}

struct ListeningActivityViewIPAD_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
    static var previews: some View {
        ListeningActivityViewIPAD(listeningActivityVM: listeningActivityVM, shortStoryName: "Pasta Carbonara", isPreview: true)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}
