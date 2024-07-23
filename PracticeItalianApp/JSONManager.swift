//
//  JSONManager.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 4/26/23.
//

import Foundation

struct verbObject: Codable{
    var verb: Verb
    var presenteConjList, passatoProssimoConjList, futuroConjList, imperfettoConjList: [String]
    var presenteCondizionaleConjList, imperativoConjList: [String]
    
    static let allVerbObject: [verbObject] = Bundle.main.decode(file: "ItalianAppVerbData.json")
    
}
    

struct Verb: Codable {
    var verbName, verbEngl: String
}


struct storyObject: Codable {
    let storyName, story, storyEnglish: String
    let wordLinks: [WordLink]
    let questionsObjs: [QuestionsObj]
    let fillInBlankQuestions: [FillInBlankQuestion]
    var dragAndDropQuestions: [DragAndDropQuestion]
    
    static let allStoryObjects: [storyObject] = Bundle.main.decode(file: "shortStoriesData.json")
    static let introduzione: storyObject = allStoryObjects[0]
    static let amico: storyObject = allStoryObjects[1]
    static let famiglia: storyObject = allStoryObjects[2]
    static let vacanza: storyObject = allStoryObjects[3]
    static let routine: storyObject = allStoryObjects[4]
    static let ragu: storyObject = allStoryObjects[5]
    static let weekend: storyObject = allStoryObjects[6]
    static let animale: storyObject = allStoryObjects[7]
    static let sport: storyObject = allStoryObjects[8]
    static let sogno: storyObject = allStoryObjects[9]
    static let compleanno: storyObject = allStoryObjects[10]
}

// MARK: - DragAndDropQuestion
struct DragAndDropQuestion: Codable {
    var englishSentence: String
    var choices: [String]
}


struct QuestionsObj: Codable {
    var question: String
    var choices: [String]
    var answer: String
    var mC: Bool?
}

// MARK: - FillInBlankQuestion
struct FillInBlankQuestion: Codable {
    let englishLine1, question: String
    let missingWords: [String]
    let plugInChoices: [PlugInChoice]
}

// MARK: - PlugInChoice
struct PlugInChoice: Codable {
    let choice: String
    let isCorrect: Bool
}



struct WordLink: Codable {
    var wordNameIt, infinitive, wordNameEng, explanation: String
}


struct flashCardObject: Codable {
    var flashSetName: String
    var words: [Word]
    
    static let allFlashCardObjects: [flashCardObject] = Bundle.main.decode(file: "flashCardData.json")
    
    static let Food: flashCardObject = flashCardObject.allFlashCardObjects[0]
    static let Animals: flashCardObject = flashCardObject.allFlashCardObjects[1]
    static let Clothing: flashCardObject = flashCardObject.allFlashCardObjects[2]
    static let Family: flashCardObject = flashCardObject.allFlashCardObjects[3]
    static let CommonNouns: flashCardObject = flashCardObject.allFlashCardObjects[4]
    static let CommonAdjectives: flashCardObject = flashCardObject.allFlashCardObjects[5]
    static let CommonAdverbs: flashCardObject = flashCardObject.allFlashCardObjects[6]
    static let CommonVerbs: flashCardObject = flashCardObject.allFlashCardObjects[7]
    static let CommonPhrases: flashCardObject = flashCardObject.allFlashCardObjects[8]
    static let words1000: flashCardObject = flashCardObject.allFlashCardObjects[9]
    
    
}


struct Word: Codable {
    var wordItal: String
    var gender: String
    var wordEng: String
}

//enum Gender: String, Codable {
//    case empty = ""
//    case fem = "fem."
//    case genderMascFem = "masc.fem."
//    case masc = "masc."
//    case mascAndFem = "masc. and fem."
//    case mascFem = "masc./fem."
//}



struct ListeningActivityElement: Codable {
    var audioName: String
      var isConversation: Bool
      var numberOfDialogueQuestions: Int
      var speaker1Image, speaker2Image, audioTranscriptItalian, audioTranscriptEnglish: String
      var audioCutArrays: [String]
      var comprehensionQuestions: [ComprehensionQuestion]
      var fillInDialogueQuestion: [FillInDialogueQuestion]
      var blankExplanation: [BlankExplanation]
      var putInOrderDialogueBoxes: [PutInOrderDialogueBox]
      var keywords: [Keyword]
    
    static let allListeningActivityElements: [ListeningActivityElement] = Bundle.main.decode(file: "ListeningActivity.json")
    
    static let pastaCarbonara: ListeningActivityElement = allListeningActivityElements[0]
    static let cosaDesidera: ListeningActivityElement = allListeningActivityElements[1]
    static let uffizi: ListeningActivityElement = allListeningActivityElements[2]
    static let bellagio: ListeningActivityElement = allListeningActivityElements[3]
    static let rinascimento: ListeningActivityElement = allListeningActivityElements[4]
    static let colloquio: ListeningActivityElement = allListeningActivityElements[5]
    static let appartamento: ListeningActivityElement = allListeningActivityElements[6]
    static let sanremo: ListeningActivityElement = allListeningActivityElements[7]
}


// MARK: - BlankExplanation
struct BlankExplanation: Codable {
    var wordItalian, wordEnglish: String
    var choices: [String]
}

// MARK: - ComprehensionQuestion
struct ComprehensionQuestion: Codable {
    var question, answer: String
    var choices: [String]
}

// MARK: - FillInDialogueQuestion
struct FillInDialogueQuestion: Codable {
    var fullSentence: String
    var speakerNumber: Int
    var questionPart1, answer, questionPart2: String
    var answerArray: [AnswerArray]
    var isQuestion, correctChosen: Bool
}

// MARK: - AnswerArray
struct AnswerArray: Codable {
    var letter: String
    var showLetter: Bool
    var answer: String?
}

// MARK: - Keyword
struct Keyword: Codable {
    let wordItalian, wordEnglish: String
}

// MARK: - PutInOrderDialogueBox
struct PutInOrderDialogueBox: Codable {
    var fullSentences: [FullSentence]
}

// MARK: - FullSentence
struct FullSentence: Codable {
    var audioFile: String
    var position: Int
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project!")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project!")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Culd not decode \(file) in the project!")
        }
        
        return loadedData
    }
}
