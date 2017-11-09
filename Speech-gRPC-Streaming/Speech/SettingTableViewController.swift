//
//  SettingTableViewController.swift
//  Speech
//
//  Created by Christopher James Lebioda on 11/6/17.
//  Copyright © 2017 Google. All rights reserved.
//

import UIKit

var current_font = "Helvetica Neue"
var current_font_size = 14

protocol ClassBackgroundDelegate: class {
    func changeBackgroundColor(_ color: UIColor?)
}

protocol ClassFontColorDelegate: class {
    func changeFontColor(_ color: UIColor?)
}

protocol ClassFontSizeDelegate: class {
    func changeFontSize(_ fontSize: UIFont?)
}

protocol ClassFontDelegate: class {
    func changeFont(_ fontSize: UIFont?)
}

class SettingTableViewController: UITableViewController {
    
    
    weak var delegate: ClassBackgroundDelegate?
    weak var delegate2: ClassFontColorDelegate?
    weak var delegate3: ClassFontSizeDelegate?
    weak var delegate4: ClassFontDelegate?
    var settings = [Setting]()
    
    //var current_font = "Arial"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    //Background Colors
    @IBAction func blackBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor.black)
    }
    @IBAction func darkGreyBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor.darkGray)
    }
    @IBAction func lightGreyBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor.lightGray)
    }
    @IBAction func changeDefaultBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 20/255.0, green: 50/255.0, blue: 64/255.0, alpha: 1.0))
    }
    @IBAction func blueBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 25/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1.0))
    }
    @IBAction func greenBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 0/255.0, green: 50/255.0, blue: 0/255.0, alpha: 1.0))
    }
    @IBAction func yellowBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 227/255.0, green: 207/255.0, blue: 13/255.0, alpha: 1.0))
    }
    @IBAction func orangeBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 223/255.0, green: 124/255.0, blue: 2/255.0, alpha: 1.0))
    }
    @IBAction func redBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 131/255.0, green: 4/255.0, blue: 4/255.0, alpha: 1.0))
    }
    @IBAction func purpleBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 69/255.0, green: 3/255.0, blue: 116/255.0, alpha: 1.0))
    }
    @IBAction func beccasFavorite(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 92/255.0, green: 28/255.0, blue: 109/255.0, alpha: 1.0))
    }
    @IBAction func chrisFavorite(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 109/255.0, green: 169/255.0, blue: 225/255.0, alpha: 1.0))
    }
    @IBAction func javiersPick(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 17/255.0, green: 106/255.0, blue: 163/255.0, alpha: 1.0))
    }
    @IBAction func NicksPick(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 255/255.0, green: 159/255.0, blue: 21/255.0, alpha: 1.0))
    }
    
    //Font Colors
    @IBOutlet weak var fontBlackButton: UIButton!
    @IBAction func changeFontColorBlack(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.black)
        fontBlackButton.isSelected = !(sender as AnyObject).isSelected;
    }
    @IBAction func changeFontColorGrey(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.gray)
    }
    @IBAction func changeFontColorRed(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.red)
    }
    @IBAction func changeFontColorBlue(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.blue)
    }
    
    //Font Size
    @IBAction func fontSize30(_ sender: Any) {
        current_font_size = 30
        delegate3?.changeFontSize(UIFont(name: current_font, size: 30))
    }
    @IBAction func fontSize14(_ sender: Any) {
        current_font_size = 14
        delegate3?.changeFontSize(UIFont(name: current_font, size: 14))
    }
    @IBAction func fontSize18(_ sender: Any) {
        current_font_size = 18
        delegate3?.changeFontSize(UIFont(name: current_font, size: 18))
    }
    @IBAction func fontSize22(_ sender: Any) {
        current_font_size = 22
        delegate3?.changeFontSize(UIFont(name: current_font, size: 22))
    }
    @IBAction func fontSize26(_ sender: Any) {
        current_font_size = 26
        delegate3?.changeFontSize(UIFont(name: current_font, size: 26))
    }
    
    //Fonts
    @IBAction func fontAmericanTypeWriter(_ sender: Any) {
        current_font = "American Typewriter"
        delegate4?.changeFont(UIFont(name: "American Typewriter", size: CGFloat(current_font_size)))
    }
    @IBAction func fontArial(_ sender: Any) {
        current_font = "Arial"
        delegate4?.changeFont(UIFont(name: "Arial", size: CGFloat(current_font_size)))
    }
    @IBAction func fontCopperplate(_ sender: Any) {
        current_font = "Copperplate"
        delegate4?.changeFont(UIFont(name: "Copperplate", size: CGFloat(current_font_size)))
    }
    
    @IBAction func changeFont1(_ sender: Any) {
        current_font = "Didot"
        delegate4?.changeFont(UIFont(name: "Didot", size: CGFloat(current_font_size)))
    }
    @IBAction func changeFont2(_ sender: Any) {
        current_font = "Courier"
        delegate4?.changeFont(UIFont(name: "Courier", size: CGFloat(current_font_size)))
    }
    @IBAction func fontGeorgia(_ sender: Any) {
        current_font = "Georgia"
        delegate4?.changeFont(UIFont(name: "Georgia", size: CGFloat(current_font_size)))
    }
    @IBAction func fontGillSans(_ sender: Any) {
        current_font = "Gill Sans"
        delegate4?.changeFont(UIFont(name: "Gill Sans", size: CGFloat(current_font_size)))
    }
    @IBAction func fontHelveticaNeue(_ sender: Any) {
        current_font = "Helvetica Neue"
        delegate4?.changeFont(UIFont(name: "Helevetica Neue", size: CGFloat(current_font_size)))
    }
    @IBAction func fontOptima(_ sender: Any) {
        current_font = "Optima Regular"
        delegate4?.changeFont(UIFont(name: "Optima Regular", size: CGFloat(current_font_size)))
    }
    @IBAction func fontTNR(_ sender: Any) {
        current_font = "Times New Roman"
        delegate4?.changeFont(UIFont(name: "Times New Roman", size: CGFloat(current_font_size)))
    }
    @IBAction func fontVerdana(_ sender: Any) {
        current_font = "Verdana"
        delegate4?.changeFont(UIFont(name: "Verdana", size: CGFloat(current_font_size)))
    }
    
    //checkmarks for tableview not button
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    
    
    
   
    private func loadSettings() {
        let setting1 = UIButton()
        
        guard let fontColor = Setting( button: setting1, string: "Blue") else {
            fatalError("Unable to instantiate fontColor")
        }
        settings += [fontColor]
    }
}
