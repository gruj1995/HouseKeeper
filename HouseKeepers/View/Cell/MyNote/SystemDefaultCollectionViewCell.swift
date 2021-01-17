//
//  SystemDefaultCollectionViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/3.
//

import UIKit

protocol SystemDefaultCollectionViewCellDelegate : AnyObject{
    func buttonOnClick()
}

class SystemDefaultCollectionViewCell: UICollectionViewCell {
 

 
    @IBOutlet weak var textLabel: MiddleLabel!
    
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                self.contentView.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.6823529412, blue: 0.3764705882, alpha: 1)
                self.textLabel.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
                self.layer.cornerRadius = 10
                self.clipsToBounds = true
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                textLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                textLabel.font = UIFont.systemFont(ofSize: 12)
            }else  {
                self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.textLabel.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
                self.layer.cornerRadius = 10
                self.clipsToBounds = true
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                textLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                textLabel.font = UIFont.systemFont(ofSize: 12)
            }
        }
    }
    
    
    weak var systemDefaultCollectionViewCellDelegate:SystemDefaultCollectionViewCellDelegate?

    
    override func awakeFromNib() {
       super.awakeFromNib()
        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.textLabel.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        textLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textLabel.font = UIFont.systemFont(ofSize: 12)
   }
    
      
 }
