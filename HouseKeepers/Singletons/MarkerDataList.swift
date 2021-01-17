//
//  MarkerDataList.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/22.
//

import Foundation


class MarkerDataList{
    
    private static var markerDataList: MarkerDataList?
    
     private var markerDatas: [MarkerData]
    
    private init(){
        markerDatas = [MarkerData]()
    }
    
    static func instance() -> MarkerDataList{
        if markerDataList == nil {
            markerDataList = MarkerDataList()
        }
        return markerDataList!
    }
    
    func add(markerData: MarkerData){
        markerDatas.append(markerData)
    }
    

    func clear(){
        markerDatas.removeAll()
    }
    
    func getMarkerDatas() -> [MarkerData]{
        return markerDatas
    }
    
}

class SingletonClass{
    
    static let sharedInstance = SingletonClass()
    
    private init(){
        
    }
}
