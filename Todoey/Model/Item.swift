//
//  Item.swift
//  Todoey
//
//  Created by Hongbo Niu on 2018-02-04.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title:String = ""
    @objc dynamic var isDone = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
