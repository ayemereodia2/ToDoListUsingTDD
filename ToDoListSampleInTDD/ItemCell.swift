//
//  ItemCell.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import UIKit

class ItemCell: UITableViewCell {

   static let cellId = "ItemCell"
    
    let titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let locationLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 8)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    
    override init(style: UITableViewCell.CellStyle = .default, reuseIdentifier:String? = "ItemCell") {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)

        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 5).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: locationLabel.topAnchor, constant: 5).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(with item:ToDoItem, checked: Bool = false){
        
        if checked {
            let attributedString = NSAttributedString(string: item.location?.name ?? "", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            titleLabel.attributedText = attributedString
            locationLabel.text = nil
            dateLabel.text = nil
            
        }else {
            titleLabel.text = item.title
            locationLabel.text = item.location?.name ?? ""
            if let item = item.timestamp {
                let date = Date(timeIntervalSince1970: item) 
                let timeStamp = dateFormatter.string(from: date)
                dateLabel.text = timeStamp
            }
            
        }
        
        
        
       
    }

}
