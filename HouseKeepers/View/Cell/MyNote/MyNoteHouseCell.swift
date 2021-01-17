//
//  MyNoteHouseCell.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/13.
//

import UIKit

class MyNoteHouseCell: UITableViewCell {
    
    @IBOutlet weak var houseNameLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var pingLB: UILabel!
    @IBOutlet weak var patternLB: UILabel!
    
    @IBOutlet weak var bolderView: UIView!
    
    @IBOutlet weak var rightStackView: UIStackView!
    
//    func setup(house: HouseModel){
//
//        self.houseNameLB.text = house.name
//        self.pingLB.text = String(house.ping)
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rightStackView.layer.cornerRadius = 10
        rightStackView.clipsToBounds = true
        bolderView.layer.cornerRadius = 10
        bolderView.clipsToBounds = true


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
//            frame.origin.y += 20//調整y起點
            frame.origin.x = 20//調整x起點
            frame.size.height -= 0.6 * frame.origin.x//調整高度
            frame.size.width -= 2 * frame.origin.x

            super.frame = frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //設定cell下緣
        let bottomSpace = 5.0 //陰影高度
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top:0, left: 0, bottom: CGFloat(bottomSpace), right: 0))
        
        self.backgroundColor = .clear // very important
        self.contentView.layer.cornerRadius = 15
        layer.cornerRadius = 20
        layer.masksToBounds = false//超過框線的地方會被裁掉
        //設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20)
        layer.shadowColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 1);
        layer.shadowOpacity = 3
        layer.shadowPath = shadowPath.cgPath
        //        設定外框線
        //                    layer.borderWidth = 1.0
        //                    layer.borderColor = UIColor.black.cgColor
    }
    

    
}
