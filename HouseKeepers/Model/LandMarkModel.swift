//
//  LandMarkModel.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/2.
//

import GoogleMapsUtils
import UIKit


class LandMarkModel{
    
    var name: String //地標名稱
    var type: String // 地標種類
    var address: String //地標地址
    var district: String //地標區域
    var position: CLLocationCoordinate2D // LandMark 的座標


    
    init(name: String, type: String,  address: String, district:String, position: CLLocationCoordinate2D){
        self.name = name
        self.type = type
        self.address = address
        self.district = district
        self.position = position
    }
    
}
