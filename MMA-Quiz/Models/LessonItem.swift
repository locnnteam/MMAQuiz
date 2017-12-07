//
//  LessonItem.swift
//  Vocabulary
//
//  Created by Nguyen Nhat  Loc on 6/17/17.
//  Copyright © 2017 bktech. All rights reserved.
//

import Foundation
import UIKit

class LessonItem {
    
    //MARK: Properties
    
    var levelName: String
    var id: String?
    var name: String
    var nickname: String
    var birthday: String?
    var born: String?
    var image: String?
    
    var isSelected: Bool?
    
    //MARK: Initialization
    
    init?(levelName: String, id: String?, name: String?, nickname: String?, birthday: String?, born: String?, image: String?) {
        
        guard let name = name else {
            return nil
        }
        

        
        guard let image = image else {
            return nil
        }
        
        // Initialize stored properties.
        self.levelName = levelName
        self.id = id
        self.name = name
        self.nickname = nickname ?? "N/A"
        self.image = image
        self.birthday = birthday
        self.born = born
    }
}
