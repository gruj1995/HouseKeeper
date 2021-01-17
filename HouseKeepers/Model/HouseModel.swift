//
//  House.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/14.
//


import UIKit
import GoogleMapsUtils

class HouseModel {
    
    var name: String
    var pattern:String
    var price: Double
    var ping: Double
    var address:String
    var houseImgs:[UIImage] = []
    var position: CLLocationCoordinate2D
    var transactionTime:String
    var floor:String
    var buildingState:String
    
    
    init(name:String, pattern: String, price: Double , ping: Double ,address:String, position:CLLocationCoordinate2D,transactionTime:String,floor:String,buildingState:String){
        self.name = name
        self.pattern = pattern
        self.price = price
        self.ping = ping
        self.address = address
        self.position = position
        self.transactionTime = transactionTime
        self.floor = floor
        self.buildingState = buildingState
    }

}



