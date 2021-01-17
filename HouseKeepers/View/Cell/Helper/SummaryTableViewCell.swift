//
//  SummaryTableViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/12.
//

import UIKit

protocol  SummaryTableViewCellDelegate {
    func buttonTapped(cell:SummaryTableViewCell)
}


class SummaryTableViewCell: UITableViewCell {

    var  summaryTableViewCellDelegate :  SummaryTableViewCellDelegate?
    
    var articleId = ""
    
    @IBOutlet weak var articleTitleLB: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var dateLB: UILabel!
    
    @IBAction func readBtnOnclick(_ sender: UIButton) {
        summaryTableViewCellDelegate?.buttonTapped(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.textContainer.maximumNumberOfLines = 3
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.isEditable = false
        textView.isSelectable = false
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
            frame.origin.x = 15//調整x起點
            frame.size.height -= 1.7 * frame.origin.x//調整高度
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

