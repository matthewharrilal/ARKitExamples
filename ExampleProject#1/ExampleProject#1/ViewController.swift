//
//  ViewController.swift
//  ExampleProject#1
//
//  Created by Matthew Harrilal on 3/12/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate letting the view know that we want the scene view and the overall view to be able to communicate
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration tracks the postion of your phone relative to the plain
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session when the view disappears we want the view to disappear
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // First thing that we have to do is grab our touch
        guard let myTouch = touches.first else {return}
        
        // Returns us information about a real world surface found in examing a point in the device
        let result = sceneView.hitTest(myTouch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        print("This is the result from the scene view \(result)")
        
        // So from what we can inference that this does is that when we make this hit result variable it is grabbing the last result that is found when there is a tap
        guard let hitResult = result.last else {return}
        
        // Retrieves the coordinates of the object last tapped relative to the world
        let hitTransform = SCNMatrix4(hitResult.worldTransform)
        
        // Getting the x,y, and z coordinates from the last tap
        let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        // Creating the ball at that hit vector's position
        createBall(postion: hitVector)
        
    }
    
    func createBall(postion: SCNVector3) {
        // This function is going to create our ball
        let myBallShape = SCNSphere(radius: 0.06)
        
        // We are setting the geometry of the ballnode to be the shape of the ball
        let myBallNode = SCNNode(geometry: myBallShape)
        
        
        
        // Setting the ballNodes position to the position of the tap when the user taps on the ball
        myBallNode.position = postion
        myBallNode.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
    
        
        // Adds nodes to an array allows us to have multiple nodes on the screen
        sceneView.scene.rootNode.addChildNode(myBallNode)
    }

  
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
