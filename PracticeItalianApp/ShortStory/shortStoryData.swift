//
//  shortStoryData.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/8/23.
//

import Foundation


class shortStoryData {
    
    var chosenStoryName: String
    
    init(chosenStoryName: String) {
        self.chosenStoryName = chosenStoryName
    }
    
    func collectShortStoryData(storyName: String) -> shortStoryObject{
        
        let shortStoryList: [storyObject] = storyObject.allStoryObjects
        
        var chosenStoryObject: storyObject = shortStoryList[0]
        
        switch chosenStoryName {
        case "La Mia Introduzione":
            chosenStoryObject = shortStoryList[0]
        case "Il Mio Migliore Amico":
            chosenStoryObject = shortStoryList[1]
        case "La Mia Famiglia":
            chosenStoryObject = shortStoryList[2]
        case "Le Mie Vacanze in Sicilia":
            chosenStoryObject = shortStoryList[3]
        case "La Mia Routine":
            chosenStoryObject = shortStoryList[4]
        case "Ragù Di Maiale Brasato":
            chosenStoryObject = shortStoryList[5]
        case "Il Mio Fine Settimana":
            chosenStoryObject = shortStoryList[6]
            
        case "Il Mio Animale Preferito":
            chosenStoryObject = shortStoryList[7]
            
        case "Il Mio Sport Preferito":
            chosenStoryObject = shortStoryList[8]
            
        case "Il Mio Sogno nel Cassetto":
            chosenStoryObject = shortStoryList[9]
            
        case "Il Mio Ultimo Compleanno":
            chosenStoryObject = shortStoryList[10]
            
        default:
            chosenStoryObject = shortStoryList[0]
        }
        
        shortStoryList.forEach { storyObject in
            if storyObject.storyName == chosenStoryName {
                chosenStoryObject = storyObject
            }
        }

        let storyString = chosenStoryObject.story
        
        let storyStringEnglish = chosenStoryObject.storyEnglish

        let wordLinks: [WordLink] = chosenStoryObject.wordLinks

        let questions: [QuestionsObj] = chosenStoryObject.questionsObjs
        
        let choicesList: [[String]] = shuffleChoices(questionsIn: chosenStoryObject.questionsObjs)
        
        let plugInQuestions: [FillInBlankQuestion] = chosenStoryObject.fillInBlankQuestions

        let shortStoryObj = shortStoryObject(storyString: storyString, storyStringEnglish: storyStringEnglish, wordLinksArray: wordLinks, questionList: questions, choicesList: choicesList, plugInQuestionlist: plugInQuestions)
        
        return shortStoryObj
        
    }
    
    func shuffleChoices(questionsIn: [QuestionsObj])->[[String]]{
        var tempArray = [[String]]()
        for i in 0...questionsIn.count-1{
            tempArray.append(questionsIn[i].choices.shuffled())
        }
        
        return tempArray
    }
    
    
    
    
    
    
    
}
