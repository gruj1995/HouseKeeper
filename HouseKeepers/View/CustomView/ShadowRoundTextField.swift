//
//  ShadowRoundTextField.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/30.
//

import UIKit

class ShadowRoundTextField: UITextField,UITextFieldDelegate{ 
    required init?(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)
        
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        layer.cornerRadius = 10
//        layer.masksToBounds = true//超過框線的地方會被裁掉
        //設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 2);
        layer.shadowOpacity = 2
        
    }
    
}
