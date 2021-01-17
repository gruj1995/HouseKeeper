//
//  NoteModel.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/18.
//


import UIKit

class NoteModel{
    
    var noteId : String = ""
    var house:HouseModel!
    var advantage:String = ""
    var disadvantage:String = ""
    var contactPhone:String = ""
    var contactName:String = ""
    var desc:String?
    var noteImgs:[UIImage]?
    var imagePath : [String] = []
    
    
    
    init(){
        
    }
    
   init(noteId:String, house:HouseModel, advantage:String, disadvantage:String, contactPhone:String, contactName:String, desc:String, noteImgs:[UIImage]?){
        self.noteId = noteId
        self.house = house
        self.advantage = advantage
        self.disadvantage = disadvantage
        self.contactName = contactName
        self.contactPhone = contactPhone
        self.desc = desc
        self.noteImgs = noteImgs
    }
    
}
