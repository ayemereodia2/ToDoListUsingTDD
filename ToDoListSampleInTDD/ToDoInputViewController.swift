//
//  InputViewController.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 24/05/2021.
//

import UIKit
import CoreLocation

class ToDoInputViewController : UIViewController {
    
    lazy var geoCoder = CLGeocoder()
    var itemManager:ItemManager?
    
    
    let titleTextField:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 25,weight: .medium)
        label.text = "Title Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let saveButton:UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 6
        return button
    }()
    
    let cancelButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 6
        return button
    }()
    let mainView:UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        return view
    }()
    
    let addressTexfield:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "address"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateTextField:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "date"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(mainView)
        mainView.addSubview(titleTextField)
        mainView.addSubview(addressTexfield)
        mainView.addSubview(dateTextField)
        mainView.addSubview(saveButton)
        mainView.addSubview(cancelButton)
      saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        setConstraintsForViews()


    }
    func setConstraintsForViews() {
        
        NSLayoutConstraint.activate([
            self.mainView.topAnchor.constraint(equalTo: view.topAnchor),
            self.mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.mainView.heightAnchor.constraint(equalToConstant: 300),



            self.titleTextField.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 75),
            self.titleTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            self.titleTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            self.titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            self.addressTexfield.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25),
            self.addressTexfield.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            self.addressTexfield.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            self.addressTexfield.heightAnchor.constraint(equalToConstant: 44),
            
            self.dateTextField.topAnchor.constraint(equalTo: addressTexfield.bottomAnchor, constant: 25),
            self.dateTextField.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            self.dateTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            self.dateTextField.heightAnchor.constraint(equalToConstant: 44),
            //
            
            self.saveButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 25),
            self.saveButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 20),
            
            self.saveButton.heightAnchor.constraint(equalToConstant: 44),
            self.saveButton.widthAnchor.constraint(equalToConstant: 100),
            
            self.saveButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            
            //self.saveButton.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10),
           
            self.cancelButton.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -20),
            self.cancelButton.widthAnchor.constraint(equalToConstant: 100),
            self.cancelButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 25),
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        saveButton.sendActions(for: .touchUpInside)
    }
    
    @objc func saveButtonTapped(sender: UIButton!) {
        save()
    }
    
    @objc func cancelButtonTapped() {
        
    }
    
    lazy var dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
     func save () {
        guard let titleString = titleTextField.text, titleString.count > 0 else {
            return
        } 
        
        let date:Date?
        if let dateText = dateTextField.text, dateText.count > 0 {
            date = dateFormatter.date(from: dateText)
        }else{
            date = nil
        }
        
        if let addressString = addressTexfield.text, addressString.count > 0 {
            geoCoder.geocodeAddressString(addressString){[unowned self] (placeMarks, error) -> Void in 
                let placeMark = placeMarks?.first
                
                let item = ToDoItem(title: titleString, itemDescription: "description", timestamp: date?.timeIntervalSince1970, location: Location(name: addressString, coordinate: placeMark?.location?.coordinate))
                
                self.itemManager?.add(item)
                
            }
        }
    }
}