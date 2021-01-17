//
//  SingleNoteViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/24.
//

import UIKit
import Kingfisher


protocol SingleNoteViewControllerDelegate : AnyObject{
    func editNote(noteId:String)
}

class SingleNoteViewController:PresentBottomVC{
    
    
    var screenSize = UIScreen.main.bounds.size
    override var controllerHeight: CGFloat {
        return screenSize.height*12/13
    }
    
    var note : NoteModel = NoteModel()
    var paths : [String] = []
    var urls : [URL] = []
    weak var singleNoteViewControllerDelegate : SingleNoteViewControllerDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var houseNameLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var patternLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var pingLB: UILabel!
    @IBOutlet weak var averagePingLB: UILabel!
    
    @IBOutlet weak var bolderView: UIView!
    @IBOutlet weak var priceStackView: UIStackView!
    
    @IBOutlet weak var manLB: UILabel!
    
    @IBOutlet weak var phoneCheckLB: UILabel!
    @IBOutlet weak var contactLV: littleView!
    
    var goodTags : [String] = []
   var badTags : [String] = []
    
    @IBAction func editBtnOnclick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController {
            self.singleNoteViewControllerDelegate = popoverController
            singleNoteViewControllerDelegate?.editNote(noteId:note.noteId)
            navigationController?.pushViewController(popoverController,animated: false)
        }
    }


    
    @IBAction func tapToSeeImg(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController {
            if note.imagePath.count != 0{
                popoverController.paths = note.imagePath
                popoverController.modalPresentationStyle = .fullScreen
                present(popoverController, animated: false, completion: nil)
            }
        }
    }
    
    
    @IBOutlet weak var tagLV: littleView!
    @IBOutlet weak var uploadLV: littleView!
    
    @IBOutlet weak var descTV: UITextView!
    
    @IBOutlet weak var grayLine: UIView!
    
    @IBOutlet weak var imageCV: UICollectionView!
    
    @IBOutlet weak var tagCV: UICollectionView!
    
    @IBAction func backOnClick(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        ApiHelper.instance().getByNoteId(noteId : note.noteId){
            [weak self] (result,note) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (result){
                print("success")
                weakSelf.note = note!
                weakSelf.houseNameLB.text = note?.house.name
                weakSelf.addressLB.text = note?.house.address
                weakSelf.patternLB.text = note?.house.pattern
                weakSelf.priceLB.text = "\(Int((note?.house.price ?? 0)))萬"
                
                weakSelf.pingLB.text = "\(Int((note?.house.ping ?? 0)))坪"
                
                if  note?.house.price != nil  && note?.house.ping != nil && note?.house.ping != 0{
                    let averagePing = Int((note?.house.price)!)/Int((note?.house.ping)!)
                    weakSelf.averagePingLB.text = "\(averagePing)萬/坪"
                }else{
                    weakSelf.averagePingLB.text = "0 萬/坪"
                }
                
                weakSelf.descTV.text = note?.desc
                weakSelf.manLB.text = note?.contactName
                weakSelf.phoneCheckLB.text = note?.contactPhone
                
                if note?.contactName != ""{
                    weakSelf.manLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                if note?.contactPhone != ""{
                    weakSelf.phoneCheckLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
//                print("--------------------- \(weakSelf.note.imagePath)")
                if weakSelf.note.imagePath.count != 0{
                    for i in 0..<weakSelf.note.imagePath.count{
                        
                        weakSelf.note.imagePath[i] = weakSelf.note.imagePath[i].replace(target: " ", withString: "%20")
                        weakSelf.urls.append(URL(string: weakSelf.note.imagePath[i])!)
                    }
                }
                
                var goodStr = note?.advantage.split(separator: "/")
                weakSelf.goodTags = (goodStr?.compactMap{"\($0)"})!

                var badStr = note?.disadvantage.split(separator: "/")
                weakSelf.badTags = (badStr?.compactMap{"\($0)"})!
             
                
                print("89898999898989898998989898989 \( weakSelf.goodTags)")
                print("89898999898989898998989898989 \( weakSelf.badTags)")
                weakSelf.tagCV.reloadData()
                weakSelf.imageCV.reloadData()
            }else{
                print("failed")
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        priceStackView.layer.cornerRadius = 10
        priceStackView.clipsToBounds = true
        bolderView.layer.cornerRadius = 10
        bolderView.clipsToBounds = true
        imageCV.isPagingEnabled = true
        setAllUI()
    }
    
    
    
    func setAllUI(){
        
        descTV.isEditable = false
        descTV.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        descTV.layer.cornerRadius = 10
        descTV.layer.masksToBounds = true
        descTV.layer.borderWidth = 1
        descTV.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        descTV.layer.shadowColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        //        descTV.layer.shadowOffset = CGSize(width: 0, height: 2);
        //        descTV.layer.shadowOpacity = 2
        //        let shadowPath = UIBezierPath(roundedRect:  descTV.bounds, cornerRadius: 10)
        //        descTV.layer.shadowPath = shadowPath.cgPath
        
    }
    
}

extension SingleNoteViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        switch collectionView{
        case imageCV:
                return note.imagePath.count
        case tagCV:
            print("現在count\(badTags.count + goodTags.count)")
            return badTags.count + goodTags.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        
        switch collectionView{
        case imageCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleNotePhotoCollectionViewCell", for: indexPath) as! SingleNotePhotoCollectionViewCell
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: urls[indexPath.row])
            return cell
        case tagCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCell", for: indexPath) as! AddNoteTagCollectionViewCell

            if indexPath.row<goodTags.count{
                cell.contentView.backgroundColor =  #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                cell.detailLB.text = goodTags[indexPath.row]
            }
            else {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.3910183907, green: 0.5937055349, blue: 0.9816486239, alpha: 1)
                cell.detailLB.text = badTags[indexPath.row - goodTags.count]
            }
            
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.layer.borderWidth = 0
            
            cell.detailLB.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.detailLB.font = UIFont.systemFont(ofSize: 12)
            cell.detailLB.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    
    }
    
    
}


extension  SingleNoteViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = imageCV.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    

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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9.0
    }
    func collectionView(_ collectionView: UICollectionView, layout
                            collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}


extension SingleNoteViewController : MyNoteListViewControllerDelegate{
    func sendNoteId(noteId: String) {
        self.note.noteId = noteId
    }
}

