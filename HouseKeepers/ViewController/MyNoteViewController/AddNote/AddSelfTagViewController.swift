//
//  AddSelfTagViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/10.
//

import UIKit

protocol  AddSelfTagViewControllerDelegate : AnyObject {
    func getData(value: String)
}



class AddSelfTagViewController: PresentMiddleVC {

    let screenSize = UIScreen.main.bounds.size
    
    override var controllerHeight: CGFloat {
        return screenSize.height*1
    }

    override var controllerWidth: CGFloat {
        return screenSize.width*1
    }
    
    var data: String = ""
    
    weak var addSelfTagViewControllerDelegate: AddSelfTagViewControllerDelegate?
    @IBOutlet weak var tagNameTF: RoundShdowTextField!
    @IBOutlet weak var stackView: RoundStackView!
    
    
    @IBAction func checkBtnOnclick(_ sender: UIButton) {
        self.view.endEditing(true)

        if let tagName = tagNameTF.text{
            data.append(tagName )
        }
        addSelfTagViewControllerDelegate?.getData(value:data)
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.layer.cornerRadius = 20
        stackView.clipsToBounds = true
        tagNameTF.delegate = self
    }
    


}

extension AddSelfTagViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //  結束編輯，按下return把鍵盤隱藏起來
        self.view.endEditing(true)
        return true;
    }
    
}
