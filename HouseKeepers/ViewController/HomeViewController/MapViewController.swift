//
//  MapViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/10.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils

protocol MapViewControllerDelegate : AnyObject{
    func goToAddNoteViewController(house: HouseModel)
}


var userDefault = UserDefaults()

class MapViewController: UIViewController {
    
    //    建立獲得定位資訊的變數，並設置屬性。
    //    設置委任方法以獲得定位資訊。
    //    向使用者取得定位權限。
    //    設置應用程式需要的定位服務規則。
    //    開始與結束更新定位位置。
    
    weak var mapViewControllerDelegate : MapViewControllerDelegate?
    
    //搜尋結果
    public static var searchAddressNow: String?
    @IBOutlet weak var searchAddressBar: MapSearchBar!
    
    private var placesClient : GMSPlacesClient! //放置客戶端
    var myLocationManager: CLLocationManager!//位置管理器,用來檢查位置，在使用前須先要求權限提示
    var clusterManager : GMUClusterManager! //叢集管理器
    
    // 喜愛點陣列
    var likelyPlaces: [GMSPlace] = []
    // 目前選到的地方
    public static var selectedPlace: GMSPlace?
    
    //    let infoMarker = GMSMarker()
    
    var maxHouseAge = ""
    var minHouseAge = ""
    var maxPerPrice = ""
    var minPerPrice = ""
    var houseType : [String] = []
    
    var circle: GMSCircle?
    var myLocationCircle : GMSCircle?
    var screenSize =  UIScreen.main.bounds.size
    
    var markerDataList = MarkerDataList.instance()
    var landMarkList = LandMarkList.instance()
    
    @IBOutlet weak var arOnClick: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    //searchViewControllerDelegate?.goToAddNoteViewController()
    
    
    
