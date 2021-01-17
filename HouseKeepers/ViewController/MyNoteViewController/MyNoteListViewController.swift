//
//  MyNoteViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/13.
//

import UIKit
import GoogleMaps

protocol MyNoteListViewControllerDelegate : AnyObject{
    func sendNoteId(noteId: String)
}

class MyNoteListViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    
    
    
    var houseArray:[HouseModel]?
    
    var notes : [NoteModel] = []
    
    
    //    private var viewModel: MyNoteListViewModel!
    
    @IBOutlet weak var pencilImg: UIImageView!
    
    @IBOutlet weak var descLB: UILabel!
    @IBOutlet weak var notesTableView: UITableView!
    
    weak var myNoteListViewControllerDelegate : MyNoteListViewControllerDelegate?
    
    @IBAction func sd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        //找到popoverview的class
        if let popoverController = storyboard.instantiateViewController(withIdentifier:"DragTestViewController") as? DragTestViewController{
            popoverController.modalPresentationStyle = .fullScreen
            present(popoverController, animated: false, completion: nil)
            
        }
    }
    
    
    @IBAction func addBtnOnClick(_ sender: UIButton) {
//        //主要改變新增頁面的標題文字
//        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
//        if let popoverController = storyboard.instantiateViewController(withIdentifier:     "AddNoteViewControllerr") as? AddNoteViewController{
//            self.myNoteListViewControllerDelegate? = popoverController
//            myNoteListViewControllerDelegate?.sendNoteId(noteId: "")
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        ApiHelper.instance().getMyNotes(){
            [weak self] (isSuccess) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (isSuccess){
                print("success")
                weakSelf.notes = MyNoteList.instance().getNotes()!
                weakSelf.notesTableView.reloadData()
                
            }else{
                print("failed")
                
            }
        }
        
        if notes.count >= 0 {
            pencilImg.isHidden = true;
            descLB.isHidden = true;
        }else{
            pencilImg.isHidden = false;
            descLB.isHidden = false;
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        viewModel = MyNoteListViewModel()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //設定tableview每一列的高度
        notesTableView.rowHeight = 150
        notesTableView.estimatedRowHeight=0
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.separatorColor = .clear
        notesTableView.backgroundColor = #colorLiteral(red: 0.9791635871, green: 0.9526864886, blue: 0.8682376146, alpha: 1)
        
    }
  
}



extension MyNoteListViewController : UIPopoverPresentationControllerDelegate{
    //IOS會自動偵測是iphone還是ipad，如果是iphone的話預設popover會是全螢幕，加上這個func以後會把預設的關閉，照我們寫的視窗大小彈出
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


extension MyNoteListViewController: UITableViewDataSource ,UITableViewDelegate{
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        <#code#>
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        <#code#>
    //    }
    
    
    // 一個 tabelView 中有幾個 section（table view可以有多個區塊，但預設是一個）
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 一個 section 中的總列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if notes.count == 0  {
            pencilImg.isHidden = false;
            descLB.isHidden = false;
        }else{
            pencilImg.isHidden = true;
            descLB.isHidden = true;
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //  let houseModel = viewModel.noteArray[indexPath.row]
        
        
        //將UI那的 cell id 與這邊綁定，dequeueReusableCell 方法用來取得佇列中可重複使用的cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNoteHouseCell", for: indexPath) as! MyNoteHouseCell
    
        
        cell.houseNameLB.text = notes[indexPath.row].house.name
        cell.addressLB.text = notes[indexPath.row].house.address
        cell.priceLB.text = "\(Int(notes[indexPath.row].house.price))萬"
        cell.patternLB.text = notes[indexPath.row].house.pattern
        cell.pingLB.text =  "\(Int(notes[indexPath.row].house.ping))坪"
        
        return cell
    }
    
    //點擊後跳轉，並避免一直選取
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MyNote", bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier:     "SingleNoteViewController") as? SingleNoteViewController{
            self.myNoteListViewControllerDelegate = popoverController
            myNoteListViewControllerDelegate?.sendNoteId(noteId: notes[indexPath.row].noteId)
            navigationController?.pushViewController(popoverController,animated: false)
//            presentBottom(popoverController)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        
        //設定刪除按鈕
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { (action, sourceView, completionHandler) in
            
            // 從資料源刪除列
            ApiHelper.instance().deleteNoteByNoteId(noteId:self.notes[indexPath.row].noteId){
                [weak self] (isSuccess) in
                guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                    return
                }
                if (isSuccess){
                    print("success")
                    //                        weakSelf.notes = MyNoteList.instance().getNotes()!
                    weakSelf.notes.remove(at: indexPath.row)
                    weakSelf.notesTableView.reloadData()
                    
                }else{
                    print("failed")
                    
                }
            }
            
            completionHandler(true)
        }
        
        
        //        //設定分享按鈕
        //        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
        //            let defaultText = "Just checking in at " + self.houseNames[indexPath.row]
        //
        //            let activityController: UIActivityViewController
        //
        //            if let imageToShare = UIImage(named: self.houseImages[indexPath.row]) {
        //                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
        //            } else  {
        //                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        //            }
        //
        //            self.present(activityController, animated: true, completion: nil)
        //            completionHandler(true)
        //        }
        
        //        //將兩個按鈕加入
        //        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        //避免左滑到底刪除
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
        
    }
    
    
    
}

