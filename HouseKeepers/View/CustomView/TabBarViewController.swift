//
//  TabBarViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/26.
//

import UIKit

class TabBarViewController: UITabBarController {


    var screenSize = UIScreen.main.bounds.size
    
    @IBOutlet weak var tabBarTest: UITabBar!
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    
    
    override func viewDidLayoutSubviews() {
    
              
        tabBarTest.layer.cornerRadius = 20
        tabBarTest.clipsToBounds = true
        tabBarTest.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        tabBarTest.layer.masksToBounds = true
            
        tabBarTest.barTintColor = #colorLiteral(red: 0.2393432856, green: 0.7645045519, blue: 0.6018427014, alpha: 1)
        tabBarTest.unselectedItemTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
        var tabFrame: CGRect = self.tabBarTest.frame
        tabFrame.size.height = screenSize.height/11
        tabFrame.origin.y = self.view.frame.size.height - screenSize.height/11
        self.tabBarTest.frame = tabFrame
        
      
    }
    
}
