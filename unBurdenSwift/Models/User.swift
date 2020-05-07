//
//  User.swift
//  unBurdenSwift
//
//  Created by catie on 5/5/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable{
    var email: String
    var trips: Array<String>
    var uid: String
}

