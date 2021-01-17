//
//  ListLandmarksViewController.swift
//  ARCoreLocationExample
//
//  Created by Skyler Smith on 2019-01-02.
//  Copyright (c) 2019 Freshworks Studio Inc.. All rights reserved.
//

import UIKit
import ARCoreLocation
import CoreLocation
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils
import ARKit


protocol ListLandmarksRequestable {
    func fetchLandmarks(request: ListLandmarks.FetchLandmarks.Request)
}

protocol ListLandmarksRouteRequestable {
    func showLandmark(withIndex index: Int)
}


class ListLandmarksViewController: UIViewController {

    @IBOutlet weak var btnView: UIView!
    
    @IBAction func backBtnOnclick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let popoverController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            navigationController?.popViewController(animated: false)
        }
    }
    
//    weak var listLandmarksViewControllerDelegate : ListLandmarksViewControllerDelegate?
    
//    var huantedHouse = ""
//    var factory = ""
//    var funeral = ""
//    var temple = ""
//    var baseStation = ""
//    var gasStation = ""
//    var subStation = ""
//
    
    
    @IBOutlet weak var ghostBtn: UIButton!
    
    @IBOutlet weak var factoryBtn: UIButton!
    
    @IBOutlet weak var funeralBtn: UIButton!
    
    @IBOutlet weak var templeBtn: UIButton!
    
    @IBOutlet weak var baseBtn: UIButton!
    
    @IBOutlet weak var gasBtn: UIButton!
    
    @IBOutlet weak var subBtn: UIButton!
    
    
    var searchList : [String] = []

    @IBAction func gostOnclick(_ sender: Any) {
      
        if !ghostBtn.isSelected{
            searchList.append("hauntedHouse")
        }else{
            for i in 0..<searchList.count{
                if searchList[i] == "hauntedHouse"{
                    searchList.remove(at:i)
                    break
                }
            }
        }
        ghostBtn.isSelected = !ghostBtn.isSelected
        print("\(searchList)")
    }
    
    @IBAction func factoryOnclick(_ sender: Any) {
 
        if  !factoryBtn.isSelected{
            searchList.append("factory")
        }else{
            for i in 0..<searchList.count{
                if searchList[i] == "factory"{
                    searchList.remove(at:i)
                    break
                }
            }
        }
      
        factoryBtn.isSelected = !factoryBtn.isSelected
        print("\(searchList)")
      
    }
    @IBAction func funeralOnclick(_ sender: Any) {
        if  !funeralBtn.isSelected{
            searchList.append("funeral")
        }else{
            for i in 0..<searchList.count{
                if searchList[i] == "funeral"{
                    searchList.remove(at:i)
                    break
                }
            }
        }
     
        funeralBtn.isSelected = !funeralBtn.isSelected
        print("\(searchList)")
        
    }

    @IBAction func templeOnclick(_ sender: Any) {
       
        if  !funeralBtn.isSelected{
            searchList.append("temple")
        }else{
            for i in 0..<searchList.count{
                if searchList[i] == "temple"{
                    searchList.remove(at:i)
                    break
                }
            }
        }
        funeralBtn.isSelected = !funeralBtn.isSelected
        print("\(searchList)")
//        listLandmarksViewControllerDelegate?.sendLandmarkList(list: searchList)
    }
    @IBAction func baseStationOnclick(_ sender: Any) {
      
        if   !baseBtn.isSelected{
            searchList.append("baseStation")
        }else{
            for i in 0..<searchList.count{
                if searchList[i] == "baseStation"{
                    searchList.remove(at:i)
                    break
                }
            }
        }
        baseBtn.isSelected = !baseBtn.isSelected
        print("\(searchList)")
//        listLandmarksViewControllerDelegate?.sendLandmarkList(list: searchList)
    }
    @IBAction func gasStationOnclick(_ sender: Any) {
      
          if   !gasBtn.isSelected{
            searchList.append("gasStation")
          }else{
              for i in 0..<searchList.count{
                  if searchList[i] == "gasStation"{
                      searchList.remove(at:i)
                    break
                  }
              }
          }
        gasBtn.isSelected = !gasBtn.isSelected
        print("\(searchList)")
//        listLandmarksViewControllerDelegate?.sendLandmarkList(list: searchList)
    }
    @IBAction func subStationOnclick(_ sender: Any) {
      
        if     !subBtn.isSelected{
            searchList.append("substation")
        }else{
            for i in 0..<searchList.count{
                if searchList[i] == "substation"{
                    searchList.remove(at:i)
                   break
                }
            }
        }
        subBtn.isSelected = !subBtn.isSelected
        print("\(searchList)")
//        listLandmarksViewControllerDelegate?.sendLandmarkList(list: searchList)
    }
    
    
    @IBAction func filterBtnOnclick(_ sender: UIButton) {
//        let alert = UIAlertController(title: "篩選項目", message: "選擇", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "確定", style: .destructive, handler: nil))
//        present(alert, animated: true, completion: nil)
        //duration 動畫執行時間
        //delay 按下按鈕延遲多久執行動畫
        //options
        //animations 動畫執行後的結果
        //completion 執行完動畫做的事
//            .concatenating(CGAffineTransform(translationX: -(Global.screenSize.width+30), y: 0))

        if !filtBtn.isSelected{
        UIView.animate(withDuration: 0.5,
                                delay: 0,
                                options: UIView.AnimationOptions.curveEaseInOut,
                                animations: {self.btnView.transform = CGAffineTransform(translationX: -(Global.screenSize.width+30), y: 0)},
                                completion: nil)
       }else{
        UIView.animate(withDuration: 0.5,
                                delay: 0,
                                options: UIView.AnimationOptions.curveEaseInOut,
                                animations: {self.btnView.transform = CGAffineTransform(translationX: (Global.screenSize.width+30), y: 0)},
                                completion: nil)
       }
        filtBtn.isSelected = !filtBtn.isSelected
    }
    
    @IBOutlet weak var filtBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK: Dependencies
    var interactor: ListLandmarksRequestable?
    var router: ListLandmarksRouteRequestable?
    var landmarker: ARLandmarker!
    var reusableMarker = ListLandmarksItem.fromNib()
    
    // MARK: Constants
    let landmarkKey: String = "model"
    
    // MARK: State
    
    // MARK: View lifecycle
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure Landmarker
        
        btnView.layer.cornerRadius = 15
        btnView.clipsToBounds = true
        
        let interactor = ListLandmarksInteractor()
        let presenter = ListLandmarksPresenter()
        let router = ListLandmarksRouter()
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.displayer = self
        router.viewController = self
        router.dataStore = interactor
        landmarker = ARLandmarker(view: ARSKView(), scene: InteractiveScene(),locationManager:CLLocationManager())
        
        ghostBtn.isSelected = false
        factoryBtn.isSelected = false
        funeralBtn.isSelected = false
        templeBtn.isSelected = false
        baseBtn.isSelected = false
        gasBtn.isSelected = false
        subBtn.isSelected = false
        
        
        
        
        landmarker.delegate = self
        
    
        landmarker.maximumVisibleDistance = 1500// Only show landmarks within 100m from user.
        
        // The landmarker can scale views so that closer ones appear larger than further ones. This scaling is linear
        // from 0 to `maxViewScaleDistance`.
        // For example, with `minViewScale` at `0.5` and `maxViewScaleDistance` at `1000`, a landmark 500 meters away
        // appears at a scale of `0.75`. A landmark 1000 meters or more away appears at a scale of `0.5`. A landmark
        // 0 meters away appears full scale (`1.0`).
        landmarker.minViewScale = 0.4 // Shrink distant landmark views to half size
        landmarker.maxViewScaleDistance = 1500 // Show landmarks 75m or further at the smallest size
        
        landmarker.worldRecenteringThreshold = 20 // Recalculate the landmarks whenever the user moves 30 meters.
        landmarker.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // You'll usually want the best accuracy you can get.
        
        // Show all the landmarks, even when they are overlapping. Another common option is to show just the nearest
        // ones (`.showNearest`). If landmark views overlap, `.showNearest` will hide the landmarks that are further
        // away.
