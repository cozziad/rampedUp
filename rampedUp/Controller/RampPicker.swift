//
//  RampPicker.swift
//  rampedUp
//
//  Created by Anthony Cozzi on 7/20/19.
//  Copyright © 2019 Anthony Cozzi. All rights reserved.
// You can use Unity instead of SceneKit

import UIKit
import SceneKit

class RampPickerVC: UIViewController {

    
    var sceneView: SCNView!
    var size: CGSize!
    weak var rampPlacerVC: rampPlacerVC!
    
    init(size: CGSize){
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tap)
        
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        
        //pipe
        var obj = SCNScene(named: "art.scnassets/pipe.scn")
        var node = obj?.rootNode.childNode(withName: "pipe", recursively: true)
        node?.runAction(rotate)
        node?.scale = SCNVector3Make(0.0012, 0.0012, 0.0012)
        node?.position = SCNVector3Make(0, 0.7, -1)
        scene.rootNode.addChildNode(node!)
        
        //pyramid
        obj = SCNScene(named: "art.scnassets/pyramid.dae")
        node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)
        node?.runAction(rotate)
        node?.scale = SCNVector3Make(0.0028, 0.0028, 0.0028)
        node?.position = SCNVector3Make(0, 0.1, -1)
        scene.rootNode.addChildNode(node!)
        
        //quarter
        obj = SCNScene(named: "art.scnassets/quarter.dae")
        node = obj?.rootNode.childNode(withName: "quarter", recursively: true)
        node?.runAction(rotate)
        node?.scale = SCNVector3Make(0.0028, 0.0028, 0.0028)
        node?.position = SCNVector3Make(0, -0.7, -1)
        scene.rootNode.addChildNode(node!)
        
        preferredContentSize = size
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer){
        let p = gestureRecognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(p, options: [:])
        
        if hitResults.count >= 1{
            let node = hitResults[0].node
            print(node.name!)
            rampPlacerVC.onRampSelected(forRamp: node.name!)
        }
    }
    

}
