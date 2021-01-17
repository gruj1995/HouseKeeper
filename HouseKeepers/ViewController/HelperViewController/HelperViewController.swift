//
//  HelperViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/11.
//

import UIKit


protocol HelperViewControllerDelegate : AnyObject{
    func sendObject(object: String)
}

class HelperViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var helperViewControllerDelegate : HelperViewControllerDelegate?
    
    var objects : [String] = ["屋況大健檢","法規放大鏡","話術大揭密"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = #colorLiteral(red: 0.9730113149, green: 0.9526819587, blue: 0.8720123172, alpha: 1)
    }
    
 
}
extension HelperViewController: UITableViewDataSource ,UITableViewDelegate{

    // 一個 tabelView 中有幾個 section（table view可以有多個區塊，但預設是一個）
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 一個 section 中的總列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HelperFirstTableViewCell", for: indexPath) as! HelperFirstTableViewCell
        
        cell.backgroundColor = .clear
        cell.contentView.layer.cornerRadius = 15
        cell.titleLB.text = objects[indexPath.row]
        
        
        switch indexPath.row{
        case 0:
            cell.img.image = UIImage(named: "helper_homePage_1")
            cell.littleLB.text = "3大主題"
        case 1:
            cell.img.image = UIImage(named: "helper_homePage_2")
            cell.littleLB.text = "2大主題"
        case 2:
            cell.img.image = UIImage(named: "helper_homePage_3")
            cell.littleLB.text = "2大主題"
        default:
            break
        }
        return cell
    }
    
    //點擊後跳轉，並避免一直選取
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popoverController =
            storyboard.instantiateViewController(withIdentifier: "HouseHomeViewController") as? HouseHomeViewController{
            self.helperViewControllerDelegate = popoverController
            helperViewControllerDelegate?.sendObject(object: objects[indexPath.row])
            presentBottom(popoverController)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