//        landmarker.overlappingLandmarksStrategy = .showAll
        landmarker.overlappingLandmarksStrategy = .showNearest
//        landmarker.beginEvaluatingOverlappingLandmarks(atInterval: 1.0) // Set how often to check for overlapping landmarks.
        
        view.addSubview(landmarker.view)
        view.addSubview(backBtn)
        view.addSubview(filtBtn)
        view.addSubview(btnView)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        landmarker.view.frame = view.bounds
        landmarker.scene.size = view.bounds.size
    }
    
    private func format(distance: CLLocationDistance) -> String {
        return "\(Int(distance))m"
//        return String(format: "%.2f km away", distance / 1000)
    }
}

//extension ListLandmarksViewController: ListLandmarksDisplayer {
//    func displayLandmarks(viewModel: ListLandmarks.FetchLandmarks.ViewModel) {
//        
//        ApiHelper.instance().getARLandMarkByTypes(types: searchList){
//            //不希望閉包內持有self,所以用 weak self
//
//            [weak self] (isSuccess) in
//            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
//                return
//            }
//            if (isSuccess){
//                print("success")
//                
////                weakSelf.places = VictoriaData_Landmarks.landmarks
//                var landmarks =  VictoriaData_Landmarks.landmarks.enumerated().map({ $1.landmark(withIndex: $0) })
////                weakSelf.presenter?.presentLandmarks(response: ListLandmarks.FetchLandmarks.Response(landmarks: landmarks))
//                
//                for landmark in  landmarks {
//                    let user =  weakSelf.landmarker.locationManager.location!
//                    let markView =  weakSelf.reusableMarker
//                    let location = CLLocation(coordinate: landmark.location.coordinate, altitude: user.altitude + 5, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: Date())
//                    markView.set(name: landmark.name, detail: weakSelf.format(distance: user.distance(from: landmark.location)))
//                    weakSelf.landmarker.addLandmark(userInfo: [weakSelf.landmarkKey: landmark], view: markView, at: location, completion: nil)
//                    
//                    print("444444444444444444444 \(landmark)")
//                }
//                
//              
//                
//            }else{
//                print("failed")
//                
//            }
//        }
//    
//    }
//}

