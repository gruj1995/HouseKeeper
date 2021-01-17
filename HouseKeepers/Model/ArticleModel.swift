//
//  ArticleModel.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/13.
//
import UIKit

class ArticleModel{
    
    
    var articleId: String = ""
    var title:String = ""
    var object:String = ""
    var type:String = ""
    var imagePath:String = ""
    var dateTime:String = ""
    var articleCount : String = ""
    var inofrmation : String = ""
    var articleTitle : String = ""
    
    
    init(){
        
    }
    
    init(articleId: String,title:String,object:String,type:String ,imagePath:String,dateTime:String,articleCount: String ){
        self.articleId = articleId
        self.title = title
        self.object = object
        self.type = type
        self.imagePath = imagePath
        self.dateTime = dateTime
        self.articleCount = articleCount
    }
    
}
