//
//  Utilities.swift
//  unBurdenSwift
//
//  Created by catie on 5/3/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import Foundation
import UIKit

class Utilities{
    
    //Checks Password Format
    static func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "Self Matches %@",
        "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //Checks username Format
    static func isUsernameValid(_ username: String) -> Bool{
        let usernameTest = NSPredicate(format: "Self Matches %@",
        "^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$")
        return usernameTest.evaluate(with: username)
    }
    static func loadSuggestData() -> Array<Suggestion> {
        var suggList : [Suggestion] = []
        
       if let path = Bundle.main.path(forResource: "suggestions", ofType: "plist") {
           let tempDict = NSDictionary(contentsOfFile: path)
           let tempArray = (tempDict!.value(forKey: "static_options") as! NSArray) as Array
             
           for dict in tempArray {
               
               let name = dict["category"]! as! String
               let image = dict["image"]! as! String
               let suggestions = dict["suggestions"]! as! Array<String>
               
               let sugg = Suggestion(category: name, image: image, suggestions: suggestions)
                 
               suggList.append(sugg)
    
           }
       }
        return suggList
    }
}
