//
//  ARMarkViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/22.
//

//import UIKit
//
//
//
//class ARMarkViewController: UIViewController {
//    
//    
//    var sceneLocationView = SceneLocationView()
//    
//    let coordinate = CLLocationCoordinate2D(latitude: 51.504571, longitude: -0.019717)
//    let location = CLLocation(coordinate: coordinate, altitude: 300)
//    let image = UIImage(named: "pin")!
//
//    let annotationNode = LocationAnnotationNode(location: location, image: image)
//    
//    
//    override func viewDidLoad() {
//      super.viewDidLoad()
//
//      sceneLocationView.run()
//      view.addSubview(sceneLocationView)
//        
//        
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
//        
//        
//        
//    }
//
//    override func viewDidLayoutSubviews() {
//      super.viewDidLayoutSubviews()
//
//      sceneLocationView.frame = view.bounds
//        
// 
//    }
//
//}
//
//
//extension ARMarkViewController : LNTouchDelegate{
//    
//    func annotationNodeTouched(node: AnnotationNode) {
//         // Do stuffs with the node instance
//
//         // node could have either node.view or node.image
//         if let nodeView = node.view{
//             // Do stuffs with the nodeView
//             // ...
//         }
//         if let nodeImage = node.image{
//             // Do stuffs with the nodeImage
//             // ...
//         }
//     }
//
//     func locationNodeTouched(node: LocationNode) {
//         guard let name = node.tag else { return }
//         guard let selectedNode = node.childNodes.first(where: { $0.geometry is SCNBox }) else { return }
//
//         // Interact with the selected node
//     }
//    
//}
//
