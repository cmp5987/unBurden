//
//  TripNSObject.swift
//  unBurdenSwift
//
//  Created by catie on 5/5/20.
//  Copyright © 2020 cmp5987. All rights reserved.
//

import Foundation

class TripNSObject : NSObject{

    private var tripName: String = ""
    private var tripLocation: String = ""
    private var tripStartDate: Date?
    private var tripEndDate: Date?
    private var tripDesc: String = ""
    private var tripId: String = ""
    private var tripToPack = [String]()
    private var tripPacked = [String]()
    private var tripUsers = [String]()
    /*
    convenience override init () {
        self.init(name: "Undefined", location:"Not Specified", startDate:Date(), endDate:Date(), desc:"No Description Added", id:"Undefined",users:[])
    }

    
    init(name:String, location:String, startDate:Date, endDate: Date, desc:String, id:String, users:Array<String>) {
        super.init()
        set(name:name)
        set(location:location)
        set(startDate:startDate)
        set(endDate:endDate)
        set(desc:desc)
        set(id:id)
        set(users:users)
        //set(toPack:toPack)
        //set(packed:packed)
    }
    */
    convenience override init () {
        self.init(name: "Undefined", location:"Not Specified", startDate:Date(), endDate:Date(), desc:"No Description Added", id:"Undefined",users:[], toPack:[], packed:[])
    }
    
    init(name:String, location:String, startDate:Date, endDate: Date, desc:String, id:String, users:Array<String>, toPack:Array<String>, packed: Array<String>) {
        super.init()
        set(name:name)
        set(location:location)
        set(startDate:startDate)
        set(endDate:endDate)
        set(desc:desc)
        set(id:id)
        set(users:users)
        set(toPack:toPack)
        set(packed:packed)
    }

    func addUser(user: String){
        tripUsers.append(user)
    }
    func set(name: String){
        tripName = name
    }
    func set(location: String){
        tripLocation = location
    }
    func set(startDate: Date){
        tripStartDate = startDate
    }
    func set(endDate: Date){
        tripEndDate = endDate
    }
    func set(desc: String){
        tripDesc = desc
    }
    func set(id: String){
        tripId = id
    }
    func set(users: Array<String>){
        tripUsers = users
    }
    
    func set(toPack: Array<String>){
        tripToPack = toPack
    }
    func set(packed: Array<String>){
        tripPacked = packed
    }
     
    func getName() -> String{
        return tripName
    }
    func getLocation() ->  String{
        return tripLocation
    }
    func getStartDate() -> Date{
        return tripStartDate!
    }
    func getEndDate() -> Date{
        return tripEndDate!
    }
    func getDesc() -> String{
        return tripDesc
    }
    func getId() -> String{
        return tripId
    }
    func getUsers() -> Array<String>{
        return tripUsers
    }
    
    func getToPack() -> Array<String>{
        return tripToPack
    }
    func getPacked() -> Array<String>{
        return tripPacked
    }
     
    override var description: String {
        """
        {
            tripName: \(tripName)
            triplocation: \(tripLocation)
            tripStartDate: \(tripStartDate)
            tripEndDate: \(tripEndDate)
            tripDesc: \(tripDesc)
            users: \(tripUsers)
            /toPack: \(tripToPack)
            packed: \(tripPacked)
        }
        """
    }
}
