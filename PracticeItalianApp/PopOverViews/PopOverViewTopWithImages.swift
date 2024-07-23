//
//  PopOverViewTopWithImages.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 7/17/24.
//

import SwiftUI

struct PopOverViewTopWithImages: View {
    
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
                             attachmentAnchor: .point(.bottom),
                             arrowEdge: .bottom,
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
//    PopOverViewTopWithImages()
//}
