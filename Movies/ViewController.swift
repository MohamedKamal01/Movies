//
//  ViewController.swift
//  Movies
//
//  Created by Mohamed Kamal on 02/02/2022.
//

import UIKit
import Cosmos

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    

    
    let cellReuseIdentifier = "cellview"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var utitle: UILabel!
    @IBOutlet weak var uImage: UIImageView!
    @IBOutlet weak var Uyear: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    var titleStr: String = ""
    var imageStr: UIImage?
    var rateStr: Double = 0.0
    var yearStr: Int = 0

    var genreArray : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        utitle.text=titleStr;
        uImage.image = imageStr
        Uyear.text = String(yearStr)
        cosmosView.rating = rateStr
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =
            tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? UITableViewCell
        {
            cell.textLabel!.text = self.genreArray[indexPath.row]
            return cell
        }
    }

}

