//
//  AddItemController.swift
//  PanViewApp
//
//  Created by Joel Gil on 11/28/19.
//  Copyright © 2019 Joel Gil. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import AVFoundation

// MARK: - AddItemDelegate Protocol

protocol AddItemDelegate {
    func addItem(item: Item)
}

let categories = ["Blast", "Clothing Women", "Clothing Men", "Clothing Chilren", "Furniture", "Miscellaneous"]
let subCategories = ["Blast", "Shirts", "Pants", "Sweaters", "Jackets/Vests"]
let genders = ["", "Man", "Women"]

var category: String?
var subCategory: String?
var gender: String?

class AddItemController: UIViewController{
    
    // MARK: - Properties
    
    //Add ManagedObject Data Context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Add variable itemdb (used from UITableView
    var itemdb:NSManagedObject!
    
    let defaults: UserDefaults = UserDefaults.standard
    
    var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var movieOutput = AVCaptureMovieFileOutput()
    var videoCaptureDevice : AVCaptureDevice?
    var videoView: UIView = {
        let vi = UIView()
        vi.layer.cornerRadius = 25
        vi.layer.borderWidth = 2
        return vi
    }()
        
    var delegate: AddItemDelegate?
    
    let txtCategory: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select category"
        tf.textAlignment = .left
        tf.layer.borderWidth = 0.5
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let txtSubCategory: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select category"
        tf.textAlignment = .left
        tf.layer.borderWidth = 0.5
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let txtNote: UITextField  = {
        let tf = UITextField ()
        tf.placeholder = "What's new?"
        tf.textAlignment = .left
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 0.5
        tf.translatesAutoresizingMaskIntoConstraints = false
        //tf.isEditable = true
        
        return tf
    }()
    
    let lblCategory: UILabel = {
           let label = UILabel()
           label.text = "Category:"
           label.font = UIFont.systemFont(ofSize: 16 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let lblSelectedStore: UILabel = {
        let label = UILabel()
        label.text = "Selected store:"
        label.font = UIFont.systemFont(ofSize: 16 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblSubCategory: UILabel = {
           let label = UILabel()
           label.text = "Sub Category:"
           label.font = UIFont.systemFont(ofSize: 16 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    let lblNote: UILabel = {
           let label = UILabel()
           label.text = "Comment:"
           label.font = UIFont.systemFont(ofSize: 16 )
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
                
        view.addSubview(txtCategory)
        view.addSubview(txtSubCategory)
        view.addSubview(txtNote)
        
        view.addSubview(lblCategory)
        view.addSubview(lblSubCategory)
        view.addSubview(lblNote)
        view.addSubview(lblSelectedStore)
            

        lblSelectedStore.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblSelectedStore.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300).isActive = true
        
        lblCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -138).isActive = true
        lblCategory.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
               
        txtCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtCategory.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100 ).isActive = true
        txtCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        //txtCategory.inputView =
               
        lblSubCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -122).isActive = true
        lblSubCategory.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
               
        txtSubCategory.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        txtSubCategory.centerYAnchor.constraint(equalTo:  view.centerYAnchor , constant: -50).isActive = true
        txtSubCategory.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
               
        lblNote.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -138).isActive = true
        lblNote.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
               
        txtNote.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtNote.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        txtNote.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
                
        txtCategory.becomeFirstResponder()
        
        if defaults.string(forKey: "store") != nil{
            let _store = UserDefaults.standard.value(forKey: "store")!
            print(_store)
            lblSelectedStore.text = "\(_store) "
        }
        //avCaptureVideoSetUp()
        
    }
    
    //MARK: Configure Navigation Bar
    func configureNavigationBar() {
        
        view.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone)),
                                                    UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.camera, target: self, action: #selector(handleVideo))]
        self.navigationItem.title = "Add an Item"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
       
    }
    
    // MARK: - Video Capture
    func avCaptureVideoSetUp(){
        if let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] {
            for device in devices {
                if device.hasMediaType(AVMediaType.video) {
                    if device .position == AVCaptureDevice.Position.back{
                        videoCaptureDevice = device
                    }
                }
            }
            
            if videoCaptureDevice != nil {
                
                // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
                if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {

                    do {
                        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
                        let input = try AVCaptureDeviceInput(device: captureDevice)

                        // Set the input device on the capture session.
                        captureSession.addInput(input)

                        // Initialize a AVCaptureVideoDataOutput object and set it as the output device to the capture session.
                        let dataOutput = AVCaptureVideoDataOutput()
                        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]

                        dataOutput.alwaysDiscardsLateVideoFrames = true

                        if captureSession.canAddOutput(dataOutput) {
                            captureSession.addOutput(dataOutput)
                        }

                        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
                        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                        previewLayer.frame = self.view.layer.bounds // It may be best to setup an UIView outlet instead of using self.view
                        self.view.layer.addSublayer(previewLayer)

                        // Start video capture.
                        captureSession.startRunning()

                    } catch {
                        // If any error occurs, simply print it out and don't continue any more.
                        print(error)
                        return
                    }
                }
                
                /*
                do {
                    // Add Video Input
                    try self.captureSession.addInput(AVCaptureDeviceInput(device: videoCaptureDevice! ))
                    // Get Audio Device
                    guard let audioInput = AVCaptureDevice.default(for: AVMediaType.video) else { return <#default value#> }
                    //Add Audio Input
                    try self.captureSession.addInput(AVCaptureDeviceInput(device: audioInput))
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    self.videoView.layer.addSublayer(self.previewLayer)
                
                    //Add File Output
                    self.captureSession.addOutput(self.movieOutput)
                    captureSession.startRunning()
                }catch {
                    print(error)
                }
                */
            }
            
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleDone() {
        
        guard let _category = txtCategory.text, txtCategory.hasText else {
            print("Handle error here..")
            return
        }
        
        //let item = Item(fullname: fullname)
        //delegate?.addItem(item: item)
        
        let _store = UserDefaults.standard.value(forKey: "store")!
        
        if (itemdb != nil){
                
           itemdb.setValue(txtCategory.text, forKey: "category")
           itemdb.setValue(txtSubCategory.text, forKey: "subcategory")
           itemdb.setValue(txtNote.text, forKey: "note")
           itemdb.setValue(_store, forKey: "store")
           itemdb.setValue(Date(), forKey: "createdat")
           itemdb.setValue(true, forKey: "status")
           itemdb.setValue(_store as! String, forKey: "store")
                   
       }
       else{
           let entityDescription =
               NSEntityDescription.entity(forEntityName: "Item",in: managedObjectContext)
           
           let item = Item(entity: entityDescription!,
                                 insertInto: managedObjectContext)
           
           item.category = txtCategory.text!
           item.subcategory = txtSubCategory.text!
           item.note = txtNote.text!
           item.status = true
           item.store = _store as? String
           item.createdat = Date()
       }
        
        var error: NSError?
        do {
           try managedObjectContext.save()
        } catch let error1 as NSError {
           error = error1
           print("\(error)")
        }
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleVideo() {
        //self.dismiss(animated: true, completion: nil)
        print("record the video...")
        
        if movieOutput.isRecording {
            movieOutput.stopRecording()
        } else {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.mov")
            try? FileManager.default.removeItem(at: fileUrl)
            movieOutput.startRecording(to: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bounds: CGRect = videoView.layer.bounds
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.bounds = bounds
        previewLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
}

// MARK: — AVCaptureFileOutputRecordingDelegate
 
extension AddItemController : AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // save video to camera roll
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!){
        // save video to camera roll
        if error == nil {
        UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
        }
    }
}
