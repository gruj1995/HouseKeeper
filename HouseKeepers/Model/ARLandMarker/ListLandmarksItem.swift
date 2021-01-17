//
//  ListAssessmentsItem.swift
//  ARCoreLocationExample
//
//  Created by Skyler Smith on 2019-01-02.
//  Copyright (c) 2019 Freshworks Studio Inc.. All rights reserved.
//

import UIKit

class ListLandmarksItem: UIView {
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var distanceLabel: UILabel!
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var pinEnd: UIView!
    
    @IBOutlet weak var img: UIImageView!
    
    static func fromNib() -> ListLandmarksItem {
        let view = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.first as! ListLandmarksItem
//        let newView = UIView()
//        let mylayer = CALayer()
//        let myImage = UIImage(named: "temple")?.cgImage
    
//        mylayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        mylayer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//        mylayer.contents = myImage
//        mylayer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//        view.layer.addSublayer(mylayer)
        
//        view.frame.size = CGSize(width: 50, height: 50)
//        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//        view.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
  
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pinView.layer.cornerRadius = 12
        pinEnd.layer.cornerRadius = pinEnd.frame.width / 4
    }
    
    func set(name: String, detail: String?) {
        nameLabel.text = ""
        distanceLabel.text = ""
        nameLabel.text = name
        distanceLabel.text = detail
        layoutIfNeeded()
    }
}
