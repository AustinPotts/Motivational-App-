//
//  ViewController.swift
//  MotivateMe
//
//  Created by Austin Potts on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var quote: UIImageView!
    
    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    var shareQuote: Quote?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {allowed, error in
            if allowed {
                self.configureAlerts()
            }
        }
        
    }

    
    func updateQuoate(){
        guard let backgroundImageName = images.randomElement() else {
            fatalError("Unable to read an image")
        }
        
        background.image = UIImage(named: backgroundImageName)
        
        guard let selectedQuote = quotes.randomElement() else {
            fatalError("unable to read quote")
        }
        
        shareQuote = selectedQuote
        
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
        let renderer = UIGraphicsImageRenderer(bounds: quoteRect.insetBy(dx: -30, dy: -30), format: format)
        
        quote.image = renderer.image { ctx in
            for i in 1...5 {
                ctx.cgContext.setShadow(offset: .zero, blur: CGFloat(i) * 2, color: UIColor.black.cgColor)
                str.draw(in: quoteRect)
            }
           
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateQuoate()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateQuoate()
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        
        guard let quote = shareQuote else { fatalError("Attemptng to share a non existing quote") }
        
        let shareMessage = "\"\(quote.text)\" - \(quote.author)"
        
        let ac = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = sender
        
        present(ac, animated: true)
        
    }
    
    func configureAlerts(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        
        let shuffle = quotes.shuffled()
        
        for i in 1...7 {
            let content = UNMutableNotificationContent()
            content.title = "Inner Peace"
            content.body = shuffle[i].text
            
            var dateComponents = DateComponents()
            dateComponents.day = i
            
            if let alertDate = Calendar.current.date(byAdding: dateComponents, to: Date()) {
                var alertComponents = Calendar.current.dateComponents([.day, .month, .year], from: alertDate)
                alertComponents.hour = 10
                
               // let trigger = UNCalendarNotificationTrigger(dateMatching: alertComponents, repeats: false) This is how you would do it for Daily Notifications
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i) * 5, repeats: false) //This is a test
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    if let error = error {
                        print(error)
                    }
                }
                
            }
        }
    }
    
}

