//
//  QuotesViewController.swift
//  QrCode
//
//  Created by DE NADAI Julien on 29/03/2020.
//  Copyright © 2020 juliendenadai.fr. All rights reserved.
//

import Cocoa
import CoreImage
import AppKit

class QrCodeViewController: NSViewController {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var imgQRCode: NSImageView!
    @IBOutlet weak var qrCodeContent: NSTextField!
    @IBOutlet weak var quit: NSButton!
    
    @IBAction func quit(sender: AnyObject) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func validateText(sender: AnyObject) {
        let text = textField.stringValue
        let size = CGSize(width: 200, height: 200)

        qrCodeContent.stringValue = text
        imgQRCode.image = generateQrCode(forUrl: text, size: size)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let pasteboard = NSPasteboard.general
        if let lastItemInPasteboard = pasteboard.pasteboardItems?.first?.string(forType: .string) {
            qrCodeContent.stringValue = lastItemInPasteboard
            let size = CGSize(width: 200, height: 200)
            imgQRCode.image = generateQrCode(forUrl: lastItemInPasteboard, size: size)
        }
    }
    
    private func generateQrCode(forUrl url: String, size: CGSize) -> NSImage? {
        guard
            let filter = CIFilter(name: "CIQRCodeGenerator"),
            let data = url.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        guard
            let outputImage = filter.outputImage
            else { return nil }
                
        let imageSize = outputImage.extent.size
        let scaleX = size.width / imageSize.width
        let scaleY = size.height / imageSize.height
        let newImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        
        let rep = NSCIImageRep(ciImage: newImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        return nsImage
    }
}

extension QrCodeViewController {
  // MARK: Storyboard instantiation
  static func instantiateController() -> QrCodeViewController {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: "QrCodeViewController") as? QrCodeViewController else {
      fatalError("Why cant i find QrCodeViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
