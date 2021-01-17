//
//  RoundButton.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/31.
//

import UIKit

class RoundButton : UIButton{
    
    required init?(coder aDecoder: (NSCoder?)) {
       super.init(coder: aDecoder!)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }
    
}



