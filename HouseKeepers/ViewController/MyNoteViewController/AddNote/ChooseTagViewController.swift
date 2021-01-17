//
//  ChooseTagViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/9.
//

import UIKit

protocol ChooseTagViewControllerDataSource: class {
    func chooseTagViewControllerChosenTags(_ chooseTagViewController : ChooseTagViewController) -> [String]
}

protocol ChooseTagViewControllerDelegate : AnyObject {
    func getData(value: [String])
}


class ChooseTagViewController: PresentMiddleVC {
    
    let screenSize = UIScreen.main.bounds.size
    
    weak var dataSource: ChooseTagViewControllerDataSource!
    weak var chooseTagViewControllerDelegate: ChooseTagViewControllerDelegate?
    
    override var controllerHeight: CGFloat {
        return screenSize.height*1
    }
    
    override var controllerWidth: CGFloat {
        return screenSize.width*1
    }
    
    //原始資料
    var defaultTags = ["採光","通風","交通","價錢","學區","屋齡","治安","車位","公設比","生活機能"]
    var selfTags  = ["氣味","溫度"]
    
    //總資料
    var defaultDatas : [String] = []
    var selfDatas: [String] = []

    var selectedSelfTagIndexs : [Int] = []
    
    @IBOutlet weak var defaultCV: UICollectionView!
    @IBOutlet weak var selfCV: UICollectionView!
  
    @IBOutlet weak var backgroundView: UIView!
    
    
    @IBAction func backBtnOnclick(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func checkBtnOnclick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        var str : [String] = []
        
        for i in 0..<selfDatas.count{
            str.append(selfDatas[i])
        }
        for i in 0..<defaultDatas.count{
            str.append(defaultDatas[i])
        }

        chooseTagViewControllerDelegate?.getData(value: str)
        dismiss(animated: false, completion: nil)
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.masksToBounds = true
        
        //多選
        defaultCV.allowsMultipleSelection = true
        selfCV.allowsMultipleSelection = true
        
        
        //        var choosedStr = dataSource.chooseTagViewControllerChosenTags(self).forEach { (str) in
        //            print(str)
        //        }
        //
        
    }
    
    
}

