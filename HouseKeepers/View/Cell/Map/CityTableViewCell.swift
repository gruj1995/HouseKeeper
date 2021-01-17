//
//  CityTableViewCell.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/28.
//

import UIKit

class CityTableViewCell: UITableViewCell {


    
    @IBOutlet weak var cityNameLB: UILabel!
    
    func setup(city: String){

        self.cityNameLB.text = city

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
