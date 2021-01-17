//
//  EditPhotoViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/6.
//

import UIKit
import TLPhotoPicker

protocol EditPhotoViewControllerDelegate : AnyObject{
    func sendImgs(imgs: [UIImage] , imgPaths : [String])
}

class EditPhotoViewController: PresentBottomVC {
    
    var screenSize = UIScreen.main.bounds.size
    override var controllerHeight: CGFloat {
        return screenSize.height*10/11
    }
    
    weak var editPhotoViewControllerDelegate:EditPhotoViewControllerDelegate?
    
    var selectedAssets = [TLPHAsset]()
    
    var imgs : [UIImage] = []
    var imagePaths : [String] = []
    
    @IBOutlet weak var editTableView: UITableView!
  
    @IBOutlet weak var footerView: UIView!
    
    @IBAction func backBtnOnclick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkBtnOnclick(_ sender: UIButton) {
        editPhotoViewControllerDelegate?.sendImgs(imgs: imgs , imgPaths: imagePaths)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        footerView.layer.cornerRadius = 10
        footerView.clipsToBounds = true
        
        //設定tableview每一列的高度
        editTableView.rowHeight = 150
        editTableView.estimatedRowHeight=0
        editTableView.delegate = self
        editTableView.dataSource = self
        editTableView.separatorColor = .clear
        //隱藏滾動條
        editTableView.showsVerticalScrollIndicator = false
        
        //點擊footer新增相片
        let imgGesture = UITapGestureRecognizer(target: self, action:  #selector(imgOnClick))
        self.footerView.addGestureRecognizer(imgGesture)
        
    }
    
    
    //叫出照片
    @objc func imgOnClick(sender : UITapGestureRecognizer) {
        let photoViewController = TLPhotosPickerViewController()
        photoViewController.delegate = self
        self.present(photoViewController, animated: true, completion: nil)
    }
    
}
extension EditPhotoViewController: UITableViewDataSource ,UITableViewDelegate{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 一個 section 中的總列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagePaths.count + imgs.count
      
    }
    
    //回傳區塊（section）中的列數
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "EditPhotoTableViewCell", for: indexPath) as! EditPhotoTableViewCell
        
        //如果是修改筆記頁面，用url設置圖片
        if imagePaths != []{
            if imagePaths.count > indexPath.row{
                var path = imagePaths[indexPath.row]
                path = path.replace(target: " ", withString: "%20")
                
                let url = URL(string: path)
                cell.imgView.kf.indicatorType = .activity
                cell.imgView.kf.setImage(with: url)
            }else{
                cell.imgView.image = imgs[indexPath.row - (imagePaths.count)]
            }
        }else{
            cell.imgView.image = imgs[indexPath.row]
        }
        
        // 實現cell的delegate
        cell.editPhotoTableViewCellDelegate = self

        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat(180)
//    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return self.footerView
//    }
    
    //點擊後避免一直選取
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension EditPhotoViewController:TLPhotosPickerViewControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        let image = info[.originalImage] as! UIImage
    
        imgs.append(image)

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
    }
    func dismissComplete() {
        //完成照片選取並離開
        for index in 0..<self.selectedAssets.count{
            if let image = self.selectedAssets[index].fullResolutionImage{
                imgs.append(image)
            }
        }
    //自動滑到新增照片的最尾端
//         let index = IndexPath.init(item: imgs.count-1, section: 1)
//         self.editTableView.scrollToRow(at: index, at: .bottom , animated: true)
        
        editTableView.reloadData()
    }
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        //選取超過最大上限數量的照片
    }
}



extension EditPhotoViewController : EditPhotoTableViewCellDelegate{
    func buttonTapped(cell: EditPhotoTableViewCell) {
        guard let indexPath = self.editTableView.indexPath(for: cell) else { return }

        if imagePaths.count > indexPath.row{
            self.imagePaths.remove(at: indexPath.row)
        }else{
            self.imgs.remove(at: indexPath.row - (imagePaths.count))
        }

        editTableView.deleteRows(at: [indexPath], with: .fade)
        editTableView.reloadData()
 
    }

}
