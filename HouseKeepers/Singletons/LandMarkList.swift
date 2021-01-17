//
//  LandMarkList.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/2.
//

import Foundation


class LandMarkList{
    
    private static var landMarkList: LandMarkList?
    
    private var landMarks: [LandMarkModel]
    
    private init(){
        landMarks = [LandMarkModel]()
    }
    
    static func instance() -> LandMarkList{
        if landMarkList == nil {
            landMarkList = LandMarkList()
        }
        return landMarkList!
    }
    
    func add(landMark: LandMarkModel){
        landMarks.append(landMark)
    }
    
    
    func clear(){
        landMarks.removeAll()
    }
    
    func getLandMarks() -> [LandMarkModel]{
        return landMarks
    }
    
}
