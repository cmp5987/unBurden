//
//  Suggestion.swift
//  unBurdenSwift
//
//  Created by catie on 5/5/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import Foundation

class Suggestion: NSObject{
    private var objCategory: String = ""
    private var objImage: String = ""
    private var objSuggestions: [String] = []

    convenience override init () {
        self.init(category: "Undefined", image:"Not Specified", suggestions:[])
    }
    init(category:String, image:String, suggestions:Array<String>) {
        super.init()
        set(category:category)
        set(image:image)
        set(suggestions:suggestions)
    }
    
    func set(category: String){
        objCategory = category
    }
    func set(image: String){
        objImage = image
    }
    func set(suggestions: Array<String>){
        objSuggestions = suggestions
    }
    func getCategory() -> String{
        return objCategory
    }
    func getImage() -> String{
        return objImage
    }
    func getSuggestions() -> Array<String>{
        return objSuggestions
    }
}
