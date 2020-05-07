//
//  Trip.swift
//  unBurdenSwift
//
//  Created by catie on 5/5/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Trip: Codable{
    var desc: String
    var end: Date
    var id: String
    var location: String
    var name: String
    var start: Date
    var users: Array<String>
}
