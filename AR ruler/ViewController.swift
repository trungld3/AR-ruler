//
//  ViewController.swift
//  AR ruler
//
//  Created by TrungLD on 5/11/20.
//  Copyright © 2020 TrungLD. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    var dotNodes = [SCNNode]()
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Show statistics such as fps and timing information
      
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched")
        if let touchLocation = touches.first?.location(in: sceneView)
        {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
        
        if let hitResult = hitTestResults.first{
            addDot(at : hitResult)
        
    }
        }
    }
    func addDot( at hitResult: ARHitTestResult){
        let dotGeometry = SCNSphere( radius: 0.005)
        let material = SCNMaterial ()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                      hitResult.worldTransform.columns.3.y,
                                      hitResult.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(dotNode)
            
        dotNodes.append(dotNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
        
    }
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
         
        print(start.position)
        print(end.position)
        
        let distance = sqrt(pow(end.position.x - start.position.x, 2) + pow(end.position.y - start.position.y, 2) + pow(end.position.z - start.position.z, 2))
        
        print(abs(distance))

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
   
}
