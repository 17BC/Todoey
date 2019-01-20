//
//  Category.swift
//  Todoey
//
//  Created by Jasmin Laxamana on 1/15/19.
//  Copyright © 2019 17 B.C. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    
    // creates forward relationship with Item
    let items = List<Item>()
}
