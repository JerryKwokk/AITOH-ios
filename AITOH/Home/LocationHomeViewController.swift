//
//  LocationHomeViewController.swift
//  AITOH
//
//  Created by Jerry Kwok on 2/3/2020.
//  Copyright © 2020 AITOH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class LocationHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var regions: [Region] = []
    var searchRegions: [Region] = []
    var search = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
       guard let url = URL(string: "https://cuvfsx9pda.execute-api.us-east-1.amazonaws.com/aitoh/region") else { return }
       tableView.rowHeight = 225
       tableView.estimatedRowHeight = 0
       AF.request(url).validate().responseJSON { (response) in
           switch response.result {
           case .success(let value):
            let json = JSON(value)
                  // 獲取我們 list Array
                  let list = json["regions"].arrayValue
                  // 創建一個 [Book] 來存放獲取的 Array
                  for regionJson in list {
                      // 實例化一個 Book，並透過 bookJson 初始化它
                      let region = Region(json: regionJson)
                      // 加到上面 books 中
                      self.regions.append(region)
                  }
            
                print(json)
            print(self.regions.count)
            self.tableView.reloadData()
            break
               
           case .failure(let error):
               print(error)
           }
       }
       
        
        let nibName = UINib(nibName: "LocationHomeTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "LocationHomeTableViewCell")
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(search){
            return searchRegions.count
        }else{
            return regions.count
        }
        
        
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var region: Region
        if search {
            region = searchRegions[indexPath.row]
        }else{
            region = regions[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationHomeTableViewCell")as! LocationHomeTableViewCell
        cell.initCommit(region: region)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
       {
         var region: Region
         if search {
                   region = searchRegions[indexPath.row]
         }else{
                   region = regions[indexPath.row]
         }
        let storyboard = UIStoryboard(name: "Region", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegionGroupDashboardViewController")as! RegionGroupDashboardViewController
        controller.region = region
        print("case1: ")
        self.present(controller, animated: true, completion: nil)


       }
    
}

extension LocationHomeViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" || searchText == " " {
            search = false
        }else{
            searchRegions.removeAll()
            for item in searchRegions {
                if(item.title!.uppercased().contains(searchText.uppercased())){
                    searchRegions.append(item)
                }
            }
            search = true
        }
        
        tableView.reloadData()
        
        
    }
}
