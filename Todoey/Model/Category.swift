//
//  Category.swift
//  Todoey
//
//  Created by Hongbo Niu on 2018-02-04.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name:String = ""
    let items = List<Item>()
}
