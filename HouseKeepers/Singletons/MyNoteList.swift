//
//  MyNoteList.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/7.
//

import Foundation

class MyNoteList{

    private static var myNoteList: MyNoteList?

    private var notes = [NoteModel]()

    private init(){
        notes = [NoteModel]()
    }

    static func instance() -> MyNoteList{
        if myNoteList == nil {
            myNoteList = MyNoteList()
        }
        return myNoteList!
    }

    func add(note: NoteModel){
        notes.append(note)
    }

    func clear(){
        notes.removeAll()
    }
    func getNotes() -> [NoteModel]?{
        return notes
    }
    
    func remove(index : Int){
        notes.remove(at: index)
    }

}
