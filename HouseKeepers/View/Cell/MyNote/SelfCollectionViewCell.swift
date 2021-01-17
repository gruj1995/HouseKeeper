//
//  SelfCollectionViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/9.
//

import UIKit


class SelfCollectionViewCell: UICollectionViewCell {
 

  
    
    @IBOutlet weak var textLabel: MiddleLabel!
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                self.contentView.backgroundColor = #colorLiteral(red: 0, green: 0.6588235294, blue: 0.5882352941, alpha: 1)
                self.textLabel.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
                self.layer.cornerRadius = 10
                self.clipsToBounds = true
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                textLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                textLabel.font = UIFont.systemFont(ofSize: 12)
            }
            else{
                self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.textLabel.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
                self.layer.cornerRadius = 10
                self.clipsToBounds = true
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                textLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                textLabel.font = UIFont.systemFont(ofSize: 12)
              
               
            }
        }
    }
    
    
    override func awakeFromNib() {
       super.awakeFromNib()
        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.textLabel.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        textLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textLabel.font = UIFont.systemFont(ofSize: 12)
   }

    func isLast(islast : Bool){
        if islast {
            self.textLabel.text = "  +  "
            self.textLabel.font = UIFont.systemFont(ofSize: 14)
            self.textLabel.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            self.textLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.contentView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
            self.layer.borderWidth = 1
            self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
      
 }
