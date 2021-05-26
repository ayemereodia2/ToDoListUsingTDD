//
//  InputViewController.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 24/05/2021.
//

import UIKit


class InputViewController : UIViewController {
    
    let titleTextField:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let saveButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    let cancelButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(titleTextField)
        view.addSubview(saveButton)
        view.addSubview(cancelButton)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func saveButtonTapped() {
        
    }
    
    @objc func cancelButtonTapped() {
        
    }
}
