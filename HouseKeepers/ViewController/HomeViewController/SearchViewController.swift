//
//  SearchViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/26.
//

import UIKit
import GooglePlaces


protocol SearchViewControllerDelegate : AnyObject{
    func goToAddNoteViewController(address: String , houseName:String)
}

class SearchViewController: UIViewController ,UITextFieldDelegate{
    
    
    private var tableView: UITableView!
    private var tableDataSource: GMSAutocompleteTableDataSource!
    @IBOutlet weak var searchAddressBar: UISearchBar!
    var tableViewCellHeight : CGFloat!
    var screenSize = UIScreen.main.bounds.size
    
    var noteHouseName = ""
    
    weak var searchViewControllerDelegate : SearchViewControllerDelegate?
    
    
    @IBAction func backBtnOnClick(_ sender: Any) {
        backToController(address: "")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
        //隱藏導航欄
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        tableDataSource = GMSAutocompleteTableDataSource()
        //表格單元格分隔線顏色
        tableDataSource.tableCellSeparatorColor = #colorLiteral(red: 0.9829811454, green: 0.9831220508, blue: 0.9829503894, alpha: 1)
        
        tableDataSource.delegate = self
        
        tableView = UITableView()
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        view.addSubview(tableView)
     
    }
    
    
    
    func initSearchBar(){
        
        searchAddressBar.delegate = self
        searchAddressBar.layer.cornerRadius = 30
        searchAddressBar.clipsToBounds = true
        searchAddressBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchAddressBar.layer.shadowOpacity = 0.23
        searchAddressBar.layer.shadowRadius = 10
        searchAddressBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        searchAddressBar.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        searchAddressBar.layer.borderWidth = 1
        searchAddressBar.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
        let radius = searchAddressBar.layer.cornerRadius
        searchAddressBar.layer.shadowPath = UIBezierPath(roundedRect: searchAddressBar.bounds, cornerRadius: radius).cgPath

        let sbTextField = searchAddressBar.value(forKey: "searchField") as? UITextField
        sbTextField?.delegate = self
        sbTextField?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sbTextField?.placeholder = "點此輸入地址"
        sbTextField?.leftView = UIImageView(image:UIImage(named: "tabBar_icon_?"))
        sbTextField?.leftView?.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        sbTextField?.font?.withSize(10)
        sbTextField?.becomeFirstResponder()  //直接開始編輯
        
        
//        if  MapViewController.selectedPlace?.formattedAddress != ""{
//            sbTextField?.text = MapViewController.selectedPlace?.formattedAddress
//        }
        
    }
    
    func backToController(address: String){

        let aheadController = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2])
        
        switch aheadController {
        case is MapViewController:
            if let controller = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController{
                navigationController?.pushViewController(controller, animated: false)
            }
            return
        case is AddNoteViewController:
            searchViewControllerDelegate?.goToAddNoteViewController(address: address,houseName:  noteHouseName)
            navigationController?.popViewController(animated: false)
            return
            
        default:
            return
        }
        
    }
    
    
    //點擊關閉鍵盤
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}



extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Update the GMSAutocompleteTableDataSource with the search text.
        tableDataSource.sourceTextHasChanged(searchText)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.frame = CGRect(x: 0, y: searchAddressBar.frame.minY, width: screenSize.width, height: 370)
        
        tableView.layer.cornerRadius = 10
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        backToController(address: textField.text ?? "")
        return true
    }
    
    
    
    
}

extension SearchViewController: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        tableView.reloadData()
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        tableView.reloadData()
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        MapViewController.selectedPlace =  place
        backToController(address: place.formattedAddress!)
    }
    
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // Handle the error.
        print("Error: \(error.localizedDescription)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}

extension SearchViewController:AddNoteViewControllerDelegate{
    func reloadNoteData() {
    }
    
    func sendHouseName(houseName: String) {  
        self.noteHouseName = houseName
    }
}
