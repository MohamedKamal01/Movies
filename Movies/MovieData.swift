//
//  MovieData.swift
//  Movies
//
//  Created by Mohamed Kamal on 02/02/2022.
//

import Foundation
import UIKit
import Reachability
import CoreData
class Movies:UIViewController, UITableViewDelegate, UITableViewDataSource,MyProtocol
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var connection = ""
    var mo : [NSManagedObject]!
    var view1 = AddData()
    var dic : Dictionary<String,Any>?
    var names: [String] = []
    var images : [UIImage] = []
    var rate : [Double] = []
    var year : [Int] = []
    var groups = [[String]]()
    let cellReuseIdentifier = "cell"
    let reachability = try! Reachability()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
       do{
         try reachability.startNotifier()
       }catch{
         print("could not start reachability notifier")
       }
    }
    override func viewDidLoad() {
            super.viewDidLoad()

        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self


        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.names.count
        }
        
        // create a cell for each table view row
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
            cell.textLabel!.text = self.names[indexPath.row]
            cell.imageView!.image = self.images[indexPath.row]
                
            return cell
            
            
        }
        
        // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let view1 = storyBoard.instantiateViewController(withIdentifier: "show") as! ViewController
        self.navigationController?.pushViewController(view1, animated: true)
        view1.titleStr = names[indexPath.row]
        view1.imageStr = images[indexPath.row]
        view1.rateStr = rate[indexPath.row]
        view1.yearStr = year[indexPath.row]
        view1.genreArray = groups[indexPath.row]
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func add() {
        
        if view1.tit.text != ""
        {
            names.append(view1.tit.text!)
            images.append(view1.im.image!)
            rate.append(Double(view1.rate.text!)!)
            year.append(Int(view1.year.text!)!)
            groups.append([view1.genre.text!])
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "MovieData1", in : managedContext)!
            let movie = NSManagedObject(entity: entity, insertInto: managedContext)

            movie.setValue(view1.tit.text!, forKey: "title")
            movie.setValue(view1.im.image?.pngData()!, forKey: "image")
            movie.setValue(Double(view1.rate.text!)!, forKey: "rate")
            movie.setValue(Int(view1.year.text!)!, forKey: "year")
            let boxedData = try! NSKeyedArchiver.archivedData(withRootObject: [view1.genre.text!] as Any, requiringSecureCoding: true)
            movie.setValue(boxedData, forKey: "genre")
            do
            {
                try managedContext.save()
                print("Record Added!")
            }
            catch let error as NSError
            {
                print("Could not save. \(error),\(error.userInfo)")
            }
            
            view1.p=self
            self.tableView.reloadData()
        }
    }
   
    
    @IBAction func addBu(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        view1 = storyBoard.instantiateViewController(withIdentifier: "AddData") as! AddData
        self.navigationController?.pushViewController(view1, animated: true)
        view1.p=self
    }
    @objc func reachabilityChanged(note: Notification){

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .wifi:
          self.deleteDataCore()
          self.getDataJson()
          connection = "Reachable via WiFi"
          print(connection)
      case .cellular:
          self.deleteDataCore()
          self.getDataJson()
          connection = "Reachable via Cellular"
          print(connection)
      case .unavailable:
          self.getDataCore()
         connection =  "Network not reachable"
          print(connection)
      case .none:
         connection = "None"
          print(connection)
      }
    }
    func getDataJson()
    {
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MovieData1", in : managedContext)!
    

        title = "Movies"
        let url = URL(string: "https://api.androidhive.info/json/movies.json")
        let req = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: req) { data, response, error in
        do
        {
            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as!
            [Dictionary<String,Any>]

            DispatchQueue.main.async {
            for dictionar in json
            {
                self.names.append(dictionar["title"] as! String)
                let urlimage = URL(string: dictionar["image"] as! String)
                let data = try? Data(contentsOf: urlimage!)

                if let imageData = data
                {
                    self.images.append(UIImage(data: imageData)!)
                }
                self.rate.append((dictionar["rating"] as! Double)/2)
                self.year.append(dictionar["releaseYear"] as! Int)
                self.groups.append(dictionar["genre"] as! [String])


                //core data
                let movie = NSManagedObject(entity: entity, insertInto: managedContext)

                movie.setValue(dictionar["title"] as! String, forKey: "title")
                movie.setValue(data, forKey: "image")
                movie.setValue((dictionar["rating"] as! Double)/2, forKey: "rate")
                movie.setValue(dictionar["releaseYear"] as! Int, forKey: "year")
                let boxedData = try! NSKeyedArchiver.archivedData(withRootObject: dictionar["genre"] as! [String]? as Any, requiringSecureCoding: true)
                movie.setValue(boxedData, forKey: "genre")
                do
                {
                    try managedContext.save()
                    print("Record Added!")
                }
                catch let error as NSError
                {
                    print("Could not save. \(error),\(error.userInfo)")
                }





            }
                let alertController = UIAlertController(title: "Message", message: "Data Added!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) {
                    (action: UIAlertAction!) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                self.tableView.reloadData()
                
            }

        }
            catch
            {
                print(error.localizedDescription)
            }



        }


        task.resume()
    }
    func getDataCore()
    {
        mo = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieData1")
        let managedContext = appDelegate.persistentContainer.viewContext
        do
        {
            mo = try managedContext.fetch(fetchRequest)
            for i in 0..<mo.count
            {
                names.append(mo[i].value(forKey: "title") as! String)
                images.append(UIImage(data:mo[i].value(forKey: "image") as! Data)!)
                rate.append(mo[i].value(forKey: "rate") as! Double)
                year.append(mo[i].value(forKey: "year") as! Int)
                groups.append( try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(mo[i].value(forKey: "genre") as! Data) as! [String])
                
            }
            
            tableView.reloadData()
        }
        catch let error as NSError
        {
            print(error)
        }
                       
    }
    func deleteDataCore()
    {
        mo = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieData1")
        let managedContext = appDelegate.persistentContainer.viewContext

                       do
                       {
                           mo = try managedContext.fetch(fetchRequest)
                           for i in mo
                           {
                               managedContext.delete(i)
                           }
                           try managedContext.save()
                           tableView.reloadData()
                       }
                       catch let error as NSError
                       {
                           print(error)
                       }
        
    }
    
    
}
