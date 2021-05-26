//
//  DetailViewController.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 22/05/2021.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var itemInfo:(ItemManager, Int)?

    let titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    
    let mapView:MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    override func loadView() {
        super.loadView()
        setupViews()
        setMapViewConstraints()
        setTitleConstraints()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let itemInfo = itemInfo else {
            return
        }
        let item = itemInfo.0.item(at: itemInfo.1)
        titleLabel.text = item.title
        
        if let coordinate = item.location?.coordinate{
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 0,longitudinalMeters: 0)
            mapView.region = region
        }
    }
    
    func checkItem() {
        if let itemInfo = itemInfo {
            itemInfo.0.checkItem(at: itemInfo.1)
        }
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(titleLabel)

    }
    
    func setTitleConstraints() {
        titleLabel.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
    }
    
    func setMapViewConstraints() {
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
    }
}
