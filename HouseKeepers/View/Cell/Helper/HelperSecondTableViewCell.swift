//
//  HelperSecondTableViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/11.
//

import UIKit

class HelperSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLB: UILabel!
    @IBOutlet weak var littleLB: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }

    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
//            frame.origin.y += 20//調整y起點
            frame.origin.x = 10//調整x起點
            frame.size.height -= 2 * frame.origin.x//調整高度
            frame.size.width -= 2 * frame.origin.x

            super.frame = frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 20
        layer.masksToBounds = false//超過框線的地方會被裁掉

    }
}
