//
//  CellModel.swift
//  Todo Notes
//
//  Created by Arslan Khalid on 26/09/2019.
//  Copyright © 2019 Arslan Khalid. All rights reserved.
//

import Foundation

class CellModel : Encodable, Decodable {
    
    var todoMessage : String = ""
    var isChecked : Bool = false
}
