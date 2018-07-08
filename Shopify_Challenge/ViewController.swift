//
//  ViewController.swift
//  Shopify_Challenge
//
//  Created by Jagdeep on 07/07/18.
//  Copyright © 2018 Self. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController{

    // MARK: - Variables
    
    @IBOutlet weak var tableview: UITableView!
    let urlString = "https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    
    var ProvinceNAmeDict = [String : Int]()
    var ProvincesArry = [String]()
    var orderCounterArry = [Int]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       fetchdata()
        

    }

    override func viewDidAppear(_ animated: Bool) {
        
        //self.tableview.reloadData()
    }
    
    
    
    func fetchdata() {
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            let json = JSON(response.result.value!)
            print(json)
            
            var province = (((json["orders"].arrayValue).map({$0 ["billing_address"]})).map({$0["province"].stringValue}))
            province = province.filter { $0 != "" }
            var orderbyDate = (((json)["orders"].arrayValue).map({$0["created_at"].string!}))
            for year in orderbyDate {
                let start = year
                //let end = "2017-11-12"
                let dateFormat = "yyyy-MM-dd"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = dateFormat
                var arrayOfDates = [Date]()
                let startDate = dateFormatter.date(from: start)
               // arrayOfDates.append(startDate!)
            }
            for name in province {
                if let count = self.ProvinceNAmeDict[name] {
                    self.ProvinceNAmeDict[name] = count + 1
                } else {
                    self.ProvinceNAmeDict[name] = 1
                }
            }
            for (key,value) in self.ProvinceNAmeDict {
                self.ProvincesArry.append(key)
                self.orderCounterArry.append(value)
                
                print("\(key) : \(self.ProvinceNAmeDict[key]!)")
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            }
           // let sortedArray = self.ProvinceNAmeDict.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
           // print(sortedArray)
            
            
        }
    
    }
    
    
}
extension ViewController: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProvincesArry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.backgroundColor = UIColor.gray
        cell.proviceTitleName.text = ProvincesArry[indexPath.row]
        cell.ordercounterLbl.text = ("\(orderCounterArry[indexPath.row]) number of order from \(ProvincesArry[indexPath.row])")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
        
        
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Order By Province"
        }else {
            return "Orders by year"
        }
    }
}
