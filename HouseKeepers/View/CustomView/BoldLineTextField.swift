//
//  BoldLineTextField.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/15.
//

import UIKit




class BoldLineTextField: UITextField ,UITextFieldDelegate{
    
    let boldLineTextField = CALayer();
    
    //框的顏色
     open var borderColor : UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) {
           didSet{
            layer.borderColor = borderColor.cgColor
           }
       }
    
    //框的粗細
     public var borderWidth: CGFloat = 1.0 {
           didSet{
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
           }
       }
    
    //框的圓角
     public var cornerRadius: CGFloat = 10.0 {
           didSet{
            layer.cornerRadius = cornerRadius
           }
       }

    
     required init?(coder aDecoder: (NSCoder?)) {
        super.init(coder: aDecoder!)
        self.delegate=self;
        boldLineTextField.borderColor = borderColor.cgColor
        
       //設定提示字的顏色
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "請輸入文章關鍵字",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])


        boldLineTextField.frame = CGRect(x: 0, y: 0 , width:  self.frame.size.width, height: self.frame.size.height)
        boldLineTextField.borderWidth = borderWidth
        boldLineTextField.cornerRadius = cornerRadius
        
        self.layer.addSublayer(boldLineTextField)
        self.layer.masksToBounds = true
    }


//        override init(frame: CGRect){    //IBDesignable 需要實現兩個建構子，或者兩個都不實現
//            super.init(frame: frame)
//        }

//       override func draw(_ rect: CGRect) { //要實現的新的建構子
//        boldLineTextField.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:  self.frame.size.width, height: self.frame.size.height)
//       }
//
//       override func awakeFromNib() {
//           super.awakeFromNib()
//          boldLineTextField.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:  self.frame.size.width, height: self.frame.size.height)
//           self.delegate = self
//       }

       //選中時框改變顏色
       func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        border.borderColor = #colorLiteral(red: 0.3729024529, green: 0.9108788371, blue: 0.7913612723, alpha: 1)
        boldLineTextField.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return true
       }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        boldLineTextField.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return true
    }
    
 

   
}
