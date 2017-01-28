//
//  TSQRCodeViewController.swift
//  2017 Scouter
//
//  Created by Robert Selwyn on 12/20/16.
//  Copyright © 2016 Team 8. All rights reserved.
//

import Foundation
import UIKit
import QRCodeReader
import AVFoundation

class QRCodeViewController : ViewController, QRCodeReaderViewControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var ScanButton: UIButton!
    
    @IBOutlet weak var ScanView: UIView!
    
    @IBOutlet var QRCodeREsults: UITableView!
    
    var realizedData : ScannedMatchData!
    
    override func viewDidLoad() {
        ScanView.isHidden = true
        QRCodeREsults.dataSource = self
        QRCodeREsults.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QRCell", for: indexPath) 
        cell.backgroundView?.backgroundColor = UIColor.blue
        let field = Array(realizedData.scoringElements.keys)[indexPath.section]
        let data = realizedData.scoringElements[field]
        print("RUNNING \(indexPath.section)")
        cell.textLabel?.text = field + ": " + data!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ScannedMatchData.CURRENT_DATA_ELEMENTS_NUMBER
    }

    
    func hasReceivedQRData(with result: String) {
        ScanButton.setTitle("Re-Scan QR Code", for: .normal)
        realizedData = ScannedMatchData(from: result)
        ScanView.isHidden = false
        QRCodeREsults.reloadData()
    }
    
    
    // MARK: QR Code Reading
    
    lazy var reader = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        $0.showTorchButton = true
    })
    
    @IBAction func scanAction(_ sender: AnyObject) {
        if QRCodeReader.supportsMetadataObjectTypes() {
            reader.modalPresentationStyle = .formSheet
            reader.delegate               = self
            reader.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                    self.hasReceivedQRData(with: result.value)
                }
            }
            
            present(reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }

    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true)
    }
    
}
