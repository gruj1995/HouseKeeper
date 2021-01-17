//
//  AddTagViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/29.
//

import UIKit
import TTGTagCollectionView
import DragDropiOS


protocol AddTagViewControllerDelegate : AnyObject {
    func sendTags(goodTags : [String] , badTags: [String])
}


class AddTagViewController: PresentMiddleVC, TTGTextTagCollectionViewDelegate{
    
 
    override var controllerHeight: CGFloat {
        return Global.screenSize.height*1
    }
    override var controllerWidth: CGFloat {
        return Global.screenSize.width*1
    }
    weak var addTagViewControllerDelegate : AddTagViewControllerDelegate?
    
    @IBOutlet weak var goodLV: littleView!
    @IBOutlet weak var badLV: littleView!
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var goodBtn: RoundButton!
    @IBOutlet weak var badBtn: RoundButton!

    @IBOutlet weak var goodCV: UICollectionView!
    @IBOutlet weak var badCV: UICollectionView!
    
    var goodTags : [String] = []
    var badTags : [String] = []

    var currentChooseType = -1
    
//
//    let goodCV = TTGTextTagCollectionView()
//    let badCV = TTGTextTagCollectionView()
    
    
    @IBAction func xMarkOnClick(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func checkBtnOnclick(_ sender: Any) {
      
        addTagViewControllerDelegate?.sendTags(goodTags: goodTags, badTags: badTags)
       
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true

//        initButton()
        
        
        let goodTagGesture = UITapGestureRecognizer(target: self, action:  #selector(goodOnClick))
        self.goodLV.addGestureRecognizer( goodTagGesture)
        
        let badTagGesture = UITapGestureRecognizer(target: self, action:  #selector( badOnClick))
        self.badLV.addGestureRecognizer(badTagGesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
//        backgroundView.addSubview(goodCV)
//        backgroundView.addSubview(badCV)
//
//        goodCV.frame = CGRect(x: 20, y: 150, width: screenSize.width*0.85, height: 50)
//
//        badCV.frame = CGRect(x: 20, y: 300, width: screenSize.width*0.85, height: 112)
//        goodCV.frame = CGRect(x: goodBtn.frame.origin.x, y:  goodBtn.frame.maxY+10, width: view.frame.size.width, height: badBtn.frame.maxY-goodBtn.frame.maxY)
//
//        badCV.frame = CGRect(x: badBtn.frame.origin.x, y: badBtn.frame.maxY+10, width: view.frame.size.width, height: 112)
       
    }
    
    func initview(){
//        backgroundView.addSubview(goodCV)
        backgroundView.addSubview(badCV)
       
//        goodCV.frame = CGRect(x: 20, y: 150, width: screenSize.width*0.85, height: 112)
//        goodCV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//
//        badCV.frame = CGRect(x: 20, y: 300, width: screenSize.width*0.85, height: 112)
//         badCV.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        
    }
    
    @objc func goodOnClick(sender : UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        //找到popoverview的class
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "ChooseTagViewController") as? ChooseTagViewController {
            currentChooseType = 0
            popoverController.chooseTagViewControllerDelegate = self
            popoverController.dataSource = self
            self.presentMiddle(popoverController)
        }
    }
    
    @objc func badOnClick(sender : UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        //找到popoverview的class
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "ChooseTagViewController") as? ChooseTagViewController {
            currentChooseType = 1
            popoverController.chooseTagViewControllerDelegate = self
            popoverController.dataSource = self
            self.presentMiddle(popoverController )
        }
    }
    

    
        
//    func initButton(){
//
//        badCV.alignment = .left
//        badCV.delegate = self
//        badCV.verticalSpacing = 15
//
//
//        goodCV.alignment = .left
//        goodCV.delegate = self
//        goodCV.verticalSpacing = 15
//
//
//        let config = TTGTextTagConfig()
//        config.exactHeight = 32
//        config.backgroundColor = #colorLiteral(red: 0.9373417497, green: 0.4713373184, blue: 0.4360579252, alpha: 1)
//        config.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        config.textFont.withSize(11)
//
//        config.borderWidth = 0
//        config.cornerRadius = 15
//
//        config.selectedBackgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
//        config.selectedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        config.selectedBorderWidth = 0
//        config.selectedCornerRadius = 15
//
//        let config2 = TTGTextTagConfig()
//        config2.exactHeight = 32
//        config2.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//        config2.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        config2.textFont.withSize(11)
//
//        config2.borderWidth = 0
//        config2.cornerRadius = 15
//
//        config2.selectedBackgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//        config2.selectedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        config2.selectedBorderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        config2.selectedBorderWidth = 0
//        config2.selectedCornerRadius = 15
//
//        goodCV.addTags(goodTags, with: config)
//        badCV.addTags(badTags, with: config2)
//
//    }
    
    
}



extension  AddTagViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        

        var cellSize = CGSize()
        let textFont = UIFont.systemFont(ofSize: 12)
        
        var textString = ""
        switch collectionView{
        case goodCV:
            textString = goodTags[indexPath.row]
        case badCV:
            textString = badTags[indexPath.row]
        default:
            return CGSize()
        }
//        let textString = goodTags[indexPath.item]
        let textMaxSize = CGSize(width: 240, height: CGFloat(MAXFLOAT))
        let textLabelSize = self.textSize(text:textString , font: textFont, maxSize: textMaxSize)
    
        cellSize.width = textLabelSize.width
        
        //高度固定
        cellSize.height = 30
        return cellSize
    }
    
