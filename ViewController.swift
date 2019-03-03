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
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
//        tap.numberOfTapsRequired = 1
        let hold = UILongPressGestureRecognizer(target: self, action: #selector(held))
        hold.minimumPressDuration = 1.0
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        sceneView.addGestureRecognizer(leftSwipe)
        sceneView.addGestureRecognizer(rightSwipe)
//        sceneView.addGestureRecognizer(tap)
        sceneView.addGestureRecognizer(hold)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
//    @objc func tapped(sender: UITapGestureRecognizer) {
//        let sceneView = sender.view as! ARSCNView
//        let touchPosition = sender.location(in: sceneView)
//
//        // Translate those 2D points to 3D points using hitTest (existing plane)
//        let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
//
//        // Get hitTest results and ensure that the hitTest corresponds to a grid that has been placed on a wall
//        guard let hitTest = hitTestResults.first, let anchor = hitTest.anchor as? ARPlaneAnchor, let gridIndex = grids.index(where: { $0.anchor == anchor }) else {
//            return
//        }
//
////        removePainting(hitTest, grids[gridIndex])
//    }
    
    @objc func held(sender: UILongPressGestureRecognizer) {
        let sceneView = sender.view as! ARSCNView
        let touchPosition = sender.location(in: sceneView)
        
        // Translate those 2D points to 3D points using hitTest (existing plane)
        let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
        
        // Get hitTest results and ensure that the hitTest corresponds to a grid that has been placed on a wall
        if hitTestResults.isEmpty {
            return
        }
        
        let buyAlert = UIAlertController(title: "Buy this piece", message: "It seems you like this piece just as much as your wall does, would you like to buy it?", preferredStyle: UIAlertController.Style.alert)
        let buyButton = UIAlertAction(title: "Buy", style: UIAlertAction.Style.default) { (action) -> Void in
            let buyViewController = self.storyboard?.instantiateViewController(withIdentifier: "buyViewController")
            self.present(buyViewController!, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
        }
        
        buyAlert.addAction(buyButton)
        buyAlert.addAction(cancelButton)
        
        self.present(buyAlert, animated: true, completion: nil)
    }

    func removePainting(_ hitResult: ARHitTestResult, _ grid: Grid) {
        //does not work properly. need make it so all grids disappear completely.
//        grid.enumerateChildNodes { (node, _) in
//            grid.removeFromParentNode()
//        }
//
//        grids.removeAll()
    }
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
