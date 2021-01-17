//
//  SummaryViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/12.
//

import UIKit




class SummaryViewController: PresentBottomVC {
    
    override var controllerHeight: CGFloat {
        return Global.screenSize.height*13/14
    }
    
    @IBOutlet weak var typeLB: UILabel!
    @IBOutlet weak var articleCount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
 

    
    @IBOutlet weak var typeImg: UIImageView!
    @IBAction func backBtnOnclick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var type = ""
    var articlecount = ""
    
    var articles : [ArticleModel] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = #colorLiteral(red: 0.2904394269, green: 0.4880244732, blue: 0.3481304646, alpha: 1)
      
        
    }
    
    func getByType(){
        ApiHelper.instance().getByType(type: type){

            [weak self] (isSuccess,articles) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (isSuccess){
                print("success")
                print("ewewewewewewewewewewewe \(articles!.count)")
                weakSelf.articles = articles!
                let url = URL(string: articles![0].imagePath)
                weakSelf.typeImg.kf.indicatorType = .activity
                weakSelf.typeImg.kf.setImage(with: url)
                weakSelf.typeLB.text = articles![0].title
                weakSelf.articleCount.text = "\( weakSelf.articlecount)篇文章"
                weakSelf.tableView.reloadData()
            }else{
                print("failed")

            }
        }
    }
    
}


extension SummaryViewController: UITableViewDataSource ,UITableViewDelegate{

    // 一個 tabelView 中有幾個 section（table view可以有多個區塊，但預設是一個）
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 一個 section 中的總列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.contentView.layer.masksToBounds = true
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as! SummaryTableViewCell
        
        // add shadow on cell
        cell.backgroundColor = .clear
        cell.contentView.layer.cornerRadius = 15
        cell.summaryTableViewCellDelegate = self

        cell.articleTitleLB.text = articles[indexPath.row].articleTitle
        cell.textView.text = articles[indexPath.row].inofrmation
        cell.dateLB.text = articles[indexPath.row].dateTime
        cell.articleId = articles[indexPath.row].articleId
        return cell
    }
    
    //點擊後跳轉，並避免一直選取
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        tableView.deselectRow(at: indexPath, animated: true)
    }

}


extension SummaryViewController : UITextViewDelegate{
    
}

extension SummaryViewController : SummaryTableViewCellDelegate{
    func buttonTapped(cell: SummaryTableViewCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier:"ArticleViewController") as? ArticleViewController{
            popoverController.articleId = cell.articleId
            presentBottom(popoverController)
        }
    }
}

extension SummaryViewController : HouseHomeViewControllerDelegate {
    func sendType(type: String , articleCount : String , typeImagePath : String) {
        self.type = type
        self.articlecount = articleCount
        getByType()
    }
}
