//
//  DulceriaViewController.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import UIKit

class DulceriaViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    var itemsList: [ItemModel] = []
    var finalItemsPrice: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setControllerStyle()
        getItemsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setControllerStyle() {
        self.tabBarItem.image = UIImage(systemName: "star.fill")
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "backgroundB"))
        continueButton.layer.cornerRadius = 10
    }
    
    private func getItemsList() {
        CandyStoreWS.sharedService.getItemsData(self) { items in
            self.itemsList = items
            self.tableView.reloadData()
        } failureResponse: { errorMsg in
            print(errorMsg)
        }
    }

    @IBAction func continueTapper(_ sender: Any) {
        performSegue(withIdentifier: "toPayController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PagoViewController {
            let vc = segue.destination as! PagoViewController
            vc.totalMount = finalItemsPrice
        }
    }
}

extension DulceriaViewController: UITableViewDelegate, UITableViewDataSource, DulceriaItemDelegate {
    func addToTotal(number: Double) {
        self.finalItemsPrice = finalItemsPrice + number
        self.totalCostLabel.text = "S/. \(String(finalItemsPrice))"
    }
    
    func substrateToTotal(number: Double) {
        self.finalItemsPrice = finalItemsPrice - number
        self.totalCostLabel.text = "S/. \(String(finalItemsPrice))"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DulceriaTableViewCell
        cell.itemDescription.text = itemsList[indexPath.row].description
        cell.itemPrice.text = itemsList[indexPath.row].price
        cell.itemImage.image = itemsList[indexPath.row].image
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
