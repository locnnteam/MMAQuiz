//
//  LessonModel.swift
//  VocabularyGame
//
//  Created by Nguyen Nhat  Loc on 9/4/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class LessonModel: NSObject {

    static func loadLessonData(lessonURL: String, completion:@escaping (_ levelItems: [Level]) -> Void){
        var levelItems: [Level] = []
        
        Alamofire.request(lessonURL).responseJSON { response in
            if (response.error == nil) {
                
                if let data = response.data{
                    let json = try? JSON(data: data)
                    //init lesson
                    for index in 0...((json?.count)! - 1){
                        guard let lessons = json![index]["lessons"].array else{
                            debugPrint("Lesson is nil")
                            break
                        }

                        guard let randomNumber = json![index]["levelNumberRandom"].int else{
                            debugPrint("levelNumberRandom is nil")
                            continue
                        }
                        
                        guard let id = json![index]["levelID"].string else{
                            debugPrint("levelID is nil")
                            continue
                        }
                        
                        guard let priority = json![index]["levelPriority"].string else{
                            debugPrint("levelPriority is nil")
                            continue
                        }
                        
                        guard let levelName = json![index]["levelName"].string else{
                            debugPrint("levelName is nil")
                            continue
                        }
                        
                        guard let thumnail = json![index]["levelThumnailURL"].string else{
                            debugPrint("levelThumnailURL is nil")
                            continue
                        }
                        
                        guard let time = json![index]["levelTime"].double else{
                            debugPrint("levelTime is nil")
                            continue
                        }
                        
                        var lessonList: [LessonItem?] = []
                        
                        for iLesson in 0...(lessons.count - 1){
                            let id = lessons[iLesson]["id"].string
                            let name = lessons[iLesson]["name"].string!
                            let nickname = lessons[iLesson]["nickName"].string!
                            let image = lessons[iLesson]["imageURL"].string
                            let birthday = lessons[iLesson]["birthday"].string
                            let born = lessons[iLesson]["born"].string
                            
                            let lessonItem = LessonItem(levelName: levelName, id: id, name: name, nickname: nickname, birthday: birthday, born: born, image: image)
                            if lessonItem != nil {
                                 lessonList.append(lessonItem)
                            }
                        }
                        
                        let level = Level(isOpenned: false, name: levelName, id: id, priority: priority, time: time, randomNum: randomNumber, thumnail: thumnail, listVocabulary: lessonList as! Array<LessonItem>)
                        
                        levelItems.append(level!)
                    }
                    
                    
                }
            }
            completion(levelItems)
        }
    }
}
