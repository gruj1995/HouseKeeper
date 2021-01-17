//
//  PhotoCollectionViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/16.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    

    
    @IBOutlet weak var photoImg: UIImageView!
    
//    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
//    static let width = floor((UIScreen.main.bounds.width - 3 * 2) / 3)
    

    
     override func awakeFromNib() {
        super.awakeFromNib()
//        widthConstraint.constant = Self.width
    }
    
    func configureWithImg(with img: UIImage){
        self.photoImg.image = img
    }
    

}
