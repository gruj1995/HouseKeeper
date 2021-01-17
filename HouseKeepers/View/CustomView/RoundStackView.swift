//
//  RoundStackView.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/4.
//
import UIKit

public class RoundStackView : UIStackView{

    required init(coder aDecoder: (NSCoder?)) {
       super.init(coder: aDecoder!)
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
      
    }
    
}