    @IBAction func filterBtnOnClick(_ sender: Any) {
        //找到popoverview所在的storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        mapView.clear()
        //找到popoverview的class
        if let popoverController = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController {
            
            popoverController.filterVeiwControllerDelegate = self
            
            presentBottom(popoverController)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getToken()
        
        //隱藏導航欄
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        initSearchBar()
        mapView.delegate = self
        mapView.addSubview(arOnClick)

        // 建立 CLLocationManager 來做定位
        myLocationManager = CLLocationManager()
        myLocationManager.requestWhenInUseAuthorization()  //  使用app期間向使用者請求權限
        
        if CLLocationManager.locationServicesEnabled(){
            
            // distanceFilter是距離過濾器，為了減少對定位裝置的輪詢次數，位置的改變不會每次都去通知委託，而是在移動了足夠的距離時才通知委託程式
            myLocationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters // update data after move ten meters
            
            // 定位方式：取得自身定位位置的精確度（這邊設為最好）
            myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
            //設置委任對象
            myLocationManager.delegate = self
        }
        
        placesClient = GMSPlacesClient.shared()
        
        //     mapView.mapType = .satellite //設定為衛星顯示模式
        mapView.isIndoorEnabled = false //要不要顯示室內圖
        mapView.accessibilityElementsHidden = false //設為顯示輔助功能
        //把地圖往上移點,避免定位按紐被遮住
        mapView.padding = UIEdgeInsets(top:0, left:0, bottom:20, right:0)
        
        mapView.settings.compassButton = true    //指南針
        mapView.isMyLocationEnabled = true //默認情況下，地圖上不會顯示任何位置數據。可以通過在GMSMapView上設置myLocationEnabled來啟用藍色的“我的位置”點和指南針方向。
        mapView.settings.myLocationButton = true  //我的位置藍色圖標
        
        mapView.setMinZoom(5, maxZoom: 20)//設置地圖最小和最大縮放
        //       mapView.isHidden = true
        
        //定位點周圍的圓圈
        myLocationCircle = GMSCircle(position: CLLocationCoordinate2D(latitude: 25, longitude: 121), radius: 1000)
        myLocationCircle?.fillColor = UIColor(displayP3Red: 0, green: 0.4, blue: 0.3, alpha: 0.2)
        myLocationCircle?.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        myLocationCircle?.map = mapView
        
        
        //設定相機顯示的經緯度和縮放
        let camera =  GMSCameraPosition.camera(      //相機定義地圖的方向
            withLatitude: Double(MapViewController.selectedPlace?.coordinate.latitude ?? 0),
            longitude: Double(MapViewController.selectedPlace?.coordinate.longitude ?? 0),
            zoom: 15.0) //zoom數值越小代表拉越遠看
        mapView.camera = camera
        
        
        
        // 生成 Cluster Manager 用來管理地圖上的 Cluster Item
        
        //提供應用程序邏輯，以提取要在不同縮放級別使用的群集圖標。
        let iconGenerator = GMUDefaultClusterIconGenerator()
        
        
        //指定一種算法，該算法確定標記如何聚集，例如要包括在同一聚類中的標記之間的距離。
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        
        //提供用於處理地圖上群集圖標的實際呈現的應用程序邏輯。
        let renderer = GMUDefaultClusterRenderer(mapView: self.mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        self.clusterManager = GMUClusterManager(map: self.mapView, algorithm: algorithm, renderer: renderer)
        
        //在GMUClusterManager實例上設置地圖委託。
        self.clusterManager.setDelegate(self, mapDelegate: self)
        
        //               初始化地圖上的 標記叢集
        self.initMapViewMarker()
        
        //"temple","gasStation","hospital","mrt","carPark","policeStation"
        //        self.landMarkfilter(types: ["gasStation","temple","factory","funeral","subStation"])
        
        
//        self.landMarkfilter(types:  FilterViewController.filterString)
        
        
        //        print("11111111  viewDidLoad")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 首次使用 向使用者詢問定位自身位置權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // 取得定位服務授權
            myLocationManager.requestWhenInUseAuthorization()//使用App期間才需要定位權限
            
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
        
        // 使用者已經同意定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // 開始定位自身位置
            myLocationManager.startUpdatingLocation()
        }
        
        // 使用者已經拒絕定位自身位置權限
        else if CLLocationManager.authorizationStatus() == .denied {
            // 提示可至[設定]中開啟權限
            let alertController = UIAlertController(
                title: "定位權限已關閉",  message:"如要變更權限，請至 設定 > 隱私權 > 定位服務 開啟",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "確認", style: .default, handler:nil)
            alertController.addAction(okAction)
            self.present(alertController,animated: true, completion: nil)
        }
        
        //            print("222222222  viewDidAppear")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //        print("666666666  viewWillAppear")
    }
    override func viewWillLayoutSubviews() {
        //        print("7777777777  viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        //        print("33333333333  viewDidLayoutSubviews")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 停止定位自身位置
        myLocationManager.stopUpdatingLocation()
        
        //        print("4444444444  viewDidDisappear")
    }
    
    
    private func getTruePricePoint(){
        
        let place = MapViewController.selectedPlace
        let latitude = "\(place?.coordinate.latitude)"
        let longitude = "\(place?.coordinate.longitude)"
        
        ApiHelper.instance().getTruePricePoint(latitude: latitude, longitude:longitude, distanceRange:"0.5", maxHouseAge: "", minHouseAge :"", maxPerPrice: "",  minPerPrice: "",  lowriseAparment:"", highriseAparment: "", midriseAparment: "", townhouse: "", businessOffice:"") {
            
            //不希望閉包內持有self,所以用 weak self
            [weak self] (isSuccess) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (isSuccess){
                print("success")

                weakSelf.markerDataList.getMarkerDatas()
                    .map{ MyMarker(markerData: $0) }
                    .forEach {
                        let item = ClusterItem(markerData: $0.markerData)
                        self?.clusterManager.add(item)
                    }
                self?.clusterManager.cluster()

            }else{
                print("failed")

            }
        }
    }


private func initMapViewMarker() {
    ApiHelper.instance().getByArea(ping:50,range:2){
        //不希望閉包內持有self,所以用 weak self
        [weak self] (isSuccess) in
        guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
            return
        }
        if (isSuccess){
            print("success")
            
            weakSelf.markerDataList.getMarkerDatas()
                .map{ MyMarker(markerData: $0) }
                .forEach {
                    let item = ClusterItem(markerData: $0.markerData)
                    self?.clusterManager.add(item)
                }
            self?.clusterManager.cluster()
            
        }else{
            print("failed")
            
        }
    }
}

func getToken(){
    ApiHelper.instance().login(){
        [weak self] (isSuccess) in
        if (isSuccess){
            print("success")
        }else{
            print("failed")
        }
    }
}

private func initAllMapViewMarker() {
    
    ApiHelper.instance().getAllHouse(){
        [weak self] (isSuccess) in
        guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
            return
        }
        if (isSuccess){
            print("success")
            
            weakSelf.markerDataList.getMarkerDatas()
                .map{ MyMarker(markerData: $0) }
                .forEach {
                    let item = ClusterItem(markerData: $0.markerData)
                    //                        item.markerData.address = $0.markerData.address
                    self?.clusterManager.add(item)
                }
            self?.clusterManager.cluster()
            
        }else{
            print("failed")
            
        }
    }
}


