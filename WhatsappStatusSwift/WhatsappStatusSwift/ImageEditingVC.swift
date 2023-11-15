//
//  ImageEditingVC.swift
//  WhatsappStatusSwift
//
//  Created by Hassan Jillani Farooqi on 15/11/2023.
//

import UIKit
import Photos

class ImageEditingVC: UIViewController , UITextFieldDelegate {

    @IBOutlet var top_view_image: UIView!
    @IBOutlet var slider_view: UISlider!
        
    @IBOutlet var lbl_english: UITextField!
    @IBOutlet var viewForColor: UIView!
    
    var panGestureEnglish = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLoadsMethod()
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        let curColor = slider.color
        self.lbl_english.textColor = curColor
    }
    
    func viewLoadsMethod() {
                      
        let colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
        colorSlider.frame = CGRect(x: 10, y: 0, width: self.view.bounds.size.width - 36, height: 31)
        colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: .valueChanged)

        viewForColor.addSubview(colorSlider)
        
        slider_view.minimumValue = 10
        slider_view.maximumValue = 38
        
        lbl_english.text = "edit this text"
        lbl_english.sizeToFit()
        lbl_english.delegate = self
        
        addPanGestureToEnglish()

        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.tapEnglish(sender:)))
        lbl_english.addGestureRecognizer(tap1)

    }

    @objc func tapEnglish(sender:UITapGestureRecognizer) {
   
        slider_view.value = Float(self.lbl_english.font?.pointSize ?? 18)

        self.lbl_english.becomeFirstResponder()
    }
  
    func addPanGestureToEnglish() {
        
        panGestureEnglish = UIPanGestureRecognizer(target: self, action: #selector(self.dragEngLbl(_:)))
        lbl_english.isUserInteractionEnabled = true
        lbl_english.addGestureRecognizer(panGestureEnglish)
        
    }
    @objc func dragEngLbl(_ sender:UIPanGestureRecognizer){
        
        self.view.endEditing(true)
        
        let translation = sender.translation(in: self.top_view_image)
        
        lbl_english.center = CGPoint(x: lbl_english.center.x + translation.x, y: lbl_english.center.y + translation.y)
        
        if(lbl_english.frame.origin.x < 5) {
            lbl_english.frame.origin.x = 5
        }
        if(lbl_english.frame.origin.y < 5) {
            lbl_english.frame.origin.y = 5
        }
        let bottomDistance = top_view_image.frame.size.height - (lbl_english.frame.size.height + lbl_english.frame.origin.y)
        if(bottomDistance < 5) {
            lbl_english.frame.origin.y = top_view_image.frame.size.height - lbl_english.frame.size.height - 5
        }
        let rightDistance = top_view_image.frame.size.width - (lbl_english.frame.size.width + lbl_english.frame.origin.x)
        if(rightDistance < 5) {
        
            lbl_english.frame.origin.x = top_view_image.frame.size.width - lbl_english.frame.size.width - 5
        }
        sender.setTranslation(CGPoint.zero, in: self.top_view_image)
    }
    
    @IBAction func fontSliderDrag(_ sender: UISlider) {
                
        self.view.endEditing(true)
        lbl_english.font = UIFont.systemFont(ofSize: CGFloat(sender.value))
        
        let width = lbl_english.frame.size.width/2
        lbl_english.sizeToFit()
        let width1 = lbl_english.frame.size.width/2
        
        lbl_english.frame.origin.x = (width - width1) + lbl_english.frame.origin.x
        
        if(lbl_english.frame.size.width > top_view_image.frame.size.width) {
            lbl_english.frame.size.width = top_view_image.frame.size.width - 10
            lbl_english.frame.origin.x = 5
        }
        
        let ar_X = lbl_english.frame.origin.x
        let ar_W = lbl_english.frame.size.width
        
        let topWidth = self.view.frame.size.width
        
        let arLblFrame = ar_X + ar_W + 5
        if(arLblFrame > topWidth) {
            lbl_english.frame.origin.x = topWidth - ar_W - 5
        }
        if(ar_X < 5)
        {
            lbl_english.frame.origin.x = 5
        }
        let ar_H = lbl_english.frame.size.height
        let ar_Y = lbl_english.frame.origin.y
        
        let topHeight = self.top_view_image.frame.size.height
        
        let bottomDistance = topHeight - (ar_H + ar_Y + 5)
        if(bottomDistance < 5) {
            lbl_english.frame.origin.y = topHeight - ar_H - 5
        }
    }

    //MARK:- Texrtfield delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.sizeToFit()
        fixEngLbl()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        textField.sizeToFit()
        fixEngLbl()
        
        // make sure the result is under 16 characters
        return updatedText.count <= 28
    }
    
    func fixEngLbl() {
        let ar_X = lbl_english.frame.origin.x
        let ar_W = lbl_english.frame.size.width
        
        let topWidth = self.view.frame.size.width
        
        let arLblFrame = ar_X + ar_W + 5
        if(arLblFrame > topWidth) {
            lbl_english.frame.origin.x = topWidth - ar_W - 5
            if(lbl_english.frame.origin.x < 5) {
                lbl_english.frame.origin.x = 5
                lbl_english.frame.size.width = self.view.frame.size.width - 10
            }
        }
        
        let ar_H = lbl_english.frame.size.height
        let ar_Y = lbl_english.frame.origin.y
        
        let topHeight = self.top_view_image.frame.size.height
        
        let bottomDistance = topHeight - (ar_H + ar_Y + 5)
        if(bottomDistance < 5) {
            lbl_english.frame.origin.y = topHeight - ar_H - 5
        }
    }
   
    @IBAction func onShareClick(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        
        UIImageWriteToSavedPhotosAlbum(self.top_view_image.takeScreenshot(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

        
    }

    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
          if let error = error {
              // we got back an error!
              let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
              ac.addAction(UIAlertAction(title: "OK", style: .default))
              present(ac, animated: true)
          } else {
              let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
              ac.addAction(UIAlertAction(title: "OK", style: .default))
              present(ac, animated: true)
          }
      }
}



extension UIView {
    
    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}
