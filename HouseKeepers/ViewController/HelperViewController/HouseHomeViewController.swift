//
//  HouseHomeViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/11.
//

import UIKit

protocol HouseHomeViewControllerDelegate : AnyObject{
    func sendType(type: String, articleCount : String , typeImagePath : String)
}


class HouseHomeViewController: PresentBottomVC {

    override var controllerHeight: CGFloat {
        return Global.screenSize.height*13/14
    }
    
    weak var houseHomeViewControllerDelegate : HouseHomeViewControllerDelegate?
    
    @IBOutlet weak var objectLB: UILabel!
    
    @IBOutlet weak var objectCountLB: UILabel!
    
    @IBOutlet weak var houseTableView: UITableView!
 
    @IBOutlet weak var objectImg: UIImageView!
    
    var object = ObjectModel()

    
    @IBAction func backBtnOnclick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        

        houseTableView.delegate = self
        houseTableView.dataSource = self
        houseTableView.separatorColor = .clear
        houseTableView.backgroundColor = #colorLiteral(red: 0.4068164229, green: 0.6917989254, blue: 0.6710440516, alpha: 1)
        
      
        
    }
    

    func getByObject(){
        ApiHelper.instance().getByObject(object: object.object){

            [weak self] (isSuccess,objectTmp) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (isSuccess){
                print("success")
                
                let url = URL(string: objectTmp!.objectImgPath)
                weakSelf.objectImg.kf.indicatorType = .activity
                weakSelf.objectImg.kf.setImage(with: url)
                
                weakSelf.object = objectTmp!
                weakSelf.objectLB.text = objectTmp!.object
                weakSelf.objectCountLB.text = "\(objectTmp!.objectCount)大主題"
                weakSelf.houseTableView.reloadData()
                
            }else{
                print("failed")

            }
        }
    }

}

extension HouseHomeViewController: UITableViewDataSource ,UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 一個 section 中的總列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return object.article.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.contentView.layer.masksToBounds = true
       
   
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HelperSecondTableViewCell", for: indexPath) as! HelperSecondTableViewCell
        
        // add shadow on cell
        cell.backgroundColor = .clear
        cell.contentView.layer.cornerRadius = 15
        
        cell.titleLB.text = object.article[indexPath.row].title
        cell.littleLB.text = "共\(object.article[indexPath.row].articleCount)篇文章"
        let url = URL(string: object.article[indexPath.row].imagePath)
        cell.img.kf.indicatorType = .activity
        cell.img.kf.setImage(with: url)

        return cell
    }
    
    //點擊後跳轉，並避免一直選取
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier:     "SummaryViewController") as? SummaryViewController{
            self.houseHomeViewControllerDelegate = popoverController
            houseHomeViewControllerDelegate?.sendType(type: object.article[indexPath.row].type,articleCount : object.article[indexPath.row].articleCount , typeImagePath :object.article[indexPath.row].imagePath)
            presentBottom(popoverController)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


extension HouseHomeViewController : HelperViewControllerDelegate {
    func sendObject(object: String) {
        self.object.object = object
        getByObject()
    }
}
