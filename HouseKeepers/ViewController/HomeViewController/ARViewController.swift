//
//  ViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/10.
//

import UIKit
import SceneKit
import ARKit
import GooglePlaces

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       


        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true  //在螢幕上顯示目前的fbs和時間等資訊
        sceneView.autoenablesDefaultLighting = true //預設光照
        
         
        // Create a new scene  新增3Ｄ物件
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
    
        // Set the scene to the view  將物件圖片設給ARSCNView來顯示
        sceneView.scene = scene
        
//        //加這行會跑出固定在原位的立方體，代表原點供多物件間比較相對位置
//        sceneView.debugOptions = [ ARSCNDebugOptions.showWorldOrigin,ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration 追蹤裝置的位置與方位，也可以經由裝置的相機來偵測現實世界的地平面
        let configuration = ARWorldTrackingConfiguration()
        
//        configuration.planeDetection = [.horizontal] //plane物件設為水平

        // Run the view's session
        sceneView.session.run(configuration) //運行組態設定檔
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause() //停止追蹤
    }
    
    
//    func addBox(){
//        //SCNBox: 畫出帶有矩形邊和可選倒角的框（正方形 長方形 圓形）單位為公尺
//        let box = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0)
//
//        //SCNNode: 虛擬物件和相機的幾何資訊。x軸：左右 y軸：上下 z軸：前後
//        let boxNode = SCNNode()
//        boxNode.geometry = box
//        boxNode.position = SCNVector3(0,0,-0.2)
//        let scene = SCNScene()
//        scene.rootNode.addChildNode(boxNode)
//        sceneView.scene = scene
//    }


    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
