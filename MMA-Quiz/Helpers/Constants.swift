//
//  Config.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/30/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

enum FireBaseURL{
    static let jsonHomeDataURL = "https://firebasestorage.googleapis.com/v0/b/vocabularygame-b034c.appspot.com/o/MMA_Quiz%2FMMA_Data.json?alt=media&token=7dba7768-9571-41b9-bf30-a2ff5d23aa41"
    
    static let jsonAdsIDURL = "https://firebasestorage.googleapis.com/v0/b/vocabularygame-b034c.appspot.com/o/Words%2FGGAdsID.json?alt=media&token=e5cdb797-64fd-4cc2-918b-55c51d6e6f7f"
}

let Leaderboad_Id = "MMAQuiz_ID"
let ScoreData = "score"
var score = 0
let DocumentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

let WidthBorderLessonCell = CGFloat(5.0)


enum Sound {
    static let passSounds = Bundle.main.path(forResource: "pass", ofType: ".mp3")
    static let failSounds = Bundle.main.path(forResource: "false", ofType: ".mp3")
}

enum BackgroundColor {
    static let LoadingLaunchBkg = UIColor.white //UIColor(red: 0, green: 175/255, blue: 240/255, alpha: 1)
    static let NavigationBackgound = UIColor(red: 252/255, green: 176/255, blue: 64/255, alpha: 1)
    static let HomeBackground = UIColor.gray //UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    static let LessonBackground = UIColor.gray //UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    static let BorderGrayColor = UIColor.white //UIColor(red: 211/255, green: 218/255, blue: 224/255, alpha: 1)
    static let LessonLabelBackground = UIColor(red: 132/255, green: 59/255, blue: 41/255, alpha: 1)
    static let FlashCardBackground = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
    static let AnimStarHintBackground = UIColor(red: 1/255, green: 143/255, blue: 229/255, alpha: 0.8)
    static let AnimStarNormal = UIColor(red: 1/255, green: 143/255, blue: 229/255, alpha: 1.0)
}

class FontSizeCustom {
    static func getFontSize() -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            return 28.0
        case .phone:
            return 18.0
        default:
            return 18.0
        }
    }
    
    static func getLabelFontSize() -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            return 24.0
        case .phone:
            return 18.0
        default:
            return 24.0
        }
    }
    
    static func getActivityIndicator() -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            return 100.0
        case .phone:
            return 60.0
        default:
            return 60.0
        }
    }

    static func getHeightOfBanner() -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            return 90.0
        case .phone:
            return 50.0
        default:
            return 50.0
        }
    }
    
    static func getStarSize() -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            return 60.0
        case .phone:
            return 30.0
        default:
            return 30.0
        }
    }
}
