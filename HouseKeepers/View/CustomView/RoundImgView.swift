//
//  RoundImgView.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/11.
//

import UIKit


class RoundImgView : UIImageView{
    
    required init?(coder aDecoder: (NSCoder?)) {
       super.init(coder: aDecoder!)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
      
    }
    
}
