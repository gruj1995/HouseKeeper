//
//  CityViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/28.
//

import UIKit

protocol CityViewControllerDelegate : AnyObject{
    func cellOnclick(value: String)
}

class CityViewController: UIViewController {


    
    @IBOutlet weak var tableView: UITableView!
    
    weak var cityVeiwControllerDelegate: CityViewControllerDelegate?
    
    
    var cities = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //設定tableview每一列的高度
        tableView.rowHeight = 30
       
        tableView.estimatedRowHeight=0
        tableView.separatorColor = .clear
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

      
        
        //點擊cell後避免一直選取
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    

 

}

extension CityViewController: UITableViewDelegate,UITableViewDataSource{
    // 一個 section 中的總列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let houseModel = viewModel.noteArray[indexPath.row]
        
        //將UI那的 cell id 與這邊綁定，dequeueReusableCell 方法用來取得佇列中可重複使用的cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
        cell.cityNameLB.text = cities [indexPath.row]  
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityVeiwControllerDelegate?.cellOnclick(value:  cities [indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}