extension ListLandmarksViewController: ListLandmarksDisplayer {
    func displayLandmarks(viewModel: ListLandmarks.FetchLandmarks.ViewModel) {
        for landmark in viewModel.landmarks {
            let user = landmarker.locationManager.location!
            let markView = reusableMarker
            let location = CLLocation(coordinate: landmark.location.coordinate, altitude: user.altitude + 5, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: Date())
            markView.set(name: landmark.name, detail: format(distance: user.distance(from: landmark.location)))
            landmarker.addLandmark(userInfo: [landmarkKey: landmark], view: markView, at: location, completion: nil)
        }
    }
}


extension ListLandmarksViewController: ARLandmarkerDelegate {
    
    func landmarkDisplayerIsReady() {
        // Using a VIP cycle here. The interactor will get the landmark data, and `displayLandmarks` will be called when the data is ready.
        interactor?.fetchLandmarks(request: ListLandmarks.FetchLandmarks.Request())
    }
    
    func landmarkDisplayer(_ landmarkDisplayer: ARLandmarker, didTap landmark: ARLandmark) {
        guard let index = landmark.model?.index else {
            return
        }
        router?.showLandmark(withIndex: index)
    }
    
    func landmarkDisplayer(_ landmarkDisplayer: ARLandmarker, willUpdate landmark: ARLandmark, for location: CLLocation) -> UIView? {
        guard let model = landmark.model else {
            return nil
        }
        let markView = reusableMarker
        markView.set(name: model.name, detail: format(distance: location.distance(from: landmark.location)))
        
        return markView
    }
    
    func landmarkDisplayer(_ landmarkDisplayer: ARLandmarker, didFailWithError error: Error) {
        print("Failed! Error: \(error)")
    }
}

extension ARLandmark {
    var model: ListLandmarks.FetchLandmarks.ViewModel.Landmark? {
        return userInfo["model"] as? ListLandmarks.FetchLandmarks.ViewModel.Landmark
    }
}



extension ListLandmarksViewController : ListLandmarksInteractorDataSource{
    func getlandmarkList(_ chooseTagViewController: ListLandmarksInteractor) -> [String] {
        return self.searchList
    }
    
}
