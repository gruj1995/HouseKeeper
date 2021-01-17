//
//  ArticleViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/12.
//

import UIKit

class ArticleViewController: PresentBottomVC {
    

    override var controllerHeight: CGFloat {
        return Global.screenSize.height*13/14
    }
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dateLB: UILabel!
    @IBOutlet weak var hashTagLB: UILabel!
    
    @IBOutlet weak var articleTitleLB: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var articleId = ""
    
    @IBAction func backBtnOnclick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    var article = ArticleModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textView.isEditable = false
        textView.isSelectable = false
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 20
        getByArticleId()
    }
    
    
    func getByArticleId(){
        ApiHelper.instance().getByarticleId(articleId: articleId ){

            [weak self] (isSuccess,article) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (isSuccess){
                print("success")
                weakSelf.article = article!
                let url = URL(string: article!.imagePath)
                weakSelf.imgView.kf.indicatorType = .activity
                weakSelf.imgView.kf.setImage(with: url)
                weakSelf.dateLB.text = article!.dateTime
                weakSelf.articleTitleLB.text = article!.articleTitle
                weakSelf.textView.text = article!.inofrmation
                weakSelf.hashTagLB.text = "#\(article!.object) #\(article!.title)"
            }else{
                print("failed")

            }
        }
    }

}


