//
//  ViewController.swift
//  MotivateMe
//
//  Created by Austin Potts on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var quote: UIImageView!
    
    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func updateQuoate(){
        guard let backgroundImageName = images.randomElement() else {
            fatalError("Unable to read an image")
        }
        
        background.image = UIImage(named: backgroundImageName)
        
        guard let selectedQuote = quotes.randomElement() else {
            fatalError("unable to read quote")
        }
        
        let insetAmount = CGFloat(250)
        let drawBounds = quote.bounds.inset(by: UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount))
        
       var quoteRect = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        
        
        var fontSize: CGFloat = 120
        var font: UIFont!
        
        var attrs: [NSAttributedString.Key: Any]!
        var str: NSAttributedString!
        
        while true {
            font = UIFont(name: "Georgia-Italic", size: fontSize)!
            
            attrs = [.font: font!, .foregroundColor: UIColor.white]
            
            str = NSAttributedString(string: selectedQuote.text, attributes: attrs)
            
            quoteRect = str.boundingRect(with: CGSize(width: drawBounds.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
            
            if quoteRect.height > drawBounds.height {
                fontSize -= 4
            } else {
                break
            }
            
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(bounds: quoteRect, format: format)
        
        quote.image = renderer.image { ctx in
            ctx.cgContext.setShadow(offset: .zero, blur: 10, color: UIColor.black.cgColor)
            str.draw(in: quoteRect)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateQuoate()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateQuoate()
    }
}

