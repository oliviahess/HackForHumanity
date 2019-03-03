//
//  ViewController.swift
//  Hackathon 2019 2
//
//  Created by Hanzhe Chen on 3/2/19.
//  Copyright © 2019 Hanzhe Chen. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

//class ViewController: UIViewController {
//
//    @IBOutlet weak var sceneView: ARSCNView!
//
//    let config = ARWorldTrackingConfiguration()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
//        config.planeDetection = .vertical
//        sceneView.session.run(config)
//
//        sceneView.delegate = self
//
////        let capsuleNode = SCNNode(geometry: SCNCapsule(capRadius: 0.03, height: 0.1))
////        capsuleNode.position = SCNVector3(0.1, 0.1, -0.1)
////        capsuleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue //1
////
////        capsuleNode.eulerAngles = SCNVector3(0,0,Double.pi/2)//2
////        sceneView.scene.rootNode.addChildNode(capsuleNode)
//    }
//
//
//
//    func createWallNode(anchor:ARPlaneAnchor) ->SCNNode{
////        let wallNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.z), height: CGFloat(anchor.extent.y)))
//        let wallNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)))
//
//        wallNode.position=SCNVector3(anchor.center.x,0,anchor.center.z)
////        wallNode.position=SCNVector3(anchor.center.x,0,anchor.center.z)
//        wallNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "MonaLisa")
//        wallNode.geometry?.firstMaterial?.isDoubleSided = true
//        wallNode.eulerAngles = SCNVector3(0,0,0)
//
//        return wallNode
//    }
//
//}
//
//extension ViewController:ARSCNViewDelegate{
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//        let planeNode = createWallNode(anchor: planeAnchor)
//        node.addChildNode(planeNode)
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//        node.enumerateChildNodes { (node, _) in
//            node.removeFromParentNode()
//        }
//        let planeNode = createWallNode(anchor: planeAnchor)
//        node.addChildNode(planeNode)
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
//        guard let _ = anchor as? ARPlaneAnchor else {return}
//        node.enumerateChildNodes { (node, _) in
//            node.removeFromParentNode()
//        }
//    }
//}

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var grids = [Grid]()
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    let config = ARWorldTrackingConfiguration()
    let paintingArray = ["MonaLisa","black_grey_woman","black_white_abstract","blue_men_in_boat", "blue_orange_dog", "blue_white_lighthouse", "blue_woman_in_water", "brown_green_giraffe", "green_blue_coast", "green_mountains", "multicolored_canal", "multicolored_girl_face", "orange_blue_sunset", "orange_yellow_restaurant", "pink_green_brown_trees", "purple_pink_mountains", "red_orange_forest"]
    
    var arrayIndex = 0
    lazy var imageName = paintingArray[arrayIndex]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        sceneView.addGestureRecognizer(leftSwipe)
        sceneView.addGestureRecognizer(rightSwipe)
        
//        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
//        sceneView.addGestureRecognizer(swipeGestureRecognizer)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
//        sceneView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
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
    
    func setGridName(name: String) {
        for grid in self.grids {
            grid.setImageName(imageName: name)
        }
    }
    
    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            arrayIndex = (arrayIndex + 1) % 17
            imageName = paintingArray[arrayIndex]
            setGridName(name: imageName)
        }
        
        if sender.direction == .right {
            arrayIndex = (arrayIndex + 17 - 1) % 17 //if uInt
            imageName = paintingArray[arrayIndex]
            setGridName(name: imageName)
        }
    }
    
//    @objc func tapped(gesture: UITapGestureRecognizer) {
//        // Get 2D position of touch event on screen
//        let touchPosition = gesture.location(in: sceneView)
//
//        // Translate those 2D points to 3D points using hitTest (existing plane)
//        let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
//
//        // Get hitTest results and ensure that the hitTest corresponds to a grid that has been placed on a wall
//        guard let hitTest = hitTestResults.first, let anchor = hitTest.anchor as? ARPlaneAnchor, let gridIndex = grids.index(where: { $0.anchor == anchor }) else {
//            return
//        }
//        addPainting(hitTest, grids[gridIndex])
//    }
//
//    func addPainting(_ hitResult: ARHitTestResult, _ grid: Grid) {
//        // 1.
//        let planeGeometry = SCNPlane(width: 0.2, height: 0.35)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: imageName)
//        planeGeometry.materials = [material]
//
//        // 2.
//        let paintingNode = SCNNode(geometry: planeGeometry)
//        paintingNode.transform = SCNMatrix4(hitResult.anchor!.transform)
//        paintingNode.eulerAngles = SCNVector3(paintingNode.eulerAngles.x + (-Float.pi / 2), paintingNode.eulerAngles.y, paintingNode.eulerAngles.z)
//        paintingNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
//
//        sceneView.scene.rootNode.addChildNode(paintingNode)
//        grid.removeFromParentNode()
//    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        //remove grid first
        
        let grid = Grid(anchor: planeAnchor, imageName: imageName)
        self.grids.append(grid)
//        node.replaceChildNode(grids.popLast()!, with: grid)
//        grid.removeFromParentNode()
        node.addChildNode(grid)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
        
        node.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        let newGrid = Grid(anchor: planeAnchor, imageName: imageName)
        self.grids.append(newGrid)
        node.addChildNode(newGrid)

//        let existingGrid = self.grids.filter { grid in
//            return grid.anchor.identifier == planeAnchor.identifier
//            }.first
//
//        guard let foundGrid = existingGrid else {
//            return
//        }
//
//        foundGrid.update(anchor: planeAnchor)

    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else {return}
        node.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
}

extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paintingArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if let imgVw = cell.viewWithTag(1) as? UIImageView{
            imgVw.image = UIImage(named: paintingArray[indexPath.row])
            resizeImageInCell(cell, isSelected: imageName == paintingArray[indexPath.row])
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = self.collectionView.cellForItem(at: indexPath)
        
        resizeImageInCell(cell!, isSelected: true)
        
        imageName = paintingArray[indexPath.row]
        collectionView.reloadData()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = self.collectionView.cellForItem(at: indexPath)
        
        resizeImageInCell(cell!, isSelected: false)
    }
    
    func resizeImageInCell(_ cell:UICollectionViewCell, isSelected:Bool){
        
        cell.layer.cornerRadius = isSelected ? 35 : 20
        cell.layer.masksToBounds = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return imageName == paintingArray[indexPath.row] ? CGSize(width: 70, height: 70) : CGSize(width: 40, height: 40)
    }
    
}
