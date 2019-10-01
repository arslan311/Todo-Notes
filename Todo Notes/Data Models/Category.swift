//
//  Categories.swift
//  Todo Notes
//
//  Created by Arslan Khalid on 30/09/2019.
//  Copyright © 2019 Arslan Khalid. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var catName : String = ""
    let items = List<CellModel>()
}
