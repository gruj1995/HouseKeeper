//
//  EditPhotoTableViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/6.
//

import UIKit

protocol EditPhotoTableViewCellDelegate {
    func buttonTapped(cell: EditPhotoTableViewCell)
}

class EditPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    var editPhotoTableViewCellDelegate : EditPhotoTableViewCellDelegate?
    
    @IBAction func deleteOnClick(_ sender: UIButton) {
        self.editPhotoTableViewCellDelegate?.buttonTapped(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        
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
            frame.origin.x = 5//調整x起點

            frame.size.height -= 0.7 * frame.origin.x//調整高度
            frame.size.width -= 1 * frame.origin.x

            super.frame = frame
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        //設定cell下緣
        let bottomSpace = 5.0 //陰影高度
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top:0, left: 0, bottom: CGFloat(bottomSpace), right: 0))
        
        
//        layer.cornerRadius = 10
//        layer.masksToBounds = false//超過框線的地方會被裁掉
        
        //設定陰影
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        layer.shadowColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOffset = CGSize(width: 0, height: 5);
        layer.shadowOpacity = 3
        layer.shadowPath = shadowPath.cgPath

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.editPhotoTableViewCellDelegate = nil
    }
    

}
