//
//  ItemListViewController.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import UIKit

class ItemListViewController : UIViewController {
    typealias ComposedSources = (UITableViewDelegate & UITableViewDataSource & ItemManagerSettable)
    
    let itemManager = ItemManager()
    var dataProvider:ComposedSources!
    
    convenience init(dataProvider:ComposedSources) {
        self.init()
        self.dataProvider = dataProvider
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // dataProvider.itemManager = itemManager
        self.tableView.reloadData()
    }
  
   
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     var tableView:UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
       
        NotificationCenter.default.addObserver(self, selector: #selector(showDetailView), name: NSNotification.Name(rawValue: "ItemSelectedNotification"), object: nil)
        
    }
    
    override func loadView() {
        super.loadView()
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        view.backgroundColor = .white
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.cellId)
        setupView()
    }
    let mainView:UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    @objc func showDetailView(sender:NSNotification) {
        
        guard let index = sender.userInfo?["index"] as? Int else {
            fatalError()
        }
        let detailsVC = DetailViewController()
        detailsVC.itemInfo = (itemManager, index)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
   func setupView(){
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
}
    @objc func addButtonTapped() {
        let vc = ToDoInputViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.itemManager = itemManager
        
        self.present(vc, animated: true)
        
    }
}
