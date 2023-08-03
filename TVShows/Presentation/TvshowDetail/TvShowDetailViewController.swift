//
//  TvShowDetailViewController.swift
//  TVShows
//
//  Created by Christos Kaktsis on 11/5/23.
//

import UIKit

class TvShowDetailViewController: UIViewController {
    
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var summaryView: UIView!
    
    @IBOutlet weak var webSiteLabel: UILabel!
    
    var coordinator: Coordinator?
    
    var viewModel: TvShowDetailViewModel
    init(viewModel: TvShowDetailViewModel){
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    private func setup(){
        setImageLabel()
        nameLabel.text = viewModel.name
        setUpSummaryView()
        ratingLabel.text = "⭐️ \(viewModel.rating)"
        statusLabel.text = "\(viewModel.status)"
        startDateLabel.text = "started on: \(viewModel.started)"
        
        
        setUpWebSiteLabel()
        
    }
    
    private func setUpWebSiteLabel(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(TvShowDetailViewController.tapFunction))
                webSiteLabel.isUserInteractionEnabled = true
                webSiteLabel.addGestureRecognizer(tap)
    }
   
    private func setUpSummaryView() {
        summaryView.layer.cornerRadius = 8
        summaryView.backgroundColor = UIColor(hex: "#003566ff")
        summaryView.alpha = 0
        
        let data = Data(viewModel.summary.utf8)
        let attributes = getAttributes()
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            let changeString = NSAttributedString(string: attributedString.string, attributes: attributes)
            descLabel.attributedText = changeString
        }
        animateSummaryView()
    }
    
    private func animateSummaryView(){
        UIView.animate(withDuration: 0.5, delay: 0.2) {[weak self] in
            guard let self = self else{
                return
            }
            self.summaryView.alpha = 1
        }
    }
    private func getAttributes() -> [NSAttributedString.Key: Any]{
        let font = UIFont.systemFont(ofSize: 16)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.white
        shadow.shadowBlurRadius = 9

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        return attributes
    }
    
    private func setImageLabel(){
        showImageView.layer.cornerRadius = 8
        viewModel.fetchImage(url: viewModel.imageUrl) { data in
            if let imageData = data {
                self.showImageView.image = UIImage(data: imageData)
            }
            else {
                self.showImageView.image = UIImage(named: "exclamationmark.icloud")
            }
        }
    }
}

extension TvShowDetailViewController: Coordinating{
    @objc
        func tapFunction(sender:UITapGestureRecognizer) {
            if let url = viewModel.officialSiteUrl {
                coordinator?.eventOccured(with: .Go_TO_WEB(URL: url))
            }
            
        }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
   convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
