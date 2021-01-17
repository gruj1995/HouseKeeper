//
//  littleView.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/28.
//

import UIKit

class littleView: UIView {
    
    required init?(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)
        
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        self.layer.cornerRadius = 10
//         self.layer.masksToBounds = true
//        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.layer.shadowRadius = 10
//        self.layer.shadowOpacity = 0.23
//        self.layer.shadowOffset = CGSize(width:3 , height: 2)
        let bottomSpace = 5.0 //陰影高度
        self.frame = self.frame.inset(by: UIEdgeInsets(top:0, left: 0, bottom: CGFloat(bottomSpace), right: 0))


        layer.cornerRadius = 10
        layer.masksToBounds = true//超過框線的地方會被裁掉
        //設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 2);
        layer.shadowOpacity = 2

    }
    


 }


