//
//  MapSearchBar.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/5.
//

import UIKit

class MapSearchBar : UISearchBar{
    
    var contentInset : UIEdgeInsets?{
        didSet{
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        // view是searchBar中的唯一的直接子控制元件
//        for view in self.subviews {
//            // UISearchBarBackground與UISearchBarTextField是searchBar的簡介子控制元件
//            for subview in view.subviews {
//                // 找到UISearchBarTextField
//                
//                if subview.isKind(of: UITextField.classForCoder()) {
//                    if let textFieldContentInset = contentInset { // 若contentInset被賦值
//                        // 根據contentInset改變UISearchBarTextField的佈局
//                        subview.frame = CGRect(x: textFieldContentInset.left, y: textFieldContentInset.top, width: self.bounds.width - textFieldContentInset.left - textFieldContentInset.right, height: self.bounds.height - textFieldContentInset.top - textFieldContentInset.bottom)
//                    } else { // 若contentSet未被賦值
//                        // 設定UISearchBar中UISearchBarTextField的預設邊距
//                        let top: CGFloat = (self.bounds.height - 28.0) / 2.0
//                        let bottom: CGFloat = top
//                        let left: CGFloat = 8.0
//                        let right: CGFloat = left
//                        contentInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
//                    }
//                }
//            }
//        }
    }
    
}
