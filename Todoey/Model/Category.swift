//
//  Category.swift
//  Todoey
//
//  Created by gopalakrishna on 06/03/19.
//  Copyright © 2019 gopalakrishna. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    var items = List<Item>()
}
