//
//  FilterViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/27.
//

import UIKit
import TTGTagCollectionView

protocol FilterViewControllerDelegate : AnyObject{
    func getHouseFilterData(value: [String])
    func getBadData(value: [String])
}

enum FiliterOption{
        case HouseYear
        case Price
        case HouseType
        case Bad
}
//enum FiliterOption{
//    case HouseYear(_ option: HouseYearOption)
//    case Price(_ option: PriceOption)
//    case HouseType(_ option: HouseTypeOption)
//    case Bad(_ option: BadOption)
//
//    enum HouseYearOption: String{
//        case NoLimit = "不限"
//        case Year5Down = "5年以下"
//    }
//
//    enum PriceOption: String{
//        case NoLimit = "不限"
//        case Ping50Down = "50坪以下"
//    }
//
//    enum HouseTypeOption: String{
//        case NoLimit = "不限"
//        case Apartment = "公寓"
//    }
//
//    enum BadOption: String{
//        case NoLimit = "不限"
//        case Factory = "工廠"
//    }
//
//    func optionStr() -> String{
//        switch self {
//        case .HouseType(<#T##option: HouseTypeOption##HouseTypeOption#>):
//            <#code#>
//        case .Price(<#T##option: PriceOption##PriceOption#>):
//            <#code#>
//        case .HouseType(<#T##option: HouseTypeOption##HouseTypeOption#>):
//            <#code#>
//        case .Bad(<#T##option: BadOption##BadOption#>):
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
    
//    func intToString(index: Int) -> String{
//        switch index {
//        case 0:
//            return "不限"
//        case 1:
//            switch self {
//            case .HouseYear:
//                return "5年以下"
//            case .Price:
//                return "50萬坪以下"
//            case .HouseType:
//                return "住宅大樓"
//            case .Bad:
//                return "殯葬場所"
//            }
//        default:
//            switch self {
//            case .HouseYear:
//                <#code#>
//            default:
//                <#code#>
//            }
//        }
//    }
//}


class FilterViewController: PresentBottomVC , TTGTextTagCollectionViewDelegate{
      
    static var filterString : [String] = []
    
    override var controllerHeight: CGFloat {
        return screenSize.height*10/11
    }
    
    let screenSize = UIScreen.main.bounds.size
    
    weak var filterVeiwControllerDelegate: FilterViewControllerDelegate?
    

    var currentLB: UILabel!
    
    static var yearCVBool = [Bool](repeating: false, count: 7)
    static var priceCVBool = [Bool](repeating: false, count: 7)
    static var typeCVBool = [Bool](repeating: false, count: 6)
    static var badCVBool = [Bool](repeating: false, count: 8)
     
    var yearResultStr : [String] = []
    var priceResultStr : [String] = []
    var typeResultStr : [String] = []
    var badResultStr : [String] = []
    
    var yearTags = ["不限","5年以下","5-10年","10-20年","20-30年","30-40年","40年以上"]
    var priceTags = ["不限","50萬/坪以下","50-70萬/坪","70-80萬/坪","80-100萬/坪","100-200萬/坪","120萬/坪以上"]
    var typeTags = ["不限","住宅大樓","透天厝","公寓","華廈","商辦"]
    var badTags = ["不限","殯葬場所","變電所","工廠","凶宅","基地台","宮廟","加油站"]
    
    let yearCV = TTGTextTagCollectionView()
    let priceCV = TTGTextTagCollectionView()
    let typeCV = TTGTextTagCollectionView()
    let badCV = TTGTextTagCollectionView()

    
    
//    @IBOutlet weak var yearCV: UICollectionView!
//    @IBOutlet weak var priceCV: UICollectionView!
//    @IBOutlet weak var typeCV: UICollectionView!
//    @IBOutlet weak var badCV: UICollectionView!
    
    
    @IBOutlet weak var cityLB: UILabel!
    @IBOutlet weak var regionLB: UILabel!
    @IBOutlet weak var cityLittleView: littleView!
    @IBOutlet weak var regionLittleView: littleView!
    

