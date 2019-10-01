//
//  CellModel.swift
//  Todo Notes
//
//  Created by Arslan Khalid on 30/09/2019.
//  Copyright © 2019 Arslan Khalid. All rights reserved.
//

import Foundation
import RealmSwift

class CellModel: Object {
    @objc dynamic var itemName : String = ""
    @objc dynamic var dateCreated : String = ""
    @objc dynamic var isPressed : Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
