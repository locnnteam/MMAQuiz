//
//  Person.swift
//  CoreDataRecords
//
//  Created by sunarc on 08/11/16.
//  Copyright © 2016 sunarc. All rights reserved.
//

import UIKit
import CoreData

class Word: NSManagedObject {
    @NSManaged var born: String?
    @NSManaged var birthday: String?
    @NSManaged var image: String?
    @NSManaged var levelName: String
    @NSManaged var name: String
    @NSManaged var nickname: String
}