func landMarkfilter(types: [String]){
    landMarkList.clear()
    ApiHelper.instance().getLandMarkByTypes(types: types){
        [weak self] (isSuccess) in
        guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
            return
        }
        if (isSuccess){
            print("success")
            
            weakSelf.landMarkList.getLandMarks()
                //製作嫌惡設施marker
                .map{ LandmarkMarker(landmarkData: $0) }
                .forEach {
                    $0.map = self?.mapView
                }
        }else{
            print("failed")
            
        }
    }
}

    
func getAllLandMark(){
    ApiHelper.instance().getAllLandMark(){
        [weak self] (isSuccess) in
        guard let weakSelf = self else {
            return
        }
        if (isSuccess){
            print("success")
            
            weakSelf.landMarkList.getLandMarks()
                .map{ LandmarkMarker(landmarkData: $0) }
                .forEach {
                    //                        let marker = GMSMarker(position: $0.position)
                    //                        marker.title = $0.landmarkData.name
                    $0.map = self?.mapView
                    
                    
                }
        }else{
            print("failed")
            
        }
    }
}


}



//定位地圖
extension MapViewController :  CLLocationManagerDelegate{
    
    //獲取經緯度
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation : CLLocationCoordinate2D = manager.location?.coordinate else {return}
        
        //陣列中最後回傳的會是最接近於我們當前位置的 CLLocation
        let location = locations.last!
        
        //自動回到定位點
                if  MapViewController.selectedPlace == nil {
                    mapView.animate(toLocation: location.coordinate)
                    mapView.animate(toZoom: 15)
                    
                }
      
        
        myLocationCircle?.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        
        
        //        let zoomLevel =  myLocationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        //           let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
        //                                                 longitude: location.coordinate.longitude,
        //                                                 zoom: 12)
        //
        //           if mapView.isHidden {
        //             mapView.isHidden = false
        //             mapView.camera = camera
        //           } else {
        //             mapView.animate(to: camera)
        //           }
        
        
        print("緯度: \(currentLocation.latitude), 經度: \(currentLocation.longitude)")
        
    }
    
    
    //定位錯誤的話
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


extension MapViewController : GMSMapViewDelegate{
    
    //    //點擊POI(興趣點，大頭針)後的彈出視窗
    //    func mapView(
    //        _ mapView: GMSMapView,
    //        didTapPOIWithPlaceID placeID: String,
    //        name: String,
    //        location: CLLocationCoordinate2D
    //    ) {
    //        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
    //
    //        infoMarker.position = location
    //        infoMarker.title = name
    //
    //        infoMarker.snippet = name
    //        infoMarker.opacity = 0;
    //        infoMarker.infoWindowAnchor.y = 1
    //        infoMarker.map = mapView
    //        mapView.selectedMarker = infoMarker
    //
    //
    //    }
    
    
    //     //點擊地圖空白處，增加點
    //    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    //
    ////        mapView.clear()
    //        let markerData = MarkerData(position: coordinate, title: "1", address: "2")
    //
    //        let item = ClusterItem(markerData:markerData)
    //
    //        clusterManager.add(item)
    //        clusterManager.cluster()
    //
    //    }
    
    //當移動完地圖後觸發
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    //點擊marker事件
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        circle?.map = nil
        
        // center the map on tapped marker
//        MapViewController.selectedPlace = marker.position
        
        mapView.animate(toLocation: marker.position)
        
        // check if a cluster icon was tapped
        if marker.userData is GMUCluster {
            // zoom in on tapped cluster
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            
            print("Did tap cluster")
            return true
        }else if marker.userData is GMUClusterItem{
            
            TruePriceViewController.truePriceCurrentAddress = marker.snippet!

            
            
            //找到popoverview所在的storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //找到popoverview的class
            if let popoverController = storyboard.instantiateViewController(withIdentifier: "TruePriceViewController") as? TruePriceViewController {
                self.presentBottom(popoverController )
            }
            print("Did tap clusterItem")
            return true
        }
        
        //        circle = GMSCircle(position: marker.position, radius: 500)
        //        circle?.fillColor = UIColor(displayP3Red: 0.67, green: 0.67, blue: 0.67, alpha: 0.5)
        //        circle?.map = mapView
        //
        
        print("Did tap a normal marker")
        return false
        
    }
    
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
        
        let placeFields: GMSPlaceField = [.name, .coordinate]
        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { (placeLikelihoods, error) in
            guard error == nil else {
                // TODO: Handle the error.
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            
            guard let placeLikelihoods = placeLikelihoods else {
                print("No places found.")
                return
            }
            
            // Get likely places and add to the list.
            for likelihood in placeLikelihoods {
                let place = likelihood.place
                self.likelyPlaces.append(place)
            }
        }
    }
    
}


