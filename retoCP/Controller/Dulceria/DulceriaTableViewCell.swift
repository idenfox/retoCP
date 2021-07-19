//
//  DulceriaTableViewCell.swift
//  retoCP
//
//  Created by Renzo Paul Chamorro on 18/07/21.
//

import UIKit

protocol DulceriaItemDelegate: AnyObject {
    func addToTotal(number: Double)
    func substrateToTotal(number: Double)
}

class DulceriaTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var itemCounterLabel: UILabel!
    
    var delegate: DulceriaItemDelegate?
    private var itemCounter: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImage.sizeToFit()
        itemImage.layer.cornerRadius = 15
        checkItemCounter()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func checkItemCounter() {
        minusButton.isEnabled = false
    }
    
    @IBAction func minusTapped(_ sender: Any) {
        itemCounter -= 1
        minusButton.isEnabled = itemCounter == 0 ? false : true
        itemCounterLabel.text = String(itemCounter)
        
        let floatNumber = (itemPrice.text! as NSString).doubleValue
        delegate?.substrateToTotal(number: floatNumber)
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        minusButton.isEnabled = true
        itemCounter += 1
        itemCounterLabel.text = String(itemCounter)
        let floatNumber = (itemPrice.text! as NSString).doubleValue
        delegate?.addToTotal(number: floatNumber)
    }
    
}
