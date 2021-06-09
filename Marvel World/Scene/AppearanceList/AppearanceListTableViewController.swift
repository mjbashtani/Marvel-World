//
//  AppearanceListTableViewController.swift
//  Marvel World
//
//  Created by Mohammad Javad Bashtani on 3/19/1400 AP.
//

import UIKit

class AppearanceListTableViewController: UITableViewController {
    internal init(appearances: [Appearance]) {
        self.appearances = appearances
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var appearances: [Appearance]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "AppearanceTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AppearanceTableViewCell")
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appearances.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppearanceTableViewCell", for: indexPath) as! AppearanceTableViewCell
        cell.bind(data: appearances[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
  
    
}