extension ChooseTagViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case defaultCV:
            return defaultTags.count
        case selfCV:
            //最後一項是新增標籤按鈕
            return selfTags.count+1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //選過的陣列
        var choosedStr = dataSource.chooseTagViewControllerChosenTags(self)
        
        switch collectionView{
        case defaultCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SystemDefaultCollectionViewCell", for: indexPath) as! SystemDefaultCollectionViewCell
            
            cell.textLabel.text = defaultTags[indexPath.row]
            
            for i in 0..<choosedStr.count{
                if defaultTags[indexPath.row] == choosedStr[i]{
                    defaultDatas.append(choosedStr[i])
                    cell.isSelected = true
                    break
                }
            }
            
            return cell
        case selfCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelfCollectionViewCell", for: indexPath) as! SelfCollectionViewCell
    
            //新增標籤選項
            if indexPath.row == selfTags.count{
                cell.isLast(islast: true)
                
            }else{
                for i in 0..<choosedStr.count{
                    if selfTags[indexPath.row] == choosedStr[i]{
                        selfDatas.append(choosedStr[i])
                        cell.isSelected = true
                        break
                    }
                }
                
//                if selectedSelfTagIndexs.contains(indexPath.row){
//                    cell.isSelected = true
//                }else{
//                    cell.isSelected = false
//                }
                cell.textLabel.text = selfTags[indexPath.row] 
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView{
        case defaultCV:
            defaultDatas.append(defaultTags[indexPath.row])
        case selfCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelfCollectionViewCell", for: indexPath) as! SelfCollectionViewCell
            //選中最後一個自定義按鈕
            if indexPath.row == selfTags.count{
                cell.isLast(islast: true)
                let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
                if let popoverController = storyboard.instantiateViewController(withIdentifier: "AddSelfTagViewController") as? AddSelfTagViewController {
                    popoverController.addSelfTagViewControllerDelegate = self
                    self.presentMiddle(popoverController )
                }
            }else{
                selfDatas.append(selfTags[indexPath.row])
                selectedSelfTagIndexs.append(indexPath.row)
            }
            
        default:
            break
        }
        
        print("選中了！！！！！！！！！！")
        
        print("\(defaultDatas)")
        print("\(selfDatas)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        switch collectionView{
        case defaultCV:
            let str = defaultTags[indexPath.row]
            for i in 0..<defaultDatas.count{
                if defaultDatas[i].elementsEqual(str){
                    defaultDatas.remove(at: i)
                    break
                }
            }
        case selfCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelfCollectionViewCell", for: indexPath) as! SelfCollectionViewCell
            //選中最後一個自定義按鈕
            if indexPath.row == selfTags.count{
                cell.isLast(islast: true)
                let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
                if let popoverController = storyboard.instantiateViewController(withIdentifier: "AddSelfTagViewController") as? AddSelfTagViewController {
                    popoverController.addSelfTagViewControllerDelegate = self
                    self.presentMiddle(popoverController )
                }
                
            }else{
                let str = selfTags[indexPath.row]
                for i in 0..<selfDatas.count{
                    if selfDatas[i].elementsEqual(str){
                        selfDatas.remove(at: i)
                        break
                    }
                }
                for i in 0..<selectedSelfTagIndexs.count{
                    if selectedSelfTagIndexs[i] == indexPath.row{
                        selectedSelfTagIndexs.remove(at: i)
                        break
                    }
                }
                
            }
            
        default:
            break
        }
        
        print("取消選取！！！！！！！！！！")
        print("\(defaultDatas)")
        print("\(selfDatas)")
        
    }
    
    
    
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //
    //            //Create UICollectionReusableView
    //            var reusableView = UICollectionReusableView()
    //
    //            if collectionView.tag == 0 {
    //                reusableView = collectionView.dequeueReusableSupplementaryView(
    //                        ofKind:
    //                            UICollectionView.elementKindSectionFooter,
    //                        withReuseIdentifier: "HideFooterView",
    //                        for: indexPath)
    //                reusableView.frame.size.height = 0.0
    //                reusableView.frame.size.width = 0.0
    //
    //            }else if collectionView.tag == 1 {
    //                reusableView = collectionView.dequeueReusableSupplementaryView(
    //                        ofKind:
    //                            UICollectionView.elementKindSectionFooter,
    //                        withReuseIdentifier: "AddFooterView",
    //                        for: indexPath)
    //
    //                    reusableView.backgroundColor = UIColor.clear
    //                    reusableView.layer.cornerRadius = 10
    //                    reusableView.clipsToBounds = true
    //
    //                    //將點擊事件塞給reusableView(Footer)
    //                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(footerViewTapped))
    //                    reusableView.addGestureRecognizer(tapGesture)
    //
    //            }
    //            return reusableView
    //        }
    //
    //        //設定footer點擊事件
    //        @objc func footerViewTapped() {
    //            let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
    //            //找到popoverview的class
    //            if let popoverController = storyboard.instantiateViewController(withIdentifier: "AddSelfTagViewController") as? AddSelfTagViewController {
    //                popoverController.addSelfTagViewControllerDelegate = self
    //                self.presentMiddle(popoverController )
    //            }
    //
    //        }
    
}



//管理ＣollectionView Cell大小
extension  ChooseTagViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize = CGSize()
        let textFont = UIFont.systemFont(ofSize: 12)
        
        var textString = ""
        switch collectionView{
        case defaultCV:
            textString = defaultTags[indexPath.row]
            
        case selfCV:
            if indexPath.row < selfTags.count{
                textString = selfTags[indexPath.row]
            }
        default:
            return CGSize()
        }
        let textMaxSize = CGSize(width: 240, height: CGFloat(MAXFLOAT))
        let textLabelSize = self.textSize(text:textString , font: textFont, maxSize: textMaxSize)
        
        
        
        //        //+40 是右方icon寬度 + 其他設定
        //        //如果你是單純文字的話不用加
        //        cellSize.width = textLabelSize.width + 40
        cellSize.width = textLabelSize.width
        
        //高度固定
        cellSize.height = 20
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
        if collectionView.numberOfItems(inSection: section) == 0 {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: 40, height: 20)
    }
    
}


extension ChooseTagViewController : AddSelfTagViewControllerDelegate{
    func getData(value: String) {
        if value != ""{
            self.selfTags.append(value)
            selfCV.reloadData()
        }
        
    } 
}
