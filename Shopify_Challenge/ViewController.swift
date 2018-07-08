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
    
   // Outlets
    
    @IBOutlet weak var tableview: UITableView!
    
     // MARK: - Variables
    
    var json = JSON()
    let urlString = "https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    
    var ProvinceNAmeDict = [String : Int]()
    var Yeardict = [Int : Int]()
    var ProvincesArry = [String]()
    
    var orderbydate = [Int]()
    var orderbyYearArr = [Int]()
    var ordercountbyyearArr = [Int]()
    var orderCounterArryS1 = [Int]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchdata()
        
        
    }
    // Api call to fetch data
    
    func fetchdata() {
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.prettyPrinted , headers: nil).responseJSON { (response) in
            guard ((response.result.value) != nil) else{
                
                print(response.result.error!.localizedDescription)
                
                return
            }
            self.json = JSON(response.result.value!)
            print(self.json)
            self.parseData()
        }
    }
    
    
    
    
    func parseData() {
        
        var province = (((self.json["orders"].arrayValue).map({$0 ["billing_address"]})).map({$0["province"].stringValue}))
        province = province.filter { $0 != "" }
        
        let orderbyDate = (((self.json)["orders"].arrayValue).map({$0["created_at"].string!}))
        
        
        for year in orderbyDate {
            //convert string to date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
            let date = dateFormatter.date(from: year)
            print(date!)
            let calendar = Calendar.current
            //get year from date
            let year1 = calendar.component(.year, from: date!)
            print(year1)
            // Append each string date to array
            self.orderbydate.append(year1)
            
            
            
        }
        // get total order by year
        
        for year in self.orderbydate {
            if let count = self.Yeardict[year] {
                self.Yeardict[year] = count + 1
            }else {
                self.Yeardict[year] = 1
            }
        }
        for (key,value) in self.Yeardict {
            
            print("\(key) : \(self.Yeardict[key]!)")
            self.orderbyYearArr.append(key)
            self.ordercountbyyearArr.append(value)
            
        }
        //get province name and total numbers of orders from that province
        for name in province {
            if let count = self.ProvinceNAmeDict[name] {
                self.ProvinceNAmeDict[name] = count + 1
            } else {
                self.ProvinceNAmeDict[name] = 1
            }
        }
        for (key,value) in self.ProvinceNAmeDict {
            self.ProvincesArry.append(key)
            self.orderCounterArryS1.append(value)
            
            print("\(key) : \(self.ProvinceNAmeDict[key]!)")
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
            
        }
        // let sortedArray = self.ProvinceNAmeDict.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        // print(sortedArray)
        
        
    }
    
    
}
extension ViewController: UITableViewDelegate , UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return ordercountbyyearArr.count
        }
        return ProvincesArry.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.backgroundColor = UIColor.gray
        if section == 0 {
            cell.proviceTitleName.text = ProvincesArry[indexPath.row]
            cell.ordercounterLbl.text = ("\(orderCounterArryS1[indexPath.row]) number of order from \(ProvincesArry[indexPath.row])")
        }else {
            
            cell.ordercounterLbl.text = ("\(ordercountbyyearArr[indexPath.row]) number of order created in \(orderbyYearArr[indexPath.row])")
        }
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
