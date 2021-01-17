//
//  SingleNoteViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/14.
//

import UIKit
import TLPhotoPicker

protocol AddNoteViewControllerDelegate : AnyObject{
    func sendHouseName(houseName: String)
}



class AddNoteViewController:PresentBottomVC,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var tagCV: UICollectionView!
    
    var screenSize = UIScreen.main.bounds.size
    override var controllerHeight: CGFloat {
        return screenSize.height*10/11
    }
    
    var note = NoteModel()
    var ping : String = ""
    var price : String = ""
    var room : String = ""
    var hall : String = ""
    var health : String = ""
    var advantage : String = ""
    var disadvantage : String = ""
    var contactPhone : String = ""
    var contactPerson : String = ""
    
    var goodTags : [String] = []
   var badTags : [String] = []
    var allTags : [String] = []
    
    
    var chossedAddress : String = ""
    var chossedHouseName : String = ""
    
    var houseImages : [UIImage] = []
    
    var selectedAssets = [TLPHAsset]()
    
    weak var addNoteViewControllerDelegate : AddNoteViewControllerDelegate?
    
    @IBOutlet weak var AddscrollView: UIScrollView!
    @IBOutlet weak var blackView: UIImageView!
    @IBOutlet weak var addNoteLB: UILabel!
    @IBOutlet weak var totalPriceLB: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var averagePingLB: UILabel!
    @IBOutlet weak var houseNameLB: UILabel!
    @IBOutlet weak var contactPersonLB: UILabel!
    @IBOutlet weak var contactPhoneLB: UILabel!
    @IBOutlet weak var phoneLittleLB: UILabel!
    @IBOutlet weak var patternLB1: UILabel!
    @IBOutlet weak var patternLB2: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    
    @IBOutlet weak var houseNameLV: littleView!
    @IBOutlet weak var addressLV: littleView!
    @IBOutlet weak var patternLV: littleView!
    @IBOutlet weak var contactLV: littleView!
    
    @IBOutlet weak var deleteNoteBtn: RoundButton!
    
    @IBAction func tapToSeeImg(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "EditPhotoViewController") as? EditPhotoViewController {
            //傳照片
            popoverController.editPhotoViewControllerDelegate = self
            popoverController.imagePaths = note.imagePath
            popoverController.imgs = houseImages
            presentBottom(popoverController)
        }
    }
    
    
    
    @IBOutlet weak var tapToSeeImgBtn: UIButton!
    
    @IBOutlet weak var tagLV: littleView!
    @IBOutlet weak var uploadLV: littleView!
    
    @IBOutlet weak var descTV: UITextView!
    
    @IBOutlet weak var priceIconStack: UIStackView!
    @IBOutlet weak var tagIconStack: UIStackView!
    @IBOutlet weak var imgIconStack: UIStackView!
    @IBOutlet weak var descIconStack: UIStackView!
    @IBOutlet weak var priceAndPingStack: UIStackView!
    
    @IBOutlet weak var grayLine: UIView!
    
    @IBOutlet weak var imageCV: UICollectionView!
    
    @IBOutlet weak var pingTF: RoundShdowTextField!
    
    var keyboardHeight: CGFloat = 0 // keep 住鍵盤的高度，在每次 ChangeFrame 的時侯記錄
    
    @IBAction func xMarkOnclick(_ sender: UIButton) {
        //        dismiss(animated: true, completion: nil)
        //        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        //        if let popoverController = storyboard.instantiateViewController(withIdentifier: "MyNoteListViewController") as? MyNoteListViewController {
        addNoteLB.text = "新增筆記"
        deleteNoteBtn.isHidden = true
        //            navigationController?.pushViewController(popoverController, animated: false)
        navigationController?.popViewController(animated: false)
        //        }
    }
    
    @IBAction func checkMarkOnclick(_ sender: UIButton) {
        //判斷從哪裡跳轉來這頁，分別做新增或修改筆記的動作
        let aheadController = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2])
        
        
        
        
        switch aheadController {
        case is MyNoteListViewController:
            //新增筆記
            print("eeeeeeeeeeeeeeeeee\(advantage)")
            print("qqqqqqqqqqqqqqqqqqq\(disadvantage)")
            ApiHelper.instance().postNote(title: houseNameLB.text ?? "", address: addressLB.text ?? "",ping: ping, totalPrice:price, room :room , hall: hall, health: health, advantage: advantage, disadvantage: disadvantage, information :descTV.text ?? "", contactPersonName: contactPerson, contactPersonPhone: contactPhone,photos: houseImages){
                
                [weak self] (isSuccess) in
                guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                    return
                }
                if (isSuccess){
                    print("success")
                    weakSelf.navigationController?.popViewController(animated: false)
                }else{
                    print("failed")
                    
                }
            }
            return
            
        case is SingleNoteViewController:
            //修改筆記
            //            if ping == ""{
            //                ping = "0"
            //            }
            //            if price == ""{
            //                price = "0"
            //            }
            //            if room == ""{
            //                room = "0"
            //            }
            //            if hall == ""{
            //                hall = "0"
            //            }
            //            if health == ""{
            //                health = "0"
            //            }
            
            ApiHelper.instance().modifyNote(noteId: note.noteId, title: houseNameLB.text ?? "", address: addressLB.text ?? "" , ping: ping , totalPrice:price, room :room , hall: hall, health: health, advantage: advantage, disadvantage: disadvantage, information :descTV.text ?? "", contactPersonName: contactPerson, contactPersonPhone: contactPhone, photos: houseImages){
                
                [weak self] (isSuccess) in
                guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                    return
                }
                if (isSuccess){
                    print("success")
                    //傳成功才跳回我的筆記頁面
                    let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
                    if let popoverController = storyboard.instantiateViewController(withIdentifier: "MyNoteListViewController") as? MyNoteListViewController {
                        
                        
                        //成功傳完資料後再傳照片
                        ApiHelper.instance().postImage(noteId:weakSelf.note.noteId, remainPath: weakSelf.note.imagePath, photos: weakSelf.houseImages){
                            [weak self] (result) in
                            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                                return
                            }
                            if (result){
                                print("success")
                            }else{
                                print("failed")
                                
                            }
                        }
                        
                        //跳回我的筆記頁面
                        weakSelf.addNoteLB.text = "新增筆記"
                        weakSelf.deleteNoteBtn.isHidden = true
                        weakSelf.navigationController?.pushViewController(popoverController, animated: false)
                    }
                    
                }else{
                    print("failed")
                    
                }
            }
            return
            
        default:
            return
        }
    }
    
    @IBAction func deleteBtnOnclick(_ sender: UIButton) {
        let alert = UIAlertController(title: "確定刪除筆記？", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler:{_ in
            ApiHelper.instance().deleteNoteByNoteId(noteId:self.note.noteId){
                [weak self] (isSuccess) in
                guard let weakSelf = self else {return}
                if (isSuccess){
                    print("success")
                    let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
                    if let popoverController = storyboard.instantiateViewController(withIdentifier:     "MyNoteListViewController") as? MyNoteListViewController{
                        weakSelf.navigationController?.pushViewController(popoverController,animated: false)
                    }else{
                        print("failed")
                        
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if addNoteLB.text == "編輯筆記"{
            addNoteLB.text = "新增筆記"
        }else{
            addNoteLB.text = "新增筆記"
        }
        
        imageCV.delegate = self
        imageCV.dataSource = self
        imageCV.isPagingEnabled = true
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        descTV.delegate = self
        setAllUI()
        
        // 叫出新增tag頁面
        let tagGesture = UITapGestureRecognizer(target: self, action:  #selector(tagOnClick))
        self.tagLV.addGestureRecognizer(tagGesture)
        
        let houseNameGesture = UITapGestureRecognizer(target: self, action:  #selector(houseNameOnClick))
        self.houseNameLV.addGestureRecognizer(houseNameGesture)
        
        let contactGesture = UITapGestureRecognizer(target: self, action:  #selector(contactOnClick))
        self.contactLV.addGestureRecognizer(contactGesture)
        
        let priceGesture = UITapGestureRecognizer(target: self, action:  #selector(priceOnClick))
        self.priceAndPingStack.addGestureRecognizer(priceGesture )
        
        let patternGesture = UITapGestureRecognizer(target: self, action:  #selector(patternOnClick))
        self.patternLV.addGestureRecognizer(patternGesture)
        
        let imgGesture = UITapGestureRecognizer(target: self, action:  #selector(imgOnClick))
        self.uploadLV.addGestureRecognizer(imgGesture)
        
        let addressGesture = UITapGestureRecognizer(target: self, action:  #selector(addressOnClick))
        self.addressLV.addGestureRecognizer(addressGesture)
        
        
        //設定按外面會把鍵盤收起
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
        
        //鍵盤隨使用者手勢移動
        AddscrollView.keyboardDismissMode = .interactive
        
        //        //開啟拍照介面
        //        show(imagePicker, sender: self)
        
    }
    
    func setAllUI(){
        totalPriceLB.isHidden = true
        totalPrice.isHidden = true
        averagePingLB.isHidden = true
        grayLine.isHidden = true
        contactPhoneLB.isHidden = true
        tapToSeeImgBtn.isHidden = true
        pingTF.isEnabled = false
        deleteNoteBtn.isHidden = true
        blackView.isHidden = true
        uploadLV.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        //        descTV.isEditable=true
        //        descTV.isSelectable=true
        descTV.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        descTV.layer.cornerRadius = 10
        //        descTV.layer.masksToBounds = true
        descTV.layer.borderWidth = 1
        descTV.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //        descTV.layer.shadowColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        //        descTV.layer.shadowOffset = CGSize(width: 0, height: 2);
        //        descTV.layer.shadowOpacity = 2
        //        let shadowPath = UIBezierPath(roundedRect:  descTV.bounds, cornerRadius: 10)
        //        descTV.layer.shadowPath = shadowPath.cgPath
        
    }
    
    
    @objc func tagOnClick(sender : UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "AddTagViewController") as? AddTagViewController {
            popoverController.addTagViewControllerDelegate = self
            self.presentMiddle(popoverController )
        }
    }
    
    //叫出照片
    @objc func imgOnClick(sender : UITapGestureRecognizer) {
        
        //還沒有相片時
        if houseImages.count == 0{
            let photoViewController = TLPhotosPickerViewController()
            photoViewController.delegate = self
            self.present(photoViewController, animated: true, completion: nil)
        }
    }
    //查地址
    @objc func addressOnClick(sender : UITapGestureRecognizer) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //找到popoverview的class
        if let  popoverController =
            storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController{
            popoverController.searchViewControllerDelegate = self
            self.addNoteViewControllerDelegate = popoverController
            self.addNoteViewControllerDelegate?.sendHouseName(houseName: houseNameLB.text ?? "")
            navigationController?.pushViewController(popoverController, animated: false)

        }
        

    }
    
    @objc func houseNameOnClick(sender : UITapGestureRecognizer) {
        AlertViewController.type = 1
        findStoryboard()
    }
    @objc func contactOnClick(sender : UITapGestureRecognizer) {
        AlertViewController.type = 2
        findStoryboard()
    }
    @objc func priceOnClick(sender : UITapGestureRecognizer) {
        AlertViewController.type = 3
        findStoryboard()
    }
    @objc func patternOnClick(sender : UITapGestureRecognizer) {
        AlertViewController.type = 4
        findStoryboard()
    }
    
    
    
    func findStoryboard(){
        //找到popoverview所在的storyboard
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        //找到popoverview的class
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController {
            popoverController.alertViewControllerDelegate = self
            self.presentMiddle(popoverController )
        }
    }
    
    
    //點擊空白收回鍵盤
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
}



extension AddNoteViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
        case imageCV:
            if note.imagePath != []{
                return note.imagePath.count + houseImages.count
            }
            else{
                return houseImages.count
            }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
            //如果是修改筆記頁面，用url設置圖片
            if note.imagePath != []{
                if note.imagePath.count > indexPath.row{
                    var path =  note.imagePath[indexPath.row]
                    path = path.replace(target: " ", withString: "%20")
                    
                    let url = URL(string: path)
                    cell.photoImg.kf.indicatorType = .activity
                    cell.photoImg.kf.setImage(with: url)
                }else{
                    cell.configureWithImg(with: houseImages[indexPath.row - (note.imagePath.count)])
                }
            }else{
                
                cell.configureWithImg(with: houseImages[indexPath.row])
            }
            return cell
        case tagCV:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNoteTagCollectionViewCell", for: indexPath) as! AddNoteTagCollectionViewCell
            print("目前位置\(indexPath.row)")
            
            
            if indexPath.row<goodTags.count{
                cell.contentView.backgroundColor =  #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                advantage += goodTags[indexPath.row] + "/"
                cell.tagLB.text = goodTags[indexPath.row]
            }
            
            else {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.3910183907, green: 0.5937055349, blue: 0.9816486239, alpha: 1)
                print("indexPath.row         \(indexPath.row )")
                print("goodTags.count         \(goodTags.count )")
//                guard (indexPath.row - goodTags.count) < badTags.count else {
//                    return UICollectionViewCell()
//                }
                cell.tagLB.text = badTags[indexPath.row - goodTags.count]
                disadvantage += badTags[indexPath.row - goodTags.count] + "/"
   
            }
            
            cell.layer.cornerRadius = 10
            cell.clipsToBounds = true
            cell.layer.borderWidth = 0
            
            cell.tagLB.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.tagLB.font = UIFont.systemFont(ofSize: 12)
            cell.tagLB.textInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
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

//管理ＣollectionView Cell大小
extension  AddNoteViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = imageCV.frame.size
        return CGSize(width: size.width, height: size.height)
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

extension AddNoteViewController:TLPhotosPickerViewControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        
        houseImages.append(image)
        
        dismiss(animated: true, completion: nil)
    }
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        return true
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        //使用者選好照片時
        self.selectedAssets = withTLPHAssets
        
    }
    func photoPickerDidCancel() {
        //取消選取照片
        //如果有照片
        if houseImages.count != 0{
            imgIconStack.isHidden = true
            tapToSeeImgBtn.isHidden = false
        }
    }
    func dismissComplete() {
        //完成照片選取並離開
        for index in 0..<self.selectedAssets.count{
            if let image = self.selectedAssets[index].fullResolutionImage{
                houseImages.append(image)
            }
        }
        
        //如果有照片
        if houseImages.count != 0{
            imgIconStack.isHidden = true
            tapToSeeImgBtn.isHidden = false
        }
        
        
        //        //自動滑到新增照片的最尾端
        //        let index = IndexPath.init(item: houseImages.count-1, section: 0)
        //        self.imageCV.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        imageCV.reloadData()
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        //選取超過最大上限數量的照片
    }
}


extension AddNoteViewController : AlertViewControllerDelegate{
    // houseName , contact, price , pattern
    
    func getData(value: [String], type: Int) {
        switch type{
        case 1:
            if value[0] != ""{
                houseNameLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                houseNameLB.text = value[0]
            }
        case 2:
            if value[0] != ""{
                if value[1] == ""{
                    contactPhoneLB.isHidden=true
                }
                contactPerson = value[0]
                contactPersonLB.isHidden=false
                contactPersonLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                contactPersonLB.text = value[0]
                phoneLittleLB.isHidden = true
                grayLine.isHidden = false
                //                grayLine.frame.origin.x = manLB.frame.origin.x+30
            }
            if value[1] != ""{
                if value[0] == ""{
                    contactPersonLB.isHidden=true
                }
                contactPhone = value[1]
                grayLine.isHidden = false
                contactPhoneLB.isHidden = false
                contactPhoneLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                contactPhoneLB.text = value[1]
                phoneLittleLB.isHidden = true
            }
            if  value[0] == "" &&  value[1] == ""{
                grayLine.isHidden = true
                contactPhoneLB.isHidden = true
                contactPersonLB.text = "點此輸入聯絡人資訊"
                contactPersonLB.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                contactPersonLB.isHidden=false
                phoneLittleLB.isHidden = false     
            }
        case 3:
            if value[0] != "" && value[1] != ""{
                print("錢有多少 \(value[0] ?? "0")")
                price = value[0] 
                priceIconStack.isHidden = true
                totalPriceLB.isHidden = false
                totalPrice.isHidden = false
                averagePingLB.isHidden = false
                totalPrice.textColor = #colorLiteral(red: 0.9370198846, green: 0.541541636, blue: 0.5137027502, alpha: 1)
                totalPrice.text = "\(value[0])萬"
                averagePingLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
                if  Int(value[0]) != nil && Int(value[1]) != nil{
                    let averagePing = Double(value[0])!/Double(value[1])!
                    averagePingLB.text = "\( String(format: "%.1f", averagePing))萬/坪"
                    ping = value[1] == "" ? "" : "\(value[1])"
                    pingTF.text = "\(String(format: "%.1f", Double(value[1])!))坪"
                    pingTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                
            }
            
        case 4:
            
            //            if value[0] != "" || value[1] != "" || value[2] != ""{
            patternLB1.text = ""
            let halls = value[0] == "" ? "" : "\(value[0])廳"
            let rooms = value[1] == "" ? "" : "\(value[1])房"
            let healths = value[2] == "" ? "" : "\(value[2])衛"
            
            hall = value[0]
            room = value[1]
            health = value[2]
            patternLB1.text! = "\(halls)\(rooms)\(healths)"
            patternLB1.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            patternLB2.isHidden = true
            
            
            
        default:
            return
        }
    }
}

extension AddNoteViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        //開始編輯時捲上去，避免鍵盤遮住編輯框
        self.AddscrollView.setContentOffset(CGPoint(x: 0, y: screenSize.height*0.35), animated: true)
        descIconStack.isHidden = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.AddscrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension AddNoteViewController : EditPhotoViewControllerDelegate{
    func sendImgs(imgs: [UIImage] , imgPaths : [String]) {
        self.houseImages = imgs
        self.note.imagePath = imgPaths
        blackView.isHidden = false
        imageCV.reloadData()
    }
    
}

extension AddNoteViewController : SearchViewControllerDelegate{
    func goToAddNoteViewController(address: String, houseName: String) {
        chossedAddress = address
        chossedHouseName = houseName
        
        //        if addressLB.text != "請輸入地址"{
        addressLB.text = chossedAddress
        addressLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        }
        
        //        if houseNameLB.text != "自定義房產名稱"{
        houseNameLB.text = chossedHouseName
        houseNameLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //        }
    }
    
}


extension AddNoteViewController: SingleNoteViewControllerDelegate{
    func sendImagePath(paths: [String]) {
    }
    func editNote(noteId: String) {
        self.note.noteId = noteId
        
        ApiHelper.instance().getByNoteId(noteId : note.noteId){
            [weak self] (result,note) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (result){
                print("success")
                weakSelf.addNoteLB.text = "編輯筆記"
                weakSelf.deleteNoteBtn.isHidden = false
                weakSelf.note = note!
                weakSelf.houseNameLB.text = note?.house.name
                weakSelf.houseNameLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                weakSelf.addressLB.text = note?.house.address
                weakSelf.addressLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                weakSelf.patternLB1.text = note?.house.pattern
                if note?.house.pattern != ""{
                    weakSelf.patternLB2.isHidden = true
                }
                weakSelf.patternLB1.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                weakSelf.pingTF.text = "\(Int((note?.house.ping ?? 0)))坪"
                
                weakSelf.totalPrice.text = "\(Int((note?.house.price ?? 0)))萬"
                weakSelf.priceIconStack.isHidden = true
                weakSelf.totalPriceLB.isHidden = false
                weakSelf.totalPrice.isHidden = false
                weakSelf.averagePingLB.isHidden = false
                weakSelf.totalPrice.textColor = #colorLiteral(red: 0.9370198846, green: 0.541541636, blue: 0.5137027502, alpha: 1)
                weakSelf.averagePingLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
                if  note?.house.price != nil  && note?.house.ping != nil && note?.house.ping != 0{
                    let averagePing = Int((note?.house.price)!)/Int((note?.house.ping)!)
                    weakSelf.averagePingLB.text = "\(averagePing)萬/坪"
                }else{
                    weakSelf.averagePingLB.text = "0 萬/坪"
                }
                
                weakSelf.descTV.text = note?.desc
                if note?.desc != ""{
                    weakSelf.descIconStack.isHidden = true
                }
                weakSelf.contactPersonLB.text = note?.contactName
                weakSelf.contactPhoneLB.text = note?.contactPhone
                
                if note!.contactName != ""{
                    weakSelf.grayLine.isHidden = false
                    weakSelf.phoneLittleLB.isHidden = true
                    weakSelf.contactPersonLB.isHidden = false
                    weakSelf.contactPersonLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                
                if note!.contactPhone != ""{
                    weakSelf.grayLine.isHidden = false
                    weakSelf.phoneLittleLB.isHidden = true
                    weakSelf.contactPhoneLB.isHidden = false
                    weakSelf.contactPhoneLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
                if note!.contactPhone == "" && note!.contactName == ""{
                    note?.contactName = "點此輸入聯絡人資訊"
                    weakSelf.contactPersonLB.isHidden = false
                    weakSelf.contactPersonLB.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
                if note!.imagePath != []{
                    weakSelf.imgIconStack.isHidden = true
                    weakSelf.tapToSeeImgBtn.isHidden = false
                }
                weakSelf.imageCV.reloadData()
            }else{
                print("failed")
                
            }
        }
    }
    
}


extension AddNoteViewController : AddTagViewControllerDelegate{
    func sendTags(goodTags: [String] , badTags: [String]) {
        self.badTags = badTags
        self.goodTags = goodTags
        
        self.tagIconStack.isHidden = true
        tagCV.reloadData()
    }
    
}
