//
//  PopOverViewBottom.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 7/15/24.
//

import SwiftUI

struct PopOverViewBottom: View {
    
    var textIn: Text
    var infoBubbleColor: Color
    var frameHeight: CGFloat
    
    @State var isInfoPopTipShown: Bool

    
    //@available(iOS 16.4, *)
    var body: some View {
        VStack {
            Button {
                isInfoPopTipShown.toggle()
            } label: {
                iconView
                    .popover(isPresented: self.$isInfoPopTipShown,
                             attachmentAnchor: .point(.top),
                             arrowEdge: .top,
                             content: {
                        VStack {
                            
                            textIn
     
                        }
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .padding()
                        .presentationCompactAdaptation(.popover)
                        .frame(height: frameHeight)
                       
                    })
            }
            
//            Spacer()
                //.frame(height: 400)

            
        }
        .padding()
    }
    
    private var iconView: some View {
        Image(systemName: "info.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
            .foregroundStyle(infoBubbleColor)
    }
    

}

//#Preview {
//    var textIn: Text = (Text("Lines of audio from the dialogue will play one by one. Some of them will be missing important keywords that you must figure out and input in the text box. \n\nNot all of the dialogues pose a question, in that case use the  ") +
//                        Text(Image(systemName: "arrow.forward.circle")) +
//                        Text("  button to continue forward. If you need to hear a portion of the dialogue again, just use the  ") +
//                        Text(Image(systemName: "arrow.triangle.2.circlepath")) +
//                        Text("  button. If you are having trouble, there are hints available to you as well. \n\nRemember, spelling is important! including accents! It may be usefull to switch the keyboard on your phone to 'Italian' to make things easier."))
//    
//    PopOverViewBottom(textIn: textIn, infoBubbleColor: Color.black, frameHeight: CGFloat(300.0), isInfoPopTipShown: true)
//}