    //偵測文字大小改變cell的size
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    
    //collectionView內間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let vPadding = CGFloat(5.0)
        let hPadding = CGFloat(5.0)
        
        //格子居左對齊
        if collectionView.numberOfItems(inSection: section) == 1 {
             let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

            return UIEdgeInsets(top: vPadding, left: hPadding, bottom: vPadding, right: (hPadding + collectionView.frame.width) - flowLayout.itemSize.width)
        }
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    //cell左右間距
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9.0
    }
    
    
    //cell上下間距
    func collectionView(_ collectionView: UICollectionView, layout
                            collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}


extension AddTagViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case goodCV:
            print("-=-=--=--=-=-=-=-=-=-=-=-=-=-= \(goodTags.count)")
            return goodTags.count
        case badCV:
            print("-=-=--=--=-=-=-=-=-=-=-=-=-=-= \(badTags.count)")
            return badTags.count
        default:
            print("18181818188181818181818188181")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
        case goodCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoodTagCollectionViewCell", for: indexPath) as! AddTagCollectionViewCell
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.layer.borderWidth = 0
            cell.goodLB.text = goodTags[indexPath.row]
            cell.goodLB.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.goodLB.font = UIFont.systemFont(ofSize: 12)
            cell.goodLB.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            return cell
        case badCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadTagCollectionViewCell", for: indexPath) as! AddTagCollectionViewCell
            cell.contentView.backgroundColor = #colorLiteral(red: 0.3910183907, green: 0.5937055349, blue: 0.9816486239, alpha: 1)
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.layer.borderWidth = 0
            cell.badLB.text = badTags[indexPath.row]
            cell.badLB.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.badLB.font = UIFont.systemFont(ofSize: 12)
            cell.badLB.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }

}

extension AddTagViewController : ChooseTagViewControllerDelegate{
    func getData(value: [String]) {
   
        if currentChooseType == 0{
            goodTags = value
            goodCV.reloadData()

        }else if currentChooseType == 1{
            badTags = value
            badCV.reloadData()
        }

    }
}

extension AddTagViewController: ChooseTagViewControllerDataSource{
    func chooseTagViewControllerChosenTags(_ chooseTagViewController: ChooseTagViewController) -> [String] {
        return goodTags + badTags
    }
}
