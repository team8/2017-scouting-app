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

class QRCodeViewController : ViewController, QRCodeReaderViewControllerDelegate {
    
    @IBOutlet weak var ScanButton: UIButton!
    
    @IBOutlet weak var ScanView: UIView!
    
    
    override func viewDidLoad() {
        ScanView.isHidden = true
    }
    
    func hasReceivedQRData(with result: String) {
        ScanButton.setTitle("Re-Scan QR Code", for: .normal)
        var realizedData : ScannedMatchData = ScannedMatchData(from: result)
        ScanView.isHidden = false
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
