//
//  ListeningActivityView2IPAD.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 2/21/24.
//

import SwiftUI


struct ListeningActivityView2IPAD: View {
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
                            .font(.system(size: 35))
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
                    Image(listeningActivityVM.audioAct.ipadImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width * 0.55, height: geo.size.height * 0.25)
                        .opacity(1.0)
                        .cornerRadius(85)
                        .shadow(radius: 10)
                    //ImageOnCircleListeningViewIPAD(icon: listeningActivityVM.audioAct.image, radius: geo.size.height * 0.1)
                    
                    
                    Text(listeningActivityVM.audioAct.title)
                        .font(.title)
                        .underline()
                        .foregroundColor(.black)
                        .padding(.bottom, 40)
                    
                    VStack{
                        HStack{
                            VStack{
                                Text("Conversation")
                                    .font(.system(size: 20))
                                
                                Text(DateComponentsFormatter.abbreviated.string(from: listeningActivityVM.audioAct.duration) ??
                                     listeningActivityVM.audioAct.duration.formatted() + "S")
                            }
                            Spacer()
                        }
                        
                        
                        
                        
                        Button(action: {
                            showPlayer2 = true
                            audioManager.startPlayer(track: listeningActivityVM.audioAct.track, isPreview: isPreview)
                        }
                               , label: {
                            Label("Play", systemImage: "play.fill")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                                .padding(.vertical, 10)
                                .frame(width: 400, height: 60)
                                .background(Color("WashedWhite"))
                                .cornerRadius(20)
                                .overlay( /// apply a rounded border
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.black, lineWidth: 4)
                                )
                        }).padding(.bottom, 20)
                            .padding(.top, 20)
                        
                        VStack{
                            Text(String(listeningActivityVM.audioAct.description))
                                .font(.system(size: geo.size.height * 0.022))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                               
                        }.padding(.bottom, 50)
                    }.frame(width:geo.size.width * 0.6)
                        .padding([.top, .bottom], 25)
                        .padding([.leading, .trailing], 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                        .fill(Color("DarkNavy"))
                        .shadow(radius: 15))
                    .foregroundColor(.white)
                    
                    Text("Audio and Transcriptions by Virginia Billie")
                        .font(Font.custom("Hebrew Arial", size: 20))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing], 20)
                        .frame(width: 430, height: 50)
                        .background(Color("WashedWhite"))
                        .cornerRadius(20)
                        .overlay( /// apply a rounded border
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.black, lineWidth: 6)
                        )
                        .padding(.top, 20)
                      
                }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.9)
                    .padding([.leading, .trailing], geo.size.width * 0.05)
                    .padding([.top, .bottom], geo.size.height * 0.05)
                
                
                NavigationLink(destination: listeningActivityIPAD(listeningActivityVM: listeningActivityVM),isActive: $showPlayer2,label:{}
                                                  ).isDetailLink(false)
                
                
                
            }
        }
    }
}

struct ListeningActivityView2IPAD_Previews: PreviewProvider {
    static let listeningActivityVM  = ListeningActivityViewModel(audioAct: audioActivty.pastaCarbonara)
    static var previews: some View {
        ListeningActivityView2IPAD(listeningActivityVM: listeningActivityVM, shortStoryName: "Pasta Carbonara", isPreview: true)
            .environmentObject(AudioManager())
            .environmentObject(ListeningActivityManager())
    }
}
