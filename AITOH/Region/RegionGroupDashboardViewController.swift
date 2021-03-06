//
//  RegionGroupDashboardViewController.swift
//  AITOH
//
//  Created by Jerry Kwok on 4/3/2020.
//  Copyright © 2020 AITOH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegionGroupDashboardViewController: UIViewController {
    
    @IBOutlet weak var historyCollectionView: UICollectionView!
    var region:Region?
    var hotRegionGroup:[RegionGroup] = []
    var privateRegionGroup:[PrivateRegion] = []
    var regionGroupHistory:[RegionHistory] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId:String = UserDefaults.standard.string(forKey: "userId")!
        // Do any additional setup after loading the view.
        print("case1: " + region!.bgImagePath!)
        guard let url = URL(string: "https://cuvfsx9pda.execute-api.us-east-1.amazonaws.com/aitoh/regiongroup?hot=true&regionId=" + String(region!.id!)+"&userId=" + userId) else { return }
        print(url)
        getHotRegionGroup(gate: url)
    }
    
    @IBAction func btnCreateRegion(_ sender: Any) {
        let viewController:CreateRegionViewController = UIStoryboard(name: "Region", bundle: nil).instantiateViewController(withIdentifier: "CreateRegionViewController") as!CreateRegionViewController
        viewController.viewController = self
        viewController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.linear)
                   view.window!.layer.add(transition, forKey: kCATransition)
                   
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func btnClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func getHotRegionGroup(gate: URL){
        AF.request(gate).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
             let json = JSON(value)
             let list = json["regions"].arrayValue
             let priList = json["privateRegion"].arrayValue
             let history = json["history"].arrayValue
             for regionJson in list {
                // 實例化一個 Book，並透過 bookJson 初始化它
                let region = RegionGroup(json: regionJson)
                self.hotRegionGroup.append(region)
             }
             let moreRegion = RegionGroup(id: -1, name: "")
             self.hotRegionGroup.append(moreRegion)
             print(json)
             for priRegionJson in priList{
                let priRegion = PrivateRegion(json: priRegionJson)
                self.privateRegionGroup.append(priRegion)
             }
             
             for hist in history{
                let hotRegionHist = RegionHistory(json: hist)
                self.regionGroupHistory.append(hotRegionHist)
             }
             self.tableView.reloadData()
             break
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
   /*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.collectView){
            return hotRegionGroup.count
        }else{
            return regionGroupHistory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView != self.historyCollectionView){
            print("load model indr" + String(indexPath.row))
            let regionGroup = hotRegionGroup[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotRegionGroupCell", for: indexPath)as! HotRegionGroupCell
            print(hotRegionGroup.count)
             if(indexPath.row == hotRegionGroup.count - 1){
                cell.initLast()
             }else{
                cell.initElement(region: regionGroup)
             }
            
            return cell
        }else{
            print("print history")
            let hist = regionGroupHistory[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotRegionHistoryCell", for: indexPath)as! HotRegionHistoryCell
            cell.initCommit(region: hist)
            
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == self.collectView){
            return CGSize(width: 100, height: 200)
        }else{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        print(hotRegionGroup.count)
        if(indexPath.row == hotRegionGroup.count - 1){
            let vc = storyboard?.instantiateViewController(identifier: "RegionGroupSearchViewController") as! RegionGroupSearchViewController
            vc.regionId = region?.id
            let transition = CATransition()
            transition.duration = 0.5
            vc.modalPresentationStyle = .fullScreen
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            present(vc, animated: false, completion: nil)
            
        }
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegionGroupDashboardViewController: UICollectionViewDelegateFlowLayout {

}

extension RegionGroupDashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return privateRegionGroup.count + regionGroupHistory.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegionGroupDhdTopTableViewCell", for: indexPath) as! RegionGroupDhdTopTableViewCell
            cell.loadHotRegion(hotRegionGroup: hotRegionGroup)
            cell.viewcontroller = self
            cell.region = region
            cell.collectionView.reloadData()
            return cell
        } else if privateRegionGroup.count != 0 && indexPath.row <= privateRegionGroup.count  {
            let privateRegion = privateRegionGroup[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivateGroupTableViewCell", for: indexPath)as! PrivateGroupTableViewCell
                cell.initCommit(region: privateRegion)
            return cell
        }else{
            if(regionGroupHistory.count != 0){
                print(indexPath.row)
                print(regionGroupHistory.count)
                let history = regionGroupHistory[indexPath.row - 1 - privateRegionGroup.count]
                let cell = tableView.dequeueReusableCell(withIdentifier: "RegionGroupHistoryCell", for: indexPath) as! RegionGroupHistoryCell
                cell.initCommit(history: history)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RegionGroupHistoryCell", for: indexPath) as! RegionGroupHistoryCell
                return cell
            }
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 191
        }else if privateRegionGroup.count != 0 && indexPath.row <= privateRegionGroup.count{
            return 73
        }else {
            return 324
        }
    }

}


