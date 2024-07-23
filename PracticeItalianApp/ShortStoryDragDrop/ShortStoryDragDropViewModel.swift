//
//  ShortStoryDragDropViewModel.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/18/23.
//

import SwiftUI

final class ShortStoryDragDropViewModel: ObservableObject{
    @Published private(set) var currentDragDropQuestions: [dragDropShortStoryObject] = [dragDropShortStoryObject]()
    @Published private(set) var currentDragDropChoicesList: [[dragDropShortStoryCharacter]] = [[dragDropShortStoryCharacter]]()
    @Published private(set) var currentStoryData: storyObject
    
    init(chosenStoryName: String){
        switch chosenStoryName {
        case "La Mia Introduzione":
            currentStoryData = storyObject.introduzione
        case "Il Mio Migliore Amico":
            currentStoryData = storyObject.amico
        case "La Mia Famiglia":
            currentStoryData = storyObject.famiglia
        case "Le Mie Vacanze in Sicilia":
            currentStoryData = storyObject.vacanza
        case "La Mia Routine":
            currentStoryData = storyObject.routine
        case "Ragù Di Maiale Brasato":
            currentStoryData = storyObject.ragu
        case "Il Mio Fine Settimana":
            currentStoryData = storyObject.weekend
            
        case "Il Mio Animale Preferito":
            currentStoryData = storyObject.animale
            
        case "Il Mio Sport Preferito":
            currentStoryData = storyObject.sport
            
        case "Il Mio Sogno nel Cassetto":
            currentStoryData = storyObject.sogno
            
        case "Il Mio Ultimo Compleanno":
            currentStoryData = storyObject.compleanno
            
        default:
            currentStoryData = storyObject.introduzione
        }
    }
    
    func setData(){
        var tempQuestionArray: [dragDropShortStoryObject] = [dragDropShortStoryObject]()
        var questionChoices: [dragDropShortStoryCharacter] = [dragDropShortStoryCharacter]()
        
        for question in currentStoryData.dragAndDropQuestions {
            questionChoices.removeAll()
            for choice in question.choices {
                questionChoices.append(dragDropShortStoryCharacter(value: choice, originalValue: choice))
            }
            
            tempQuestionArray.append(dragDropShortStoryObject(fullSentence: question.englishSentence, dragDropQuestionChoices: questionChoices, answerArray: question.choices))
            
        }
        
        currentDragDropQuestions = tempQuestionArray
    }
    
    func setChoiceArrayDataSet(){
        var tempArray: [[dragDropShortStoryCharacter]] = [[dragDropShortStoryCharacter]]()
        for storyObject in currentDragDropQuestions {
            tempArray.append(storyObject.dragDropQuestionChoices)
        }
        
        currentDragDropChoicesList = tempArray
        
    }
    
    func setItalianSentence()->[String]{
        var tempArray: [String] = []
        for question in currentStoryData.dragAndDropQuestions {
            var string = question.choices.joined(separator: " ")
            tempArray.append(string)
        }
            return tempArray
    }
}

struct dragDropShortStoryObject: Identifiable {
    var id = UUID().uuidString
    var fullSentence: String
    var dragDropQuestionChoices: [dragDropShortStoryCharacter]
    var answerArray: [String]
}

struct dragDropShortStoryCharacter: Identifiable, Hashable, Equatable {
        var id = UUID().uuidString
        var value: String
        var originalValue: String
        var padding: CGFloat = 10
        var textSize: CGFloat = .zero
        var fontSize: CGFloat = 17
        var isShowing: Bool = false
        var flip: Bool = false
        var showBack: Bool = false
        var flipped: Bool = false
        var isWrong:Bool = false
      

}