extension MapViewController: GMUClusterRendererDelegate {
    
    /// 回傳一標記，此 delegate 可用來控制標記的生命週期。例如:設定標記的座標、圖片等等
    /// - Parameter renderer: _
    /// - Parameter object: _
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        switch object {
        case let clusterItem as ClusterItem:
            let myMarker = MyMarker(markerData: clusterItem.markerData)
            
            myMarker.snippet = clusterItem.markerData.address
            
            myMarker.icon = UIImage(named: "marker_rainbow")
            return myMarker
        default:
            return nil
        }
    }
    
}

// MARK: - GMUClusterManagerDelegate
extension MapViewController: GMUClusterManagerDelegate {
    
    /// 點擊叢集所會觸發的事件
    /// - Parameter clusterManager: _
    /// - Parameter cluster: _
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        print("按了叢集")
        return false
    }
    
    /// 點擊叢集項目所會觸發的事件
    /// - Parameter clusterManager: _
    /// - Parameter clusterItem: _
    func clusterManager(_ clusterManager: GMUClusterManager, didTap clusterItem: GMUClusterItem) -> Bool {
        print("按了叢集項目")
        return false
    }
    
}

extension MapViewController : UIPopoverPresentationControllerDelegate{
    //    如果是iphone的話不會讓popover變成全螢幕
    //     關閉預設的視窗彈出方式
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


extension MapViewController: UISearchBarDelegate ,UITextFieldDelegate{
    
    
    func initSearchBar(){
        
        
        searchAddressBar.delegate = self
        searchAddressBar.backgroundColor = .clear
        searchAddressBar.layer.borderWidth = 1
        searchAddressBar.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        searchAddressBar.layer.cornerRadius = 30
        searchAddressBar.layer.masksToBounds = true
        //        searchAddressBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchAddressBar.layer.shadowOpacity = 0.9
        searchAddressBar.layer.shadowRadius = 30
        searchAddressBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        searchAddressBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchAddressBar.frame.size.height = 46
        //        searchAddressBar.contentInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        
        //        let radius = searchAddressBar.layer.cornerRadius
        //        searchAddressBar.layer.shadowPath = UIBezierPath(roundedRect: searchAddressBar.bounds, cornerRadius: radius).cgPath
        
        
        let sbTextField = searchAddressBar.value(forKey: "searchField") as? UITextField
        sbTextField?.delegate = self
        sbTextField?.frame.origin.x = 20
        sbTextField?.leftView = .none
        sbTextField?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sbTextField?.placeholder = "點此輸入地址"
        sbTextField?.clearButtonMode = .never
        sbTextField?.text = MapViewController.selectedPlace?.formattedAddress
        sbTextField?.font = UIFont.systemFont(ofSize: 13)
        //        sbTextField?.font?.withSize(7)
        //        sbTextField?.attributedPlaceholder = NSAttributedString.init(string: "點此輸入地址", attributes: [NSAttributedString.Key. :  UIFont(name: "boldSystemFont", size: 8)])
        
        //  sbTextField?.isEnabled = false
        sbTextField?.leftView = UIImageView(image:UIImage(named: "tabBar_icon_plus"))
        sbTextField?.leftView?.frame = CGRect(x: 0, y: 0, width: 55, height: 55)

        //        mapView.clear()
        
        // 輸入完地址後在地圖建一個marker
        if let place = MapViewController.selectedPlace {
            let marker = GMSMarker(position: place.coordinate)
            marker.title = MapViewController.selectedPlace?.name
            marker.snippet = MapViewController.selectedPlace?.formattedAddress
            marker.map = mapView
            mapView.animate(toLocation: place.coordinate)
        }
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //跳轉到搜尋頁
        if let controller = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController{
            navigationController?.pushViewController(controller, animated: false)
        }
        return false
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    
}


extension MapViewController : FilterViewControllerDelegate{
    func getHouseFilterData(value: [String]) {
        ""
    }
    
    func getYearData(value: [String]) {
        maxHouseAge = value[0]
        minHouseAge = value[1]
        maxPerPrice = value[2]
        minPerPrice = value[3]
      
    }
    
    func getPriceData(value: [String]) {
        maxPerPrice = value[0]
        minPerPrice = value[1]
    }
    
    func getTypeData(value: [String]) {
        houseType = value
    }
    
    func getBadData(value: [String]) {
        print("0--0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0 \(value)")
        self.landMarkfilter(types: value)
    }
}


