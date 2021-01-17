//
//  TruePriceTableViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/30.
//

import UIKit

class TruePriceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLB: UILabel!
    @IBOutlet weak var howLongLB: UILabel!
    @IBOutlet weak var floorLB: UILabel!
    @IBOutlet weak var pingLB: UILabel!
    @IBOutlet weak var patternLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var averagePriceLB: UILabel!
    
    let screenSize  = UIScreen.main.bounds.size
    
    static var truePriceCurrentAddress:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
         
            frame.origin.x =  screenSize.width*0.037//調整x起點
            frame.size.height -= 10//調整高度
            frame.size.width -= 2 * frame.origin.x

            super.frame = frame
        }
    }
}
