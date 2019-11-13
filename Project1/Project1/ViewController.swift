//
//  ViewController.swift
//  Project1
//
//  Created by William Fernandez on 10/3/19.
//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // array to store all the pictures
    var pictures = [String]()
    var pictDict = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Storm Viewer"
        
        // GCD
        DispatchQueue.global(qos: .userInitiated).async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    self.pictures.append(item)
                    self.loadPictures(item: item)
                }
            }
            // sorts everything in alphabetical or numerical order
            self.pictures.sort()
        }
        
        let defaults = UserDefaults.standard

        if let savedViewCount = defaults.object(forKey: "pictDict") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                pictDict = try jsonDecoder.decode([String: Int].self, from: savedViewCount)
            } catch {
                print("Failed to load view count.")
            }
        }
        
        tableView.reloadData()
    }
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        cell.textLabel?.text = picture
        cell.detailTextLabel?.text = "Viewed \(String(describing: pictDict[picture]!)) times"
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
        
        let picture = pictures[indexPath.row]
        pictDict[picture]! += 1
        save()
        tableView.reloadData()
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(pictDict) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictDict")
        } else {
            print("Failed to save people.")
        }
    }
    
    func loadPictures(item: String) {
        pictDict[item] = 0
    }

}

