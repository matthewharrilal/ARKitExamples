//
//  SmartCamera.swift
//  ObjectDetection
//
//  Created by Matthew Harrilal on 3/12/18.
//  Copyright © 2018 Matthew Harrilal. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import Vision

class SmartCameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var probabiltyOfItemLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We are setting the camera up here
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        
        // If we are making a capture session then we have to get an input
        // Setting the caputre device to be a video on iphone
        guard let captureDevice = try? AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice!) else {return}
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            // perhaps check the error
            
            guard let results = finishedRequest.results as? [VNClassificationObservation] else {return}
            
            guard let firstObservation = results.first else {return}
            
            print(firstObservation.identifier, firstObservation.confidence)
            
            DispatchQueue.main.async {
                self.itemNameLabel.text = firstObservation.identifier
                self.probabiltyOfItemLabel.text = String(firstObservation.confidence)
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
