//
//  ViewController.swift
//  WebImageColorCode
//
//  Created by developer on 7/28/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imgRef: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       self.decoration()
    }

    
    func decoration(){
//        imgRef.sd_setImage(
//            with: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvLr-3dLsa1F3oVJkRfyNCcKu5ZLfefZfge3xLPMJzRV4e52m7Gw"),
//            placeholderImage:  UIImage(named: ""),
//            options: [SDWebImageOptions.progressiveDownload],
//            completed: { (image, err, cacheType, url) in
//
//        })
        let possition = CGPoint(x: 100, y: 200)
        let colorName:UIColor = self.getPixelColor(self.imgRef.image!,possition)
        
        let mainColorCheck = self.isWhiteText(hexString: colorName.toHexNewString)
        if  mainColorCheck {
           self.view.layer.backgroundColor = UIColor.white.cgColor
            
        } else {
              self.view.layer.backgroundColor = UIColor.black.cgColor
        }
        

        print("Color name=", colorName.toHexNewString)
    }
    
    func isWhiteText(hexString: String) -> Bool {
        let color = UIColor.color(fromHexString: hexString)
        
        let red = color.redValue * 255
        let green = color.greenValue * 255
        let blue = color.blueValue * 255
        
        // https://en.wikipedia.org/wiki/YIQ
        // https://24ways.org/2010/calculating-color-contrast/
        let yiq = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        return yiq < 192
    }
    
    
    func getPixelColor(_ image:UIImage, _ point: CGPoint) -> UIColor {
        let cgImage : CGImage = image.cgImage!
        guard let pixelData = CGDataProvider(data: (cgImage.dataProvider?.data)!)?.data else {
            return UIColor.clear
        }
        let data = CFDataGetBytePtr(pixelData)!
        let x = Int(point.x)
        let y = Int(point.y)
        let index = Int(image.size.width) * y + x
        let expectedLengthA = Int(image.size.width * image.size.height)
        let expectedLengthRGB = 3 * expectedLengthA
        let expectedLengthRGBA = 4 * expectedLengthA
        let numBytes = CFDataGetLength(pixelData)
        switch numBytes {
        case expectedLengthA:
            return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data[index])/255.0)
        case expectedLengthRGB:
            return UIColor(red: CGFloat(data[3*index])/255.0, green: CGFloat(data[3*index+1])/255.0, blue: CGFloat(data[3*index+2])/255.0, alpha: 1.0)
        case expectedLengthRGBA:
            return UIColor(red: CGFloat(data[4*index])/255.0, green: CGFloat(data[4*index+1])/255.0, blue: CGFloat(data[4*index+2])/255.0, alpha: CGFloat(data[4*index+3])/255.0)
        default:
            // unsupported format
            return UIColor.clear
        }
    }
    
    


}


extension UIColor {
    var toHexNewString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}

public extension UIColor {
    public static func color(fromHexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        let hexint = Int(colorInteger(fromHexString: fromHexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    private static func colorInteger(fromHexString: String) -> UInt32 {
        var hexInt: UInt32 = 0
        let scanner: Scanner = Scanner(string: fromHexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    var redValue: CGFloat{
        return cgColor.components! [0]
    }
    
    var greenValue: CGFloat{
        return cgColor.components! [1]
    }
    
    var blueValue: CGFloat{
        return cgColor.components! [2]
    }
    
    var alphaValue: CGFloat{
        return cgColor.components! [3]
    }
    var isWhiteText: Bool {
        let red = self.redValue * 255
        let green = self.greenValue * 255
        let blue = self.blueValue * 255
        let yiq = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        return yiq < 192
    }
}


