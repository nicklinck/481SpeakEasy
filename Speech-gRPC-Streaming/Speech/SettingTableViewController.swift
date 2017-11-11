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
    
    @IBOutlet weak var blackBackgroundButton: SpringButton!
    @IBOutlet weak var darkGreyBackgroundButton: SpringButton!
    @IBOutlet weak var lightGreyBackgroundButton: SpringButton!
    @IBOutlet weak var defaultBackgroundButton: SpringButton!
    @IBOutlet weak var blueBackgroundButton: SpringButton!
    @IBOutlet weak var greenBackgroundButton: SpringButton!
    @IBOutlet weak var yellowBackgroundButton: SpringButton!
    @IBOutlet weak var orangeBackgroundButton: SpringButton!
    @IBOutlet weak var redBackgroundButton: SpringButton!
    @IBOutlet weak var purpleBackgroundButton: SpringButton!
    @IBOutlet weak var beccasBackgroundButton: SpringButton!
    @IBOutlet weak var chrisBackgroundButton: SpringButton!
    @IBOutlet weak var javierBackgroundButton: SpringButton!
    @IBOutlet weak var nickBackgroundButton: SpringButton!
    var backgroundButtons: [SpringButton] = [SpringButton]()
    
    @IBOutlet weak var blackFontColorButton: SpringButton!
    @IBOutlet weak var greyFontColorButton: SpringButton!
    @IBOutlet weak var blueFontColorButton: SpringButton!
    @IBOutlet weak var redFontColorButton: SpringButton!
    var fontColorButtons: [SpringButton] = [SpringButton]()
    
    @IBOutlet weak var font14Button: SpringButton!
    @IBOutlet weak var font18Button: SpringButton!
    @IBOutlet weak var font22Button: SpringButton!
    @IBOutlet weak var font26Button: SpringButton!
    @IBOutlet weak var font30Button: SpringButton!
    var fontSizeButtons: [SpringButton] = [SpringButton]()
    
    @IBOutlet weak var atFontButton: SpringButton!
    @IBOutlet weak var arialFontButton: SpringButton!
    @IBOutlet weak var copperplateFontButton: SpringButton!
    @IBOutlet weak var courierFontButton: SpringButton!
    @IBOutlet weak var didotFontButton: SpringButton!
    @IBOutlet weak var georgiaFontButton: SpringButton!
    @IBOutlet weak var gsFontButton: SpringButton!
    @IBOutlet weak var hnFontButton: SpringButton!
    @IBOutlet weak var optimaFontButton: SpringButton!
    @IBOutlet weak var tnrFontButton: SpringButton!
    @IBOutlet weak var verdanaFontButton: SpringButton!
    var fontButtons: [SpringButton] = [SpringButton]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        self.backgroundButtons = [self.blackBackgroundButton, self.darkGreyBackgroundButton, self.lightGreyBackgroundButton, self.defaultBackgroundButton, self.blueBackgroundButton, self.greenBackgroundButton, self.yellowBackgroundButton, self.orangeBackgroundButton, self.redBackgroundButton, self.purpleBackgroundButton, self.beccasBackgroundButton, self.chrisBackgroundButton, self.javierBackgroundButton, self.nickBackgroundButton]
        self.fontColorButtons = [self.blackFontColorButton, self.greyFontColorButton, self.blueFontColorButton, self.redFontColorButton]
        self.fontSizeButtons = [self.font14Button, self.font18Button, self.font22Button, self.font26Button, self.font30Button]
        self.fontButtons = [self.atFontButton, self.arialFontButton, self.copperplateFontButton, self.courierFontButton, self.didotFontButton, self.georgiaFontButton, self.gsFontButton, self.hnFontButton, self.optimaFontButton, self.tnrFontButton, self.verdanaFontButton]
        defaultBackgroundButton.setTitleColor(UIColor.lightGray, for: .normal)
        blackFontColorButton.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
        font14Button.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
        hnFontButton.backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
        
        
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
        blackBackgroundButton.animation = "pop"
        blackBackgroundButton.animate()
    }
    
    @IBAction func darkGreyBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor.darkGray)
        darkGreyBackgroundButton.animation = "pop"
        darkGreyBackgroundButton.animate()
    }
    @IBAction func lightGreyBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor.lightGray)
        lightGreyBackgroundButton.animation = "pop"
        lightGreyBackgroundButton.animate()
    }
    @IBAction func changeDefaultBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 20/255.0, green: 50/255.0, blue: 64/255.0, alpha: 1.0))
        defaultBackgroundButton.animation = "pop"
        defaultBackgroundButton.animate()
    }
    @IBAction func blueBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 25/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1.0))
        blueBackgroundButton.animation = "pop"
        blueBackgroundButton.animate()
    }
    @IBAction func greenBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 0/255.0, green: 50/255.0, blue: 0/255.0, alpha: 1.0))
        greenBackgroundButton.animation = "pop"
        greenBackgroundButton.animate()
    }
    @IBAction func yellowBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 227/255.0, green: 207/255.0, blue: 13/255.0, alpha: 1.0))
        yellowBackgroundButton.animation = "pop"
        yellowBackgroundButton.animate()
    }
    @IBAction func orangeBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 223/255.0, green: 124/255.0, blue: 2/255.0, alpha: 1.0))
        orangeBackgroundButton.animation = "pop"
        orangeBackgroundButton.animate()
    }
    @IBAction func redBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 131/255.0, green: 4/255.0, blue: 4/255.0, alpha: 1.0))
        redBackgroundButton.animation = "pop"
        redBackgroundButton.animate()
    }
    @IBAction func purpleBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 69/255.0, green: 3/255.0, blue: 116/255.0, alpha: 1.0))
        purpleBackgroundButton.animation = "pop"
        purpleBackgroundButton.animate()
    }
    @IBAction func beccasFavorite(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 92/255.0, green: 28/255.0, blue: 109/255.0, alpha: 1.0))
        beccasBackgroundButton.animation = "pop"
        beccasBackgroundButton.animate()
    }
    @IBAction func chrisFavorite(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 109/255.0, green: 169/255.0, blue: 225/255.0, alpha: 1.0))
        chrisBackgroundButton.animation = "pop"
        chrisBackgroundButton.animate()
    }
    @IBAction func javiersPick(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 17/255.0, green: 106/255.0, blue: 163/255.0, alpha: 1.0))
        javierBackgroundButton.animation = "pop"
        javierBackgroundButton.animate()
    }
    @IBAction func NicksPick(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 255/255.0, green: 159/255.0, blue: 21/255.0, alpha: 1.0))
        nickBackgroundButton.animation = "pop"
        nickBackgroundButton.animate()
    }
    
    //Font Colors
    @IBAction func changeFontColorBlack(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.black)
        blackFontColorButton.animation = "pop"
        blackFontColorButton.animate()
    }
    @IBAction func changeFontColorGrey(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.gray)
        greyFontColorButton.animation = "pop"
        greyFontColorButton.animate()
    }
    @IBAction func changeFontColorRed(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.red)
        redFontColorButton.animation = "pop"
        redFontColorButton.animate()
    }
    @IBAction func changeFontColorBlue(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.blue)
        blueFontColorButton.animation = "pop"
        blueFontColorButton.animate()
    }
    
    //Font Size
    @IBAction func fontSize30(_ sender: Any) {
        current_font_size = 30
        delegate3?.changeFontSize(UIFont(name: current_font, size: 30))
        font30Button.animation = "pop"
        font30Button.animate()
    }
    @IBAction func fontSize14(_ sender: Any) {
        current_font_size = 14
        delegate3?.changeFontSize(UIFont(name: current_font, size: 14))
        font14Button.animation = "pop"
        font14Button.animate()
    }
    @IBAction func fontSize18(_ sender: Any) {
        current_font_size = 18
        delegate3?.changeFontSize(UIFont(name: current_font, size: 18))
        font18Button.animation = "pop"
        font18Button.animate()
    }
    @IBAction func fontSize22(_ sender: Any) {
        current_font_size = 22
        delegate3?.changeFontSize(UIFont(name: current_font, size: 22))
        font22Button.animation = "pop"
        font22Button.animate()
    }
    @IBAction func fontSize26(_ sender: Any) {
        current_font_size = 26
        delegate3?.changeFontSize(UIFont(name: current_font, size: 26))
        font26Button.animation = "pop"
        font26Button.animate()
    }
    
    //Fonts
    @IBAction func fontAmericanTypeWriter(_ sender: Any) {
        current_font = "American Typewriter"
        delegate4?.changeFont(UIFont(name: "American Typewriter", size: CGFloat(current_font_size)))
        atFontButton.animation = "pop"
        atFontButton.animate()
    }
    @IBAction func fontArial(_ sender: Any) {
        current_font = "Arial"
        delegate4?.changeFont(UIFont(name: "Arial", size: CGFloat(current_font_size)))
        arialFontButton.animation = "pop"
        arialFontButton.animate()
    }
    @IBAction func fontCopperplate(_ sender: Any) {
        current_font = "Copperplate"
        delegate4?.changeFont(UIFont(name: "Copperplate", size: CGFloat(current_font_size)))
        copperplateFontButton.animation = "pop"
        copperplateFontButton.animate()
    }
    
    @IBAction func changeFont1(_ sender: Any) {
        current_font = "Didot"
        delegate4?.changeFont(UIFont(name: "Didot", size: CGFloat(current_font_size)))
        didotFontButton.animation = "pop"
        didotFontButton.animate()
    }
    @IBAction func changeFont2(_ sender: Any) {
        current_font = "Courier"
        delegate4?.changeFont(UIFont(name: "Courier", size: CGFloat(current_font_size)))
        courierFontButton.animation = "pop"
        courierFontButton.animate()
    }
    @IBAction func fontGeorgia(_ sender: Any) {
        current_font = "Georgia"
        delegate4?.changeFont(UIFont(name: "Georgia", size: CGFloat(current_font_size)))
        georgiaFontButton.animation = "pop"
        georgiaFontButton.animate()
    }
    @IBAction func fontGillSans(_ sender: Any) {
        current_font = "Gill Sans"
        delegate4?.changeFont(UIFont(name: "Gill Sans", size: CGFloat(current_font_size)))
        gsFontButton.animation = "pop"
        gsFontButton.animate()
    }
    @IBAction func fontHelveticaNeue(_ sender: Any) {
        current_font = "Helvetica Neue"
        delegate4?.changeFont(UIFont(name: "Helevetica Neue", size: CGFloat(current_font_size)))
        hnFontButton.animation = "pop"
        hnFontButton.animate()
    }
    @IBAction func fontOptima(_ sender: Any) {
        current_font = "Optima Regular"
        delegate4?.changeFont(UIFont(name: "Optima Regular", size: CGFloat(current_font_size)))
        optimaFontButton.animation = "pop"
        optimaFontButton.animate()
    }
    @IBAction func fontTNR(_ sender: Any) {
        current_font = "Times New Roman"
        delegate4?.changeFont(UIFont(name: "Times New Roman", size: CGFloat(current_font_size)))
        tnrFontButton.animation = "pop"
        tnrFontButton.animate()
    }
    @IBAction func fontVerdana(_ sender: Any) {
        current_font = "Verdana"
        delegate4?.changeFont(UIFont(name: "Verdana", size: CGFloat(current_font_size)))
        verdanaFontButton.animation = "pop"
        verdanaFontButton.animate()
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