    @IBAction func xMarkOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkMarkOnClick(_ sender: Any) {
        
        filterVeiwControllerDelegate?.getBadData(value: changeBoolToStringArr(option: .Bad, boolArr: FilterViewController.badCVBool))
        
        dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func cityBtnOnclick(_ sender: Any) {
        
        currentLB = cityLB
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "CityViewController") as? CityViewController {
            popoverController.cities = CityList.city
            
            popoverController.cityVeiwControllerDelegate = self
            //設定以 popover 的效果跳轉
            popoverController.modalPresentationStyle = .popover
            //設定popover的來源視圖
            popoverController.popoverPresentationController?.sourceView = self.cityLittleView
            //下面註解掉的這行可以指定箭頭指的座標
            popoverController.popoverPresentationController?.sourceRect = cityLittleView.bounds
            popoverController.popoverPresentationController?.delegate = self
            
            //設定popover視窗大小
            popoverController.preferredContentSize = CGSize(width: 100, height: 400)
            //跳轉頁面
            present(popoverController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func regionBtnOnclick(_ sender: Any) {
        currentLB = regionLB
        //找到popoverview所在的storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //找到popoverview的class
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "CityViewController") as? CityViewController {
            
            if let cityName = cityLB.text {
                popoverController.cities = CityList.region[cityName] ?? []
            }
            
            popoverController.cityVeiwControllerDelegate = self
            //設定以 popover 的效果跳轉
            popoverController.modalPresentationStyle = .popover
            //設定popover的來源視圖
            popoverController.popoverPresentationController?.sourceView = self.regionLittleView
            //下面註解掉的這行可以指定箭頭指的座標
            popoverController.popoverPresentationController?.sourceRect = regionLittleView.bounds
            popoverController.popoverPresentationController?.delegate = self
            
            //設定popover視窗大小
            popoverController.preferredContentSize = CGSize(width: 110, height: 400)
            //跳轉頁面
            present(popoverController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var yearsLB: UILabel!
    @IBOutlet weak var priceLB: UILabel!
    @IBOutlet weak var typeLB: UILabel!
    @IBOutlet weak var badLB: UILabel!
   
    var maxHouseAge = ""
    var minHouseAge = ""
    var maxPerPrice = ""
    var minPerPrice = ""
    var lowriseApartment = ""
    var highriseApartment = ""
    var midriseApartment = ""
    var townhouse = ""
    var businessOffice = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        initButton()
        
//        var tagStr = FiliterOption.HouseType(.Apartment)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.addSubview(yearCV)
        scrollView.addSubview(priceCV)
        scrollView.addSubview(typeCV)
        scrollView.addSubview(badCV)
        yearCV.frame = CGRect(x: yearsLB.frame.origin.x, y: yearsLB.frame.maxY+10, width: view.frame.size.width, height: priceLB.frame.maxY-yearsLB.frame.maxY)
        
        priceCV.frame = CGRect(x: priceLB.frame.origin.x, y: priceLB.frame.maxY+10, width: view.frame.size.width, height: typeLB.frame.maxY-priceLB.frame.maxY)
        
        typeCV.frame = CGRect(x: typeLB.frame.origin.x, y: typeLB.frame.maxY+10, width: view.frame.size.width,height:badLB.frame.maxY-typeLB.frame.maxY )
        
        badCV.frame = CGRect(x: badLB.frame.origin.x, y:  badLB.frame.maxY+10, width: view.frame.size.width,height:350 )
    }
    
    func initButton(){

        yearCV.alignment = .left
        yearCV.delegate = self
//        yearCV.selectionLimit = 1 //只能單選
        yearCV.verticalSpacing = 15


        priceCV.alignment = .left
        priceCV.delegate = self
        //        priceCV.selectionLimit = 1

        typeCV.alignment = .left
        typeCV.delegate = self
        //        typeCV.selectionLimit = 1
        typeCV.verticalSpacing = 15

        badCV.alignment = .left
        badCV.delegate = self
        //        typeCV.selectionLimit = 1
        badCV.verticalSpacing = 15


        //
        //        view.addSubview(yearCV)
        //        view.addSubview(priceCV)
        //        view.addSubview(typeCV)
        //
        let config = TTGTextTagConfig()
        config.exactHeight = 32
        config.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        config.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        config.textFont.withSize(11)

        config.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        config.borderWidth = 1
        config.cornerRadius = 15

        config.selectedBackgroundColor = #colorLiteral(red: 0.9404650927, green: 0.9530046582, blue: 0.7407100797, alpha: 1)
        config.selectedTextColor = #colorLiteral(red: 0.2047225535, green: 0.6589326859, blue: 0.5873903632, alpha: 1)
        config.selectedBorderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        config.selectedBorderWidth = 1
        config.selectedCornerRadius = 15

        let config2 = TTGTextTagConfig()
        config2.exactHeight = 32
        config2.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        config2.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        config2.textFont.withSize(11)

        config2.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        config2.borderWidth = 1
        config2.cornerRadius = 15

        config2.selectedBackgroundColor = #colorLiteral(red: 0.9404650927, green: 0.9530046582, blue: 0.7407100797, alpha: 1)
        config2.selectedTextColor = #colorLiteral(red: 0.2047225535, green: 0.6589326859, blue: 0.5873903632, alpha: 1)
        config2.selectedBorderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        config2.selectedBorderWidth = 1
        config2.selectedCornerRadius = 15

        let yearConfig = config
        yearConfig.exactWidth = screenSize.width/4.8
        let priceConfig = config2
        priceConfig.exactWidth = screenSize.width/3.5


        yearCV.addTags(["不限","5年以下","5-10年","10-20年","20-30年","30-40年","40年以上"], with: yearConfig)



         
    priceCV.addTags(["不限","50萬/坪以下","50-70萬/坪","70-80萬/坪","80-100萬/坪","100-200萬/坪","120萬/坪以上"], with: priceConfig )

        typeCV.addTags(["不限","住宅大樓","透天厝","公寓","華廈","商辦"], with: yearConfig)

        badCV.addTags(["不限","殯葬場所","變電所","工廠","凶宅","基地台",
                       "宮廟","加油站"], with: yearConfig)

        FilterViewController.yearCVBool[0] = true
        yearCV.setTagAt(0, selected: true)
        FilterViewController.priceCVBool[0] = true
        priceCV.setTagAt(0, selected: true)
        FilterViewController.typeCVBool[0] = true
        typeCV.setTagAt(0, selected: true)
        FilterViewController.badCVBool[0] = true
        badCV.setTagAt(0, selected: true)
        
        
        if  FilterViewController.badCVBool[0]{
            for index in 1...FilterViewController.badCVBool.count-1{
                FilterViewController.badCVBool[index] = false
                badCV.setTagAt(UInt(index), selected: FilterViewController.badCVBool[Int(index)] )

            }
        }else{
            for index in 0...FilterViewController.badCVBool.count-1{
                badCV.setTagAt(UInt(index), selected: FilterViewController.badCVBool[Int(index)] )
            }
        }

    }
    
    func changeBoolToStringArr(option : FiliterOption, boolArr: [Bool]) -> [String]{
        switch option{
        
        case .HouseYear:
            for index in 0..<boolArr.count{
                if boolArr[index]{
                    yearResultStr.append(intToString(option: .HouseYear, index: index))
                }
            }
            return   yearResultStr
        case .Price:
            for index in 0..<boolArr.count{
                if boolArr[index]{
                    priceResultStr.append(intToString(option: .Price, index: index))
                }
            }
            return   priceResultStr
        case .HouseType:
            for index in 0..<boolArr.count{
                if boolArr[index]{
                    typeResultStr.append(intToString(option: .HouseType, index: index))
                }
            }
            return   typeResultStr
        case .Bad:
            for index in 0..<boolArr.count{
                if boolArr[index]{
                    badResultStr.append(intToString(option: .Bad, index: index))
                }
            }
            
            print("--------------- \(badResultStr)")
            return   badResultStr
        }
    }
    
    
    func intToString(option : FiliterOption, index:Int)->String{
        
        switch option{
        
        case .HouseYear:
            switch index{
            case 0:
                return  ""
            case 1:
                return ""
            case 2:
                return "substation"
            case 3:
                return "factory"
            case 4:
                return  "hauntedHouse"
            case 5:
                return  "baseStation"
            case 6:
                return "temple"
            default:
                return  ""
            }
           
        case .Price:
            switch index{
            case 0:
                return  ""
            case 1:
                return "funeral"
            case 2:
                return "substation"
            case 3:
                return "factory"
            case 4:
                return  "hauntedHouse"
            case 5:
                return  "baseStation"
            case 6:
                return "temple"
            default:
                return  ""
            }
        case .HouseType:
            switch index{
            case 0:
                return ""
            case 1:
                return "funeral"
            case 2:
                return "substation"
            case 3:
                return "factory"
            case 4:
                return  "hauntedHouse"
            case 5:
                return  "baseStation"
            default:
                return  ""
            }
        case .Bad:
            switch index{
            case 0:
                return  ""
            case 1:
                return "funeral"
            case 2:
                return "substation"
            case 3:
                return "factory"
            case 4:
                return  "hauntedHouse"
            case 5:
                return  "baseStation"
            case 6:
                return "temple"
            case 7:
                return "gasStation"
            default:
                return  ""
            }
        }
    
    }
    
    
//    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTapTag tagText: String!, at index: UInt, currentSelected: Bool, tagConfig config: TTGTextTagConfig!) -> Bool {
//
//
//        for i in 0..<FilterViewController.badCVBool.count{
//            if !currentSelected {
//
//            }
//        }
//
//        if currentSelected {
//            return false
//        }
//        return false
//    }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        

        //按鈕邏輯
        FilterViewController.badCVBool[Int(index)] = !FilterViewController.badCVBool[Int(index)]
        
        if textTagCollectionView == badCV{
            if FilterViewController.filterString.count == 0{
                FilterViewController.filterString.append(chineseToEng(type: tagText))
//                FilterViewController.selectedString.append(tagText)
            }else{
                for i in 0...FilterViewController.filterString.count-1{

                    //以下為按鈕按完之後
                    if FilterViewController.filterString[i] == tagText && !selected {
                        FilterViewController.filterString.remove(at: i)
//                        FilterViewController.selectedString.remove(at: i)
                        break;
                    }else if  FilterViewController.filterString[i] != tagText && selected {
                        FilterViewController.filterString.append(chineseToEng(type: tagText))
//                        FilterViewController.selectedString.append(tagText)
                        break;
                    }

                }
            }
        }
        
//        if textTagCollectionView == badCV{
//            if filterString.count == 0{
//               filterString.append(chineseToEng(type: tagText))
////                FilterViewController.selectedString.append(tagText)
//                print("從零開始＋＋＋＋＋＋")
//                print("新增")
//            }else{
//                for i in 0...filterString.count-1{
//
//                    //以下為按鈕按完之後
//                    if filterString[i] == tagText && selected {
//                        filterString.remove(at: i)
////                        FilterViewController.selectedString.remove(at: i)
//                        print("移除")
//                        break;
//                    }else if  filterString[i] != tagText && selected {
//                        filterString.append(chineseToEng(type: tagText))
////                        FilterViewController.selectedString.append(tagText)
//                        print("新增")
//                        break;
//                    }
//
//                }
//            }
//        }
        
        
             switch textTagCollectionView{
                    case yearCV:
            
                        switch index {
                        case 0:
                            yearCV.setTagAt(0, selected: true)
                            maxHouseAge = "100000000"
                            minHouseAge = "0"
                        case 1:
                            yearCV.setTagAt(1, selected: true)
                            maxHouseAge = "5"
                            minHouseAge = "0"
                        case 2:
                            yearCV.setTagAt(2, selected: true)
                            maxHouseAge = "10"
                            minHouseAge = "5"
                        case 3:
                            yearCV.setTagAt(3, selected: true)
                            maxHouseAge = "20"
                            minHouseAge = "10"
                        case 4:
                            yearCV.setTagAt(4, selected: true)
                            maxHouseAge = "30"
                            minHouseAge = "20"
                        case 5:
                            yearCV.setTagAt(5, selected: true)
                            maxHouseAge = "40"
                            minHouseAge = "30"
                        case 6:
                            yearCV.setTagAt(6, selected: true)
                            maxHouseAge = "100000000"
                            minHouseAge = "40"
                        default:
                            maxHouseAge = "100000000"
                            minHouseAge = "0"
                        }
            
                    case priceCV:
                      
                        switch index{
                        case 0:
                            maxPerPrice = "10000000000"
                            minPerPrice = "0"
                        case 1:
                            maxPerPrice = "500000"
                            minPerPrice = "0"
                        case 2:
                            maxPerPrice = "700000"
                            minPerPrice = "500000"
                        case 3:
                            maxPerPrice = "800000"
                            minPerPrice = "700000"
                        case 4:
                            maxPerPrice = "10000000"
                            minPerPrice = "800000"
                        case 5:
                            maxPerPrice = "20000000"
                            minPerPrice = "10000000"
                        case 6:
                            maxPerPrice = "100000000000"
                            minPerPrice = "1200000"
                        default:
                            maxHouseAge = "100000000000"
                            minHouseAge = "0"
                        }
                    case typeCV:
                     
                        switch index {
                        case 0:
                           break
                        case 1:
                            lowriseApartment = typeTags[Int(index)]
                        case 2:
                            highriseApartment = typeTags[Int(index)]
                        case 3:
                            midriseApartment = typeTags[Int(index)]
                        case 4:
                            townhouse = typeTags[Int(index)]
                        case 5:
                            businessOffice = typeTags[Int(index)]
                        default:
                           break
                        }
            
                    case badCV:
                        switch index{
                        case 0:
                           break
                        case 1:
                          "  lowriseApartment = typeTags[indexPath.row]"
                        case 2:
                            "  lowriseApartment = typeTags[indexPath.row]"
                        case 3:
                            "  lowriseApartment = typeTags[indexPath.row]"
                        case 4:
                            "  lowriseApartment = typeTags[indexPath.row]"
                        case 5:
                            "  lowriseApartment = typeTags[indexPath.row]"
                        case 6:
                            "  lowriseApartment = typeTags[indexPath.row]"
                        case 7:
                            "  lowriseApartment = typeTags[indexPath.row]"
                        default:
                           break
                        }
                    default:
                        break
                    }
            
                }
      
   
        
//    if  FilterViewController.badCVBool[0]{
//        //按下不限後讓其他按鈕取消選取
//        for index in 1..<FilterViewController.badCVBool.count{
//            FilterViewController.badCVBool[index] = false
//            badCV.setTagAt(UInt(index), selected: FilterViewController.badCVBool[Int(index)] )
//        }
//    }
//
//    if  FilterViewController.typeCVBool[0]{
//        for index in 1..<FilterViewController.typeCVBool.count{
//            FilterViewController.typeCVBool[index] = false
//            typeCV.setTagAt(UInt(index), selected: FilterViewController.typeCVBool[Int(index)] )
//        }
//    }
//
//    else{
//        if textTagCollectionView == badCV{
//            badCV.setTagAt(index, selected: FilterViewController.badCVBool[Int(index)] )
//
//        }
//    }
        


//        print("!!!!!!!!!!!! \(badCV)")
//        print("&&&&&&&&&&&&&&&&  \(FilterViewController.badCVBool)")
//        print("˙˙˙˙˙˙˙˙˙˙˙˙˙˙˙   \(badResultStr)")
       
        
//                if textTagCollectionView == badCV{
//                    if FilterViewController.filterString.count == 0{
//                        FilterViewController.filterString.append(chineseToEng(type: tagText))
//        //                FilterViewController.selectedString.append(tagText)
//                    }else{
//                        for i in 0...FilterViewController.filterString.count-1{
//
//                            //以下為按鈕按完之後
//                            if FilterViewController.filterString[i] == tagText && !selected {
//                                FilterViewController.filterString.remove(at: i)
//        //                        FilterViewController.selectedString.remove(at: i)
//                                break;
//                            }else if  FilterViewController.filterString[i] != tagText && selected {
//                                FilterViewController.filterString.append(chineseToEng(type: tagText))
//        //                        FilterViewController.selectedString.append(tagText)
//                                break;
//                            }
//
//                        }
//                    }
//                }
//                if textTagCollectionView == badCV{
//                    if filterString.count == 0{
//                       filterString.append(chineseToEng(type: tagText))
//        //                FilterViewController.selectedString.append(tagText)
//                        print("從零開始＋＋＋＋＋＋")
//                        print("新增")
//                    }else{
//                        for i in 0...filterString.count-1{
//
//                            //以下為按鈕按完之後
//                            if filterString[i] == tagText && selected {
//                                filterString.remove(at: i)
//        //                        FilterViewController.selectedString.remove(at: i)
//                                print("移除")
//                                break;
//                            }else if  filterString[i] != tagText && selected {
//                                filterString.append(chineseToEng(type: tagText))
//        //                        FilterViewController.selectedString.append(tagText)
//                                print("新增")
//                                break;
//                            }
//
//                        }
//                    }
//                }



//
//                print("FilterViewController.filterString.count   \(filterString.count)")
//                print("FilterViewController.selectedString.count   \(FilterViewController.selectedString.count)")
//
//                print("..................\( filterString)")
    
    
    
    
    
        func chineseToEng(type:String) -> String{
            switch type{
            case "殯葬場所":
                return "funeral"
            case "工廠":
                return "factory"
            case "宮廟":
                return "temple"
            case "加油站":
                return "gasStation"
            case "基地台":
                return  "baseStation"
            case "變電所":
                return "subStation"
            case "凶宅":
                return "hauntedHouse"
            default:
                Array a = [String]
                return ""
            }
        }
}
//
//extension FilterViewController:UICollectionViewDelegate,UICollectionViewDataSource{
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch collectionView{
//        case yearCV:
//            return yearTags.count
//        case priceCV:
//            return priceTags.count
//        case typeCV:
//            return typeTags.count
//        case badCV:
//            return badTags.count
//        default:
//            return 0
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
////        //選過的陣列
////        var choosedStr = dataSource.chooseTagViewControllerChosenTags(self)
//        switch collectionView{
//        case yearCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yearCell", for: indexPath) as! FilterCollectionViewCell
//            cell.yearLB.text = yearTags[indexPath.row]
//
//        case priceCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "priceCell", for: indexPath) as! FilterCollectionViewCell
//            cell.priceLB.text = priceTags[indexPath.row]
//        case typeCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! FilterCollectionViewCell
//            cell.typeLB.text = typeTags[indexPath.row]
//        case badCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badCell", for: indexPath) as! FilterCollectionViewCell
//            cell.badLB.text = badTags[indexPath.row]
//        default:
//            break
//        }
//
//        return UICollectionViewCell()
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch collectionView{
//        case yearCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yearCell", for: indexPath) as! FilterCollectionViewCell
//
//            switch indexPath.row {
//            case 0:
//                maxHouseAge = "100000000"
//                minHouseAge = "0"
//            case 1:
//                maxHouseAge = "5"
//                minHouseAge = "0"
//            case 2:
//                maxHouseAge = "10"
//                minHouseAge = "5"
//            case 3:
//                maxHouseAge = "20"
//                minHouseAge = "10"
//            case 4:
//                maxHouseAge = "30"
//                minHouseAge = "20"
//            case 5:
//                maxHouseAge = "40"
//                minHouseAge = "30"
//            case 6:
//                maxHouseAge = "100000000"
//                minHouseAge = "40"
//            default:
//                maxHouseAge = "100000000"
//                minHouseAge = "0"
//            }
//
//        case priceCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "priceCell", for: indexPath) as! FilterCollectionViewCell
//            switch indexPath.row {
//            case 0:
//                maxPerPrice = "10000000000"
//                minPerPrice = "0"
//            case 1:
//                maxPerPrice = "500000"
//                minPerPrice = "0"
//            case 2:
//                maxPerPrice = "700000"
//                minPerPrice = "500000"
//            case 3:
//                maxPerPrice = "800000"
//                minPerPrice = "700000"
//            case 4:
//                maxPerPrice = "10000000"
//                minPerPrice = "800000"
//            case 5:
//                maxPerPrice = "20000000"
//                minPerPrice = "10000000"
//            case 6:
//                maxPerPrice = "100000000000"
//                minPerPrice = "1200000"
//            default:
//                maxHouseAge = "100000000000"
//                minHouseAge = "0"
//            }
//        case typeCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! FilterCollectionViewCell
//
//            switch indexPath.row {
//            case 0:
//               break
//            case 1:
//                lowriseApartment = typeTags[indexPath.row]
//            case 2:
//                highriseApartment = typeTags[indexPath.row]
//            case 3:
//                midriseApartment = typeTags[indexPath.row]
//            case 4:
//                townhouse = typeTags[indexPath.row]
//            case 5:
//                businessOffice = typeTags[indexPath.row]
//            default:
//               break
//            }
//
//        case badCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badCell", for: indexPath) as! FilterCollectionViewCell
//            cell.badLB.text = badTags[indexPath.row]
////            switch indexPath.row {
////            case 0:
////               break
////            case 1:
////                lowriseApartment = typeTags[indexPath.row]
////            case 2:
////                highriseApartment = typeTags[indexPath.row]
////            case 3:
////                midriseApartment = typeTags[indexPath.row]
////            case 4:
////                townhouse = typeTags[indexPath.row]
////            case 5:
////                businessOffice = typeTags[indexPath.row]
////            case 6:
////                businessOffice = typeTags[indexPath.row]
////            case 7:
////                businessOffice = typeTags[indexPath.row]
////            default:
////               break
////            }
//        default:
//            break
//        }
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
//        switch collectionView{
//        case yearCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yearCell", for: indexPath) as! FilterCollectionViewCell
//            cell.yearLB.text = yearTags[indexPath.row]
//
//        case priceCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "priceCell", for: indexPath) as! FilterCollectionViewCell
//            cell.priceLB.text = priceTags[indexPath.row]
//        case typeCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! FilterCollectionViewCell
//            cell.typeLB.text = typeTags[indexPath.row]
//        case badCV:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badCell", for: indexPath) as! FilterCollectionViewCell
//            cell.badLB.text = badTags[indexPath.row]
//        default:
//            break
//        }
//
//    }
//
//
//}


//管理ＣollectionView Cell大小
//extension  FilterViewController: UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        switch collectionView{
//        case yearCV:
//            return CGSize(width: (Global.screenSize.width/4 - 4), height: 20)
//        case priceCV:
//            return CGSize(width: (Global.screenSize.width/3 - 4), height: 20)
//        case typeCV:
//            return CGSize(width: (Global.screenSize.width/4 - 4), height: 20)
//        case badCV:
//            return CGSize(width: (Global.screenSize.width/4 - 4), height: 20)
//        default:
//            return CGSize(width: 40, height: 20)
//        }
//
//
//    }
//
//
//    //collectionView內間距
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        let vPadding = CGFloat(5.0)
//        let hPadding = CGFloat(5.0)
//
//        //格子居左對齊
//        if collectionView.numberOfItems(inSection: section) == 0 {
//            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//
//            return UIEdgeInsets(top: vPadding, left: hPadding, bottom: vPadding, right: (hPadding + collectionView.frame.width) - flowLayout.itemSize.width)
//        }
//
//        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//    }
//
//    //cell左右間距
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 5.0
//    }
//
//
//    //cell上下間距
//    func collectionView(_ collectionView: UICollectionView, layout
//                            collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//
//
//}

extension FilterViewController : UIPopoverPresentationControllerDelegate{
    //IOS會自動偵測是iphone還是ipad，如果是iphone的話預設popover會是全螢幕，加上這個func以後會把預設的關閉，照我們寫的視窗大小彈出
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension FilterViewController : CityViewControllerDelegate{
    func cellOnclick(value: String) {
        currentLB.text = value
        currentLB.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}





