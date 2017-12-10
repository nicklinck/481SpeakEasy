//
//  undoPopoverViewController.swift
//  Speech
//
//  Created by Nick Linck on 11/15/17.
//  Copyright © 2017 Google. All rights reserved.
//

import UIKit

protocol ClassGetSelectedWordDelegate: class {
    func getSelectedWord(_ word: String?)
}

class undoPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClassGetPredictedWordsDelegate {
    
    weak var selectedWordDelegate: ClassGetSelectedWordDelegate?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*@IBAction func replaceButtonPressed(_ sender: Any) {
        //this should tell the popover to tell the main view controller to dismiss it.
        print("popover closed2: ", selectedWord)
        selectedWordDelegate?.getSelectedWord(selectedWord)
        self.dismiss(animated: false, completion: nil)
        selectedWord = ""
    }*/

    
    var cell_array = ["did", "not", "work"]
    func getPredictedWords(_ words: Array<String>?) -> Array<String>{
        print("getPredictedWords! ", words!)
        cell_array = words!
        return (words)!
    }
    
    //number of rows in the table
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 4
    }
    
    var cell2: OtherInputTableViewCell!
    
    @IBAction func replaceButtonIsPressed(_ sender: Any) {
        //var otherCell = OtherInputTableViewCell()
        //otherCell.configure(text: "hi", placeholder: "If none are correct")
        selectedWordDelegate?.getSelectedWord(cell2.otherTextField.text)
        self.dismiss(animated: false, completion: nil)
    }
    
    //creating table view cell
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        print("setting up table view")
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "predictedWordCell")
        if indexPath.row != 3{
            cell.textLabel?.text = cell_array[indexPath.row]
        }
        print("index row: ", indexPath.row)
        if indexPath.row == 3{
            cell2 = tableView.dequeueReusableCell(withIdentifier: "TextFieldsCell") as! OtherInputTableViewCell
            
            cell2.configure(text: "", placeholder: "If none are correct")
            return cell2
        }
        return cell
    }
    
    //
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
        
        print(currentCell.textLabel!.text)
        
        var selectedWord = currentCell.textLabel!.text!
        selectedWordDelegate?.getSelectedWord(selectedWord)
        self.dismiss(animated: false, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
