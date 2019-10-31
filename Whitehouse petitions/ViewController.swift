//
//  ViewController.swift
//  Whitehouse petitions
//
//  Created by ahmad$$ on 10/24/19.
//  Copyright © 2019 ahmad. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString : String
        if navigationController?.tabBarItem.tag == 0 {
            
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                    return
                }
                self?.showMessage()
            }
        }
        
        
                
    }
    func showMessage(){
        DispatchQueue.main.async{ [weak self] in
        let alert = UIAlertController(title: "Error loading data", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self?.present(alert,animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailPetition = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func parse(json: Data){
        
        let decoder = JSONDecoder()
        if let  decodedJsonData =  try? decoder.decode(Petitions.self, from: json) {   petitions = decodedJsonData.results
            DispatchQueue.main.async{ [weak self ] in
                self?.tableView.reloadData()
            }
            
        }
        
        
        
    }
    
}
