//
//  Item.swift
//  Todoey
//
//  Created by Jasmin Laxamana on 1/15/19.
//  Copyright © 2019 17 B.C. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated = Date()
    
    // creates inverse relationship to Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
