//
//  FilterCollectionViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/12.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var yearLB: MiddleLabel!
    @IBOutlet weak var priceLB: MiddleLabel!
    @IBOutlet weak var typeLB: MiddleLabel!
    @IBOutlet weak var badLB: MiddleLabel!
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                self.contentView.backgroundColor = #colorLiteral(red: 0.9404650927, green: 0.9530046582, blue: 0.7407100797, alpha: 1)
                self.yearLB.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
                self.layer.cornerRadius = 15
                self.clipsToBounds = true
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                yearLB.textColor = #colorLiteral(red: 0.4122018218, green: 0.7858070731, blue: 0.6550312638, alpha: 1)
                yearLB.font = UIFont.systemFont(ofSize: 12)
            }else  {
                self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.yearLB.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
                self.layer.cornerRadius = 15
                self.clipsToBounds = true
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                yearLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                yearLB.font = UIFont.systemFont(ofSize: 12)
            }
        }
    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
//        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        self.yearLB.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//        self.layer.borderWidth = 1
//        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        yearLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        yearLB.font = UIFont.systemFont(ofSize: 12)
   }
   
      
 }
