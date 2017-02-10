//
//  Colleges.swift
//  CollegeProfileBuilder1
//
//  Created by jliu on 2/6/17.
//  Copyright © 2017 Jason Liu. All rights reserved.
//

import UIKit
import RealmSwift

class Colleges: Object {
    
    dynamic var name = String()
    dynamic var location = String()
    dynamic var numberOfStudents = Int()
    dynamic var image = Data()
    
    convenience init(name: String, location: String, numberOfStudents: Int, image: Data) {
        self.init()
        self.name = name
        self.location = location
        self.numberOfStudents = numberOfStudents
        self.image = image
    }
}

