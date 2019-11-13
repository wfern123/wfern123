//
//  ViewController.swift
//  Project1
//
//  Created by William Fernandez on 10/3/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //1. try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            
            //2. success! Set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            
            //3. now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
            
            //4. set the selectedImageNumber
            vc.selectedImageNumber = indexPath.row + 1
            
            //5. set the numberOfImages
            vc.numberOfImages = pictures.count
        }
    }
    
    

}

