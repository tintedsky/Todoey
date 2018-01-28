//
//  Item.swift
//  Todoey
//
//  Created by Hongbo Niu on 2018-01-27.
//  Copyright © 2018 Hongbo Niu. All rights reserved.
//

import Foundation

class Item : Codable{
    var title:String = ""
    var isDone = false
    
    init(itemName:String){
        self.title = itemName
    }
}
