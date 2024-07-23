//
//  PopOverView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 7/15/24.
//

import SwiftUI

struct PopOverView: View {
    
    var textIn: String
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
                             attachmentAnchor: .point(.bottom),
                             arrowEdge: .bottom,
                             content: {
                        VStack {
                            Text(textIn)
     
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

#Preview {
    PopOverView(textIn: "Do your best to read and understand the following short stories on various topics. \n \nWhile you read, pay attention to key vocabulary words as you will be quizzed after on your comprehension!", infoBubbleColor: Color.black, frameHeight: CGFloat(300.0), isInfoPopTipShown: true)
}
