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
var current_font_color_int = 0
var current_font_size_int = 0
var current_font_int = 7
var current_background_color_int = 3

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
    
    func selected(currentButton: Int, buttonType: [SpringButton]) {
        if(buttonType != backgroundButtons) {
            for buttons in buttonType {
                buttons.backgroundColor = .white
            }
            buttonType[currentButton].backgroundColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
        }
        else {
            for buttons in buttonType {
                buttons.setTitleColor(.white, for: .normal)
            }
            buttonType[currentButton].setTitleColor(UIColor(red: 61/255.0, green: 136/255.0, blue: 209/255.0, alpha: 1.0), for: .normal)
        }
        if(buttonType == fontColorButtons) {
            current_font_color_int = currentButton
        }
        else if(buttonType == fontSizeButtons) {
            current_font_size_int = currentButton
        }
        else if(buttonType == fontButtons) {
            current_font_int = currentButton
        }
        else {
            current_background_color_int = currentButton
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        self.backgroundButtons = [self.blackBackgroundButton, self.darkGreyBackgroundButton, self.lightGreyBackgroundButton, self.defaultBackgroundButton, self.blueBackgroundButton, self.greenBackgroundButton, self.yellowBackgroundButton, self.orangeBackgroundButton, self.redBackgroundButton, self.purpleBackgroundButton, self.beccasBackgroundButton, self.chrisBackgroundButton, self.javierBackgroundButton, self.nickBackgroundButton]
        self.fontColorButtons = [self.blackFontColorButton, self.greyFontColorButton, self.blueFontColorButton, self.redFontColorButton]
        self.fontSizeButtons = [self.font14Button, self.font18Button, self.font22Button, self.font26Button, self.font30Button]
        self.fontButtons = [self.atFontButton, self.arialFontButton, self.copperplateFontButton, self.courierFontButton, self.didotFontButton, self.georgiaFontButton, self.gsFontButton, self.hnFontButton, self.optimaFontButton, self.tnrFontButton, self.verdanaFontButton]
        selected(currentButton: current_background_color_int, buttonType: backgroundButtons)
        selected(currentButton: current_font_color_int, buttonType: fontColorButtons)
        selected(currentButton: current_font_size_int, buttonType: fontSizeButtons)
        selected(currentButton: current_font_int, buttonType: fontButtons)
        
        
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
        selected(currentButton: 0, buttonType: backgroundButtons)
        blackBackgroundButton.animate()
    }
    
    @IBAction func darkGreyBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor.darkGray)
        darkGreyBackgroundButton.animation = "pop"
        selected(currentButton: 1, buttonType: backgroundButtons)
        darkGreyBackgroundButton.animate()
    }
    @IBAction func lightGreyBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor.lightGray)
        lightGreyBackgroundButton.animation = "pop"
        selected(currentButton: 2, buttonType: backgroundButtons)
        lightGreyBackgroundButton.animate()
    }
    @IBAction func changeDefaultBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 20/255.0, green: 50/255.0, blue: 64/255.0, alpha: 1.0))
        defaultBackgroundButton.animation = "pop"
        selected(currentButton: 3, buttonType: backgroundButtons)
        defaultBackgroundButton.animate()
    }
    @IBAction func blueBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 25/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1.0))
        blueBackgroundButton.animation = "pop"
        selected(currentButton: 4, buttonType: backgroundButtons)
        blueBackgroundButton.animate()
    }
    @IBAction func greenBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 0/255.0, green: 50/255.0, blue: 0/255.0, alpha: 1.0))
        greenBackgroundButton.animation = "pop"
        selected(currentButton: 5, buttonType: backgroundButtons)
        greenBackgroundButton.animate()
    }
    @IBAction func yellowBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 227/255.0, green: 207/255.0, blue: 13/255.0, alpha: 1.0))
        yellowBackgroundButton.animation = "pop"
        selected(currentButton: 6, buttonType: backgroundButtons)
        yellowBackgroundButton.animate()
    }
    @IBAction func orangeBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 223/255.0, green: 124/255.0, blue: 2/255.0, alpha: 1.0))
        orangeBackgroundButton.animation = "pop"
        selected(currentButton: 7, buttonType: backgroundButtons)
        orangeBackgroundButton.animate()
    }
    @IBAction func redBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 131/255.0, green: 4/255.0, blue: 4/255.0, alpha: 1.0))
        redBackgroundButton.animation = "pop"
        selected(currentButton: 8, buttonType: backgroundButtons)
        redBackgroundButton.animate()
    }
    @IBAction func purpleBackground(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 69/255.0, green: 3/255.0, blue: 116/255.0, alpha: 1.0))
        purpleBackgroundButton.animation = "pop"
        selected(currentButton: 9, buttonType: backgroundButtons)
        purpleBackgroundButton.animate()
    }
    @IBAction func beccasFavorite(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 92/255.0, green: 28/255.0, blue: 109/255.0, alpha: 1.0))
        beccasBackgroundButton.animation = "pop"
        selected(currentButton: 10, buttonType: backgroundButtons)
        beccasBackgroundButton.animate()
    }
    @IBAction func chrisFavorite(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 109/255.0, green: 169/255.0, blue: 225/255.0, alpha: 1.0))
        chrisBackgroundButton.animation = "pop"
        selected(currentButton: 11, buttonType: backgroundButtons)
        chrisBackgroundButton.animate()
    }
    @IBAction func javiersPick(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 17/255.0, green: 106/255.0, blue: 163/255.0, alpha: 1.0))
        javierBackgroundButton.animation = "pop"
        selected(currentButton: 12, buttonType: backgroundButtons)
        javierBackgroundButton.animate()
    }
    @IBAction func NicksPick(_ sender: Any) {
        delegate?.changeBackgroundColor(UIColor(red: 255/255.0, green: 159/255.0, blue: 21/255.0, alpha: 1.0))
        nickBackgroundButton.animation = "pop"
        selected(currentButton: 13, buttonType: backgroundButtons)
        nickBackgroundButton.animate()
    }
    
    //Font Colors
    @IBAction func changeFontColorBlack(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.black)
        blackFontColorButton.animation = "pop"
        selected(currentButton: 0, buttonType: fontColorButtons)
        blackFontColorButton.animate()
    }
    @IBAction func changeFontColorGrey(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.gray)
        greyFontColorButton.animation = "pop"
        selected(currentButton: 1, buttonType: fontColorButtons)
        greyFontColorButton.animate()
    }
    @IBAction func changeFontColorRed(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.red)
        redFontColorButton.animation = "pop"
        selected(currentButton: 3, buttonType: fontColorButtons)
        redFontColorButton.animate()
    }
    @IBAction func changeFontColorBlue(_ sender: Any) {
        delegate2?.changeFontColor(UIColor.blue)
        blueFontColorButton.animation = "pop"
        selected(currentButton: 2, buttonType: fontColorButtons)
        blueFontColorButton.animate()
    }
    
    //Font Size
    @IBAction func fontSize30(_ sender: Any) {
        current_font_size = 30
        delegate3?.changeFontSize(UIFont(name: current_font, size: 30))
        font30Button.animation = "pop"
        selected(currentButton: 4, buttonType: fontSizeButtons)
        font30Button.animate()
    }
    @IBAction func fontSize14(_ sender: Any) {
        current_font_size = 14
        delegate3?.changeFontSize(UIFont(name: current_font, size: 14))
        font14Button.animation = "pop"
        selected(currentButton: 0, buttonType: fontSizeButtons)
        font14Button.animate()
    }
    @IBAction func fontSize18(_ sender: Any) {
        current_font_size = 18
        delegate3?.changeFontSize(UIFont(name: current_font, size: 18))
        font18Button.animation = "pop"
        selected(currentButton: 1, buttonType: fontSizeButtons)
        font18Button.animate()
    }
    @IBAction func fontSize22(_ sender: Any) {
        current_font_size = 22
        delegate3?.changeFontSize(UIFont(name: current_font, size: 22))
        font22Button.animation = "pop"
        selected(currentButton: 2, buttonType: fontSizeButtons)
        font22Button.animate()
    }
    @IBAction func fontSize26(_ sender: Any) {
        current_font_size = 26
        delegate3?.changeFontSize(UIFont(name: current_font, size: 26))
        font26Button.animation = "pop"
        selected(currentButton: 3, buttonType: fontSizeButtons)
        font26Button.animate()
    }
    
    //Fonts
    @IBAction func fontAmericanTypeWriter(_ sender: Any) {
        current_font = "American Typewriter"
        delegate4?.changeFont(UIFont(name: "American Typewriter", size: CGFloat(current_font_size)))
        atFontButton.animation = "pop"
        selected(currentButton: 0, buttonType: fontButtons)
        atFontButton.animate()
    }
    @IBAction func fontArial(_ sender: Any) {
        current_font = "Arial"
        delegate4?.changeFont(UIFont(name: "Arial", size: CGFloat(current_font_size)))
        arialFontButton.animation = "pop"
        selected(currentButton: 1, buttonType: fontButtons)
        arialFontButton.animate()
    }
    @IBAction func fontCopperplate(_ sender: Any) {
        current_font = "Copperplate"
        delegate4?.changeFont(UIFont(name: "Copperplate", size: CGFloat(current_font_size)))
        copperplateFontButton.animation = "pop"
        selected(currentButton: 2, buttonType: fontButtons)
        copperplateFontButton.animate()
    }
    
    @IBAction func changeFont1(_ sender: Any) {
        current_font = "Didot"
        delegate4?.changeFont(UIFont(name: "Didot", size: CGFloat(current_font_size)))
        selected(currentButton: 4, buttonType: fontButtons)
        didotFontButton.animation = "pop"
        didotFontButton.animate()
    }
    @IBAction func changeFont2(_ sender: Any) {
        current_font = "Courier"
        delegate4?.changeFont(UIFont(name: "Courier", size: CGFloat(current_font_size)))
        courierFontButton.animation = "pop"
        selected(currentButton: 3, buttonType: fontButtons)
        courierFontButton.animate()
    }
    @IBAction func fontGeorgia(_ sender: Any) {
        current_font = "Georgia"
        delegate4?.changeFont(UIFont(name: "Georgia", size: CGFloat(current_font_size)))
        georgiaFontButton.animation = "pop"
        selected(currentButton: 5, buttonType: fontButtons)
        georgiaFontButton.animate()
    }
    @IBAction func fontGillSans(_ sender: Any) {
        current_font = "Gill Sans"
        delegate4?.changeFont(UIFont(name: "Gill Sans", size: CGFloat(current_font_size)))
        gsFontButton.animation = "pop"
        selected(currentButton: 6, buttonType: fontButtons)
        gsFontButton.animate()
    }
    @IBAction func fontHelveticaNeue(_ sender: Any) {
        current_font = "Helvetica Neue"
        delegate4?.changeFont(UIFont(name: "Helevetica Neue", size: CGFloat(current_font_size)))
        hnFontButton.animation = "pop"
        selected(currentButton: 7, buttonType: fontButtons)
        hnFontButton.animate()
    }
    @IBAction func fontOptima(_ sender: Any) {
        current_font = "Optima Regular"
        delegate4?.changeFont(UIFont(name: "Optima Regular", size: CGFloat(current_font_size)))
        optimaFontButton.animation = "pop"
        selected(currentButton: 8, buttonType: fontButtons)
        optimaFontButton.animate()
    }
    @IBAction func fontTNR(_ sender: Any) {
        current_font = "Times New Roman"
        delegate4?.changeFont(UIFont(name: "Times New Roman", size: CGFloat(current_font_size)))
        tnrFontButton.animation = "pop"
        selected(currentButton: 9, buttonType: fontButtons)
        tnrFontButton.animate()
    }
    @IBAction func fontVerdana(_ sender: Any) {
        current_font = "Verdana"
        delegate4?.changeFont(UIFont(name: "Verdana", size: CGFloat(current_font_size)))
        verdanaFontButton.animation = "pop"
        selected(currentButton: 10, buttonType: fontButtons)
        verdanaFontButton.animate()
    }

    
    private func loadSettings() {
        let setting1 = UIButton()
        
        guard let fontColor = Setting( button: setting1, string: "Blue") else {
            fatalError("Unable to instantiate fontColor")
        }
        settings += [fontColor]
    }
}
