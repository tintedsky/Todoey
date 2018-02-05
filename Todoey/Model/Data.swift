//
//  Data.swift
//  Todoey
//
//  Created by Hongbo Niu on 2018-02-04.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var age:Int = 0
}
