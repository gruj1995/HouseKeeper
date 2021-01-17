//
//  MyNotePhotoCollectionViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/25.
//

import UIKit

class MyNotePhotoCollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet weak var photoImg: UIImageView!
    
    
    func configureWithImg(with img: UIImage){
        self.photoImg.image = img
    }
    
}
