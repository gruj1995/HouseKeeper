//
//  AlertViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/30.
//

import UIKit


protocol AlertViewControllerDelegate : AnyObject {
    func getData(value: [String] , type: Int)
}

class AlertViewController: PresentMiddleVC{
    
    static var type = 0

    var datas: [String] = []
    
    
    let screenSize = UIScreen.main.bounds.size
    
    weak var alertViewControllerDelegate: AlertViewControllerDelegate?
    
    override var controllerHeight: CGFloat {
        return screenSize.height*1
    }
    
    override var controllerWidth: CGFloat {
        return screenSize.width*1
    }
    
    
    @IBOutlet weak var selfStack: UIStackView!
    @IBOutlet weak var contactStack: UIStackView!
    @IBOutlet weak var priceStack: UIStackView!
    @IBOutlet weak var patternStack: UIStackView!
    
    @IBOutlet weak var houseNameTF: RoundShdowTextField!
    @IBOutlet weak var contactManTF: RoundShdowTextField!
    @IBOutlet weak var contactPhoneTF: RoundShdowTextField!
    @IBOutlet weak var priceTF: RoundShdowTextField!
    @IBOutlet weak var pingTF: RoundShdowTextField!
    @IBOutlet weak var hallTF: RoundShdowTextField!
    @IBOutlet weak var roomTF: UITextField!
    @IBOutlet weak var bathTF: UITextField!
    
    
    @IBAction func houseCheck(_ sender: Any) {
        self.view.endEditing(true)
        if let houseName = houseNameTF.text{
            datas.append(houseName)
        }
        alertViewControllerDelegate?.getData(value: datas , type: 1)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func contactCheck(_ sender: Any) {
        self.view.endEditing(true)
        if let contactMan = contactManTF.text{
            datas.append(contactMan)
        }
        if let contactPhone = contactPhoneTF.text{
            datas.append(contactPhone)
        }
        alertViewControllerDelegate?.getData(value: datas , type: 2)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func priceCheck(_ sender: Any) {
        self.view.endEditing(true)
        if let price = priceTF.text{
            datas.append(price)
        }
        if let ping = pingTF.text{
            datas.append(ping)
        }
        alertViewControllerDelegate?.getData(value: datas , type: 3)
        dismiss(animated: false, completion: nil)
    }
    @IBAction func patternCheck(_ sender: Any) {
        self.view.endEditing(true)
        if let hall = hallTF.text{
            datas.append(hall)
        }
        if let room = roomTF.text{
            datas.append(room)
        }
        if let bath = bathTF.text{
            datas.append(bath)
        }
        alertViewControllerDelegate?.getData(value: datas , type: 4)
        dismiss(animated: false, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
 
        setStackView(type: AlertViewController.type)
        
        houseNameTF.delegate = self
        contactManTF.delegate = self
        contactPhoneTF.delegate = self
        priceTF.delegate = self
        priceTF.placeholder = "單位/萬"
        pingTF.delegate = self
        pingTF.placeholder = "單位/坪"
        hallTF.delegate = self
        roomTF.delegate = self
        bathTF.delegate = self

    }
    
    
    
    func setStackView(type: Int) {
        switch type{
        case 1:
            selfStack.isHidden = false
            contactStack.isHidden = true
            priceStack.isHidden = true
            patternStack.isHidden = true
        case 2:
            selfStack.isHidden = true
            contactStack.isHidden = false
            priceStack.isHidden = true
            patternStack.isHidden = true
        case 3:
            selfStack.isHidden = true
            contactStack.isHidden = true
            priceStack.isHidden = false
            patternStack.isHidden = true
        case 4:
            selfStack.isHidden = true
            contactStack.isHidden = true
            priceStack.isHidden = true
            patternStack.isHidden = false
        default:
            break
           
        }
    }
    
    
}


extension AlertViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //  結束編輯，按下return把鍵盤隱藏起來
        self.view.endEditing(true)
        
        //效果一樣
//        textField.resignFirstResponder()
        return true;
    }
    
    //限制輸入數字
    func textField(_ textField: UITextField, shouldChangeCharactersIn
     range: NSRange, replacementString string: String) -> Bool {
        
        if textField != contactManTF && textField != houseNameTF {
//            if textField.text?.count == 0 && string == "0" {
//                return false
//            }
            return string == string.filter("0123456789.-#*+".contains)
        }else{
            return true
        }
     
   }

}
