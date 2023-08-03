//
//  TvShowTableViewCell.swift
//  TVShows
//
//  Created by Christos Kaktsis on 11/5/23.
//

import UIKit
import Foundation

class TvShowTableViewCell: UITableViewCell {

    @IBOutlet weak var cellFrame: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    func setup(tvShow: TvShow, image: Data?){
        ratingLabel.attributedText = attributedString( String(tvShow.rating ?? 0) )
        nameLabel.text = tvShow.name
        if let data = image {
            thumbnail.image = UIImage(data: data)
        }
        else {
            thumbnail.image = UIImage(named: "exclamationmark.icloud")
        }
        thumbnail.layer.cornerRadius = 8
        
        self.backgroundColor = UIColor(hex: "#001d3dff")
        
        cellFrame.backgroundColor = UIColor(hex: "#003566ff")
        
        cellFrame.layer.cornerRadius = 8
        
    
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func attributedString(_ name: String) -> NSAttributedString{
        let font = UIFont.systemFont(ofSize: 16)
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(hex: "#ffd60aff")
        shadow.shadowBlurRadius = 9

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor(hex: "#ffd60aff"),
            .shadow: shadow
        ]
        let theString = NSAttributedString(string: name, attributes: attributes)
        
        return theString
    }
    
}
