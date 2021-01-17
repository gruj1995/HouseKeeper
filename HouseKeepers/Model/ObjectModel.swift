//
//  ObjectModel.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/13.
//

import Foundation


class ObjectModel{
    
    var objectId : String = ""
    var object:String = ""
    var objectImgPath:String = ""
    var objectCount : String = ""
    var article : [ArticleModel] = []
    
    
    init(){
        
    }
    
   init(objectId : String){
        self.objectId = objectId
    }
    
}
