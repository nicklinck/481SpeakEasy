//
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import UIKit
import AVFoundation
import googleapis
import Foundation
import SwiftyJSON


let SAMPLE_RATE = 16000
let userDefaults =  UserDefaults.standard

var currentText = ""
var altArray: [String] = []
var altDict: [String: [String: Int]] = [:]
var totalDict: [String: Int] = [:]
var undoDict: [String: Int] = [:]
var undone = ""
//var previousStringsStack = []

let buttonColor = UIColor(red: 61/255.0, green: 136/255.0, blue: 209/255.0, alpha: 1.0)
let beccaColor = UIColor(red: 92/255.0, green: 28/255.0, blue: 109/255.0, alpha: 1.0)
let chrisColor = UIColor(red: 109/255.0, green: 169/255.0, blue: 225/255.0, alpha: 1.0)
let javierColor = UIColor(red: 17/255.0, green: 106/255.0, blue: 163/255.0, alpha: 1.0)
let nickColor = UIColor(red: 255/255.0, green: 159/255.0, blue: 21/255.0, alpha: 1.0)


extension String {
    var byWords: [String] {
        var byWords:[String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) {
            guard let word = $0 else { return }
            let word1 = $1, word2 = $2, word3 = $3
            //print($1,$2,$3)
            byWords.append(word)
        }
        return byWords
    }
    func firstWords(_ max: Int) -> [String] {
        return Array(byWords.prefix(max))
    }
    var firstWord: String {
        return byWords.first ?? ""
    }
    func lastWords(_ max: Int) -> [String] {
        return Array(byWords.suffix(max))
    }
    var lastWord: String {
        return byWords.last ?? ""
    }
}


// using for getting predicted words for undo popover
protocol ClassGetPredictedWordsDelegate: class {
    func getPredictedWords(_ words: Array<String>?) -> Array<String>
}

class ViewController : UIViewController, UIPopoverPresentationControllerDelegate, AudioControllerDelegate, ClassBackgroundDelegate, ClassFontColorDelegate, ClassFontSizeDelegate, ClassFontDelegate, ClassGetSelectedWordDelegate {
  
  weak var getPredictedWordsDelegate: ClassGetPredictedWordsDelegate?
    
  @IBOutlet weak var textView: UITextView!
  var audioData: NSMutableData!
    var timer = Timer()

    let backColor = UIColor(red: 20/255.0, green: 50/255.0, blue: 64/255.0, alpha: 1.0)
    
  override func viewDidLoad() {
    // initialize our arrays
    getScore(type: "undo")
    getScore(type: "total")
    getScore(type: "alt")
    print(totalDict)
    print(undoDict)
    print(altDict)
    super.viewDidLoad()
    self.stopStreaming.isHidden = true
    AudioController.sharedInstance.delegate = self
    view.backgroundColor = backColor
  }

  @objc func invalidateTimer(){
    timer.invalidate()
    _ = AudioController.sharedInstance.stop()
    SpeechRecognitionService.sharedInstance.stopStreaming()
    recordAudio(self)
  }

    @IBOutlet weak var startStreaming: UIButton!
    @IBAction func recordAudio(_ sender: NSObject) {
    timer = Timer.scheduledTimer(timeInterval: 60, target:self, selector: #selector(ViewController.invalidateTimer), userInfo: nil, repeats: true)
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSessionCategoryRecord)
    } catch {

    }
    audioData = NSMutableData()
    _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
    SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
    _ = AudioController.sharedInstance.start()
        self.startStreaming.isHidden = true
        self.stopStreaming.isHidden = false
  }
    
    
    @IBOutlet weak var stopStreaming: UIButton!
    @IBAction func stopAudio(_ sender: NSObject) {
        // update json files
        updateScore(type: "total")
        updateScore(type: "undo")
        updateScore(type: "alt")
    timer.invalidate()
    _ = AudioController.sharedInstance.stop()
    SpeechRecognitionService.sharedInstance.stopStreaming()
        self.stopStreaming.isHidden = true
        self.startStreaming.isHidden = false
    
  }

  func processSampleData(_ data: Data) -> Void {
    audioData.append(data)

    // We recommend sending samples in 100ms chunks
    let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
      * Double(SAMPLE_RATE) /* samples/second */
      * 2 /* bytes/sample */);

    if (audioData.length > chunkSize) {
      SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                              completion:
        { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            //print("last char in audio: ", strongSelf.textView.text.characters.last )
            //if strongSelf.textView.text.characters.last != " "{
            //  print("space added at beinning of text conversion")
                //strongSelf.textView.text = (strongSelf.textView.text)! + " "
                //currentText = (strongSelf.textView.text)!
            //}
            
            if let error = error {
                strongSelf.textView.text = error.localizedDescription
            } else if let response = response {
                var finished = false
                //print("response: ", response["results"])
                //print("Results")
                //print(response.resultsArray)
                for result in response.resultsArray! {
                   // print("result: ", result)
                    
                    if let result = result as? StreamingRecognitionResult {
                        if result.isFinal {
                            finished = true
                        }
                        
                        //print("Alternative")
                        //print(result.alternativesArray)
                        var alternative = result.alternativesArray[0]
                            if let alternative = alternative as? SpeechRecognitionAlternative{

                                //print("alternative transcript: ", alternative.transcript)
                                if result.stability > 0.8 {
                                    if currentText.characters.last != " "{
                                        var percent = self?.getUndoPercent(text: (alternative.transcript.lastWord).trimmingCharacters(in: .whitespaces)) as! Float
                                        print("percent \(percent)")
                                        // If it has been wrongly predicted 60% of the time or more, replace with next best contender
                                        if percent > 0.60 {
                                            var alternatives = self?.getAlternatives(url_param: (alternative.transcript.lastWord).trimmingCharacters(in: .whitespaces))
                                            let tempText = strongSelf.textView.text
                                            var offset = (tempText?.lastWord.count)!+1
                                            if offset > (tempText?.count)!{
                                                offset = (tempText?.count)!
                                            }
                                            if let endIndex = tempText?.index((tempText?.endIndex)!, offsetBy: -1*offset) {
                                                strongSelf.textView.text = String(tempText![..<endIndex])    // pos is an index, it works
                                            }
                                            strongSelf.textView.text = currentText + " " + alternatives![0]
                                        }
                                        else{
                                            strongSelf.textView.text = currentText + " " + alternative.transcript
                                        }
                                        //self?.addTotalScore(text: (alternative.transcript.lastWord).trimmingCharacters(in: .whitespaces))
                                        //print(self?.getUndoPercent(text: (strongSelf.textView.text.lastWord).trimmingCharacters(in: .whitespaces)))
                                    }
                                    
                                    //previousStringsStack.append(strongSelf.textView.text.lastWord)
                                }
                                if finished{
                                    // print("got here")
                                    //strongSelf.textView.text = currentText + alternative.transcript
                                }
                            }
                        
                        //}
                    }
                    
                    
                }
                //strongSelf.textView.text = response.description
                
                if finished {
                    //strongSelf.stopAudio(strongSelf)
                    //print("is finished!")
                    //strongSelf.textView.text.append(alternative.transcript)
                    currentText = strongSelf.textView.text
                }
            }
      })
      self.audioData = NSMutableData()
    }
  }
    
    // returns json string
    func getAlternatives(url_param: String) -> [String] {
        var need_wait = false
        print("getting alternatives")
        var alternatives = [String]()
        var altArray: [String: Int] = [:]
        // is it in the json?
        if (altDict[url_param] != nil) {
            print(altDict[url_param])
            altArray = altDict[url_param]!
            var keys = Array(altArray.keys)
            alternatives = keys
        }
        else {
            need_wait = true
            // get the words from datamuse and populate the json
            var data: [String: AnyObject] = [:]
            let url = URL(string: "https://api.datamuse.com/words?sl=" + url_param)
            group.enter()
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSON(data: data!)
                        alternatives = [json[1]["word"].string!, json[2]["word"].string!, json[3]["word"].string!]
                    }catch let error as NSError{
                        print(error)
                    }
                }
                self.group.leave()
            }).resume()
            
        }
        
        
        group.wait()
        if (need_wait){
            print("ALTERNATIVES \(alternatives)")
            var newJson: [String: Int] = [:]
            for word in alternatives {
                print("DIS WORD \(word)")
                newJson[word] = 0
            }
            print("NEW JSON \(newJson)")
            altDict[url_param] = newJson
            print("ALT DICTIONARY \(altDict)")
        }
        print("end of alternatives", alternatives)
        return alternatives
    }
        

    @IBAction func exportButtonPressed(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [textView.text], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            //popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    /*func getThreeWords(text: String, endIndex: String.Index){
        // get last word
        let lastWord = text.substring(from: endIndex)
        // see if last word is in undo map
        let listObj = userDefaults.object(forKey: lastWord)
        if let list = listObj as? Dictionary<String, Int>{
            print(list)
        }
        else {
            for str in altArray {
                // set the val for key to be first three words in the altArray
            }
        }
    }*/
    
    // function to make undo popover show correctly
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func getScore(type: String){
        var json: [String: Int] = [:]
        var altJson: [String: [String: Int]] = [:]
        var url = URL(string: "")
        if (type == "total"){
            url = URL(string: "https://api.myjson.com/bins/smgqj")!
        }
        else if (type == "undo"){
            url = URL(string: "https://api.myjson.com/bins/h6q7f")!
        }
        else {
            url = URL(string: "https://api.myjson.com/bins/1gftxr")!
        }
        // create post request
        var curr_score = 0
        var request = URLRequest(url: url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        group.enter()
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            if let responseJSON = responseJSON as? [String: Int] {
                json = responseJSON
            }
            else if let responseJSON = responseJSON as? [String: [String: Int]]{
                altJson = responseJSON
            }
            self.group.leave()
        }
        task.resume()
        group.wait()
        if (type == "total") {
            totalDict = json
        }
        else if (type == "undo"){
            undoDict = json
        }
        else {
            altDict = altJson
    }
        
       
        
        
        // KEEP: this is how we put the data back
//        //let jsonDict = [text: curr_score]
//        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
//        let put_url = URL(string: "https://api.myjson.com/bins/smgqj")!
//
//        var put_request = URLRequest(url: put_url)
//        put_request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        put_request.httpMethod = "PUT"
//
//        // insert json data to the request
//        put_request.httpBody = jsonData
//        var backToString = String(data: jsonData, encoding: String.Encoding.utf8) as String!
//        group.enter()
//        let put = URLSession.shared.dataTask(with: put_request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                //print(responseJSON)
//            }
//            self.group.leave()
//        }
//        put.resume()
//        group.wait()
    }
    
    func updateScore(type: String){
        print("IN HERE")
        var dict: [String: Int] = [:]
        var alterDict: [String: [String:Int]] = [:]
        var url = URL(string: "")
        if (type == "total"){
            url = URL(string: "https://api.myjson.com/bins/smgqj")!
            dict = totalDict
        }
        else if (type == "undo"){
            url = URL(string: "https://api.myjson.com/bins/h6q7f")!
            dict = undoDict
        }
        else {
            url = URL(string: "https://api.myjson.com/bins/1gftxr")!
            alterDict = altDict
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: [])
        let alterJsonData = try! JSONSerialization.data(withJSONObject: alterDict, options: [])
        let put_url = url

        var put_request = URLRequest(url: put_url!)
        put_request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        put_request.httpMethod = "PUT"

        // insert json data to the request
        if (type == "alt"){
             put_request.httpBody = alterJsonData
        }
        else {
             put_request.httpBody = jsonData
        }
        
        group.enter()
        let put = URLSession.shared.dataTask(with: put_request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                //print(responseJSON)
            }
            self.group.leave()
        }
        put.resume()
        group.wait()
    }
    
//    func addUndoScore(text: String){
//        // create post request
//        var curr_score = 0
//        var json: [String: Int] = [:]
//        let url = URL(string: "https://api.myjson.com/bins/h6q7f")!
//        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "GET"
//        group.enter()
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments])
//            if let responseJSON = responseJSON as? [String: Int] {
//                json = responseJSON
//            }
//            self.group.leave()
//        }
//        task.resume()
//        group.wait()
//
//        var jsonDict: [String: Any]
//
//        if json[text] != nil {
//            curr_score = json[text] as! Int
//        }
//
//        json[text] = curr_score + 1
//
//        jsonDict = json
//
//        //let jsonDict = [text: curr_score]
//        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
//        let put_url = URL(string: "https://api.myjson.com/bins/h6q7f")!
//
//        var put_request = URLRequest(url: put_url)
//        put_request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        put_request.httpMethod = "PUT"
//
//        // insert json data to the request
//        put_request.httpBody = jsonData
//
//        group.enter()
//        let put = URLSession.shared.dataTask(with: put_request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                //print(responseJSON)
//            }
//            self.group.leave()
//        }
//        put.resume()
//        group.wait()
//    }
//
    func getUndoPercent(text: String) -> Float {
        if totalDict[text] != nil && undoDict[text] != nil{
            return Float(undoDict[text]!) / Float(totalDict[text]!)
        }
        return 0
    }


    
    let group = DispatchGroup()
    @IBOutlet weak var undoButton: UIButton!
    @IBAction func undoButtonPressed(_ sender: Any) {
        print("Undo pressed")
        var recordAgain = false
        if self.startStreaming.isHidden == true {
            stopAudio(self)
            recordAgain = true
        }
        
        if self.textView.text != "" {
            let tempText = self.textView.text
            //addUndoScore(text: (tempText?.lastWord)!)
            var json = getAlternatives(url_param: (tempText?.lastWord)!)
            var offset = (tempText?.lastWord.count)!+1
            undone = (tempText?.lastWord)!
            if offset > (tempText?.count)!{
                offset = (tempText?.count)!
            }
            if let endIndex = tempText?.index((tempText?.endIndex)!, offsetBy: -1*offset) {
                self.textView.text = String(tempText![..<endIndex])    // pos is an index, it works
            }
            
            currentText = self.textView.text 
            getPredictedWordsDelegate?.getPredictedWords(json)
        }
        
        if recordAgain {
            recordAudio(self)
        }
        print("undo")
    }
    
    //undoPopoverViewController.delegate = self
    //Speech.undoPopoverViewController?.delegate = self
    private func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: undoPopoverViewController) {
        print("popover closed")
    }
    
    @IBOutlet weak var copyButton: UIButton!
    @IBAction func copyButtonPressed(_ sender: Any) {
        if let textRange = textView.selectedTextRange {
            UIPasteboard.general.string = textView.text(in: textRange)
            
            // if nothing is highlighted, then select all text, otherwise use the selected text
            if UIPasteboard.general.string == ""{
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)
                UIPasteboard.general.string = textView.text(in: textView.selectedTextRange!)
            }
        }
        
        print(UIPasteboard.general.string!)
    }
    
    @IBOutlet weak var clearButton: UIButton!
    @IBAction func clearButtonPressed(_ sender: Any) {
        textView.text = ""
        currentText = ""
    }
    
    //var globalPopoverController = popoverPresentationController()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("in view controller segue")
        // displaying undo popover
        if let popoverVC = segue.destination as? undoPopoverViewController {
            popoverVC.selectedWordDelegate = self
        }
        
        if segue.identifier == "showUndoPopover"{
            let popoverViewController = segue.destination
            popoverViewController.popoverPresentationController?.delegate = self
            getPredictedWordsDelegate = segue.destination as! ClassGetPredictedWordsDelegate
            return
        }
        
        //MARK: step 5 create a reference of Class B and bind them through the prepareforsegue method
        if let nav = segue.destination as? UINavigationController, let classBVC = nav.topViewController as? SettingTableViewController {
            classBVC.delegate = self
            classBVC.delegate2 = self
            classBVC.delegate3 = self
            classBVC.delegate4 = self
        }
        
    }
    
    func updateAlternates(key: String, newTop: String) {
        var currAlt: [String: Int] = altDict[key]!
        if (currAlt[newTop] != nil) {
            var score = currAlt[newTop]
            // replace current top with new top
            // is it the 2nd or 3rd currently?
            var keys = Array(currAlt.keys)
            if (newTop == keys[1]){
                print("NUMBER 2")
                var score0 = currAlt[keys[0]]
                var score2 = currAlt[keys[2]]
                // it's 2nd
                currAlt = [newTop: score! + 1, keys[0]: score0!, keys[2]: score2!]
            }
            else if (newTop == keys[2]){
                print("NUMBER 3")
                // it's 3rd
                var score0 = currAlt[keys[0]]
                var score1 = currAlt[keys[1]]
                // it's 2nd
                currAlt = [newTop: score! + 1, keys[0]: score0!, keys[1]: score1!]
            }
        }
        else {
            // new word that the user entered
            var keys = Array(currAlt.keys)
            var maxKey = ""
            if (currAlt[keys[0]]! > currAlt[keys[1]]! && currAlt[keys[0]]! > currAlt[keys[2]]!){
                // 0 is the max
                maxKey = keys[0]
            }
            else if (currAlt[keys[1]]! > currAlt[keys[0]]! && currAlt[keys[1]]! > currAlt[keys[2]]!){
                // 1 is the max
                maxKey = keys[1]
            }
            else {
                maxKey = keys[2]
            }
            var minKey = ""
            if (currAlt[keys[0]]! < currAlt[keys[1]]! && currAlt[keys[0]]! < currAlt[keys[2]]!){
                // 0 is the max
                minKey = keys[0]
            }
            else if (currAlt[keys[1]]! < currAlt[keys[0]]! && currAlt[keys[1]]! < currAlt[keys[2]]!){
                // 1 is the max
                minKey = keys[1]
            }
            else {
                minKey = keys[2]
            }
            
            // find the other
            var otherKey = ""
            if ((maxKey == keys[0] && minKey == keys[1]) || (minKey == keys[0] && maxKey == keys[1])){
                otherKey = keys[2]
            }
            else if ((maxKey == keys[0] && minKey == keys[2]) || (minKey == keys[0] && maxKey == keys[2])){
                otherKey = keys[1]
            }
            else {
                otherKey = keys[0]
            }
            
            var maxScore = currAlt[maxKey]
            var newTopScore = maxScore! + 1
            var currCopy = currAlt
            currAlt = [newTop: newTopScore, maxKey: currCopy[maxKey]!, otherKey: currCopy[otherKey]!]
        }
        altDict[key] = currAlt
        print("ALT \(altDict)")
    }
    
    func getSelectedWord(_ word: String?) {
        // word = the word the user selected from undo options
        
        
        if self.textView.text.characters.last == " "{
            self.textView.text = self.textView.text + word!
        }
        else{
            self.textView.text = self.textView.text + " " + word!
        }
        currentText = self.textView.text
        updateAlternates(key: undone, newTop: word!)
        print("it worked: ", word)
    }
    
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    //MARK: step 6 finally use the method of the contract here
    func changeBackgroundColor(_ color: UIColor?) {
        view.backgroundColor = color
        if(view.backgroundColor ==  UIColor.lightGray) {
            self.copyButton.setTitleColor(.black, for: .normal)
            self.clearButton.setTitleColor(.black, for: .normal)
            self.undoButton.setTitleColor(.black, for: .normal)
            self.settingButton.setTitleColor(.black, for: .normal)
            self.exportButton.setTitleColor(.black, for: .normal)
            
        }
        else if(view.backgroundColor == UIColor(red: 20/255.0, green: 50/255.0, blue: 64/255.0, alpha: 1.0)) {
            self.copyButton.setTitleColor(buttonColor, for: .normal)
            self.clearButton.setTitleColor(buttonColor, for: .normal)
            self.undoButton.setTitleColor(buttonColor, for: .normal)
            self.settingButton.setTitleColor(buttonColor, for: .normal)
            self.exportButton.setTitleColor(buttonColor, for: .normal)
        }
        else if (view.backgroundColor == beccaColor) {
            self.copyButton.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
            self.clearButton.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
            self.undoButton.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
            self.settingButton.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
            self.exportButton.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
        }
        else if (view.backgroundColor == chrisColor || view.backgroundColor == nickColor) {
            self.copyButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
            self.clearButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
            self.undoButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
            self.settingButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
            self.exportButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
        }
        else if (view.backgroundColor == javierColor) {
            self.copyButton.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
            self.clearButton.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
            self.undoButton.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
            self.settingButton.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
            self.exportButton.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
        }
        else {
            self.copyButton.setTitleColor(.white, for: .normal)
            self.clearButton.setTitleColor(.white, for: .normal)
            self.undoButton.setTitleColor(.white, for: .normal)
            self.settingButton.setTitleColor(.white, for: .normal)
            self.exportButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func changeFontColor(_ fontColor: UIColor?) {
        self.textView.textColor = fontColor
    }
    
    func changeFontSize(_ fontSize: UIFont?) {
        self.textView.font = fontSize
    }
    
    func changeFont(_ fontSize: UIFont?) {
        self.textView.font = fontSize
    }
    
    @IBAction func helpButton(_ sender: Any) {
        setupSpotlight()
    }
    
    
    
    func setupSpotlight() {
        let SpotlightMargin = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let startStopSLRect = CGRect(x: startStreaming.frame.origin.x, y: startStreaming.frame.origin.y, width: startStreaming.frame.size.width, height: startStreaming.frame.size.height)
        let startStopSpotlight = AwesomeSpotlight(withRect: startStopSLRect, shape: .roundRectangle, text: "Click to Start Recording", margin: SpotlightMargin)
        let startStopSpotlightDesc = AwesomeSpotlight(withRect: startStopSLRect, shape: .roundRectangle, text: "Click Stop Only After You See Your Last Word Spoken", margin: SpotlightMargin)
        let UndoSLRect = CGRect(x: undoButton.frame.origin.x, y: undoButton.frame.origin.y, width: undoButton.frame.size.width, height: undoButton.frame.size.height)
        let UndoSpotlight = AwesomeSpotlight(withRect: UndoSLRect, shape: .roundRectangle, text: "Undoes Previous Word Only", margin: SpotlightMargin)
        let CopySLRect = CGRect(x: copyButton.frame.origin.x, y: copyButton.frame.origin.y, width: copyButton.frame.size.width, height: copyButton.frame.size.height)
        let CopySpotlight = AwesomeSpotlight(withRect: CopySLRect, shape: .roundRectangle, text: "Copies Text to Clipboard", margin: SpotlightMargin)
        let ExportSLRect = CGRect(x: exportButton.frame.origin.x, y: exportButton.frame.origin.y, width: exportButton.frame.size.width, height: exportButton.frame.size.height)
        let ExportSpotlight = AwesomeSpotlight(withRect: ExportSLRect, shape: .roundRectangle, text: "Exports Text to Any Application", margin: SpotlightMargin)
        let ClearSLRect = CGRect(x: clearButton.frame.origin.x, y: clearButton.frame.origin.y, width: clearButton.frame.size.width, height: clearButton.frame.size.height)
        let ClearSpotlight = AwesomeSpotlight(withRect: ClearSLRect, shape: .roundRectangle, text: "Clears Text Field Above", margin: SpotlightMargin)
        let SettingsSLRect = CGRect(x: settingButton.frame.origin.x, y: settingButton.frame.origin.y, width: settingButton.frame.size.width, height: settingButton.frame.size.height)
        let SettingsSpotlight = AwesomeSpotlight(withRect: SettingsSLRect, shape: .roundRectangle, text: "Customize This Interface", margin: SpotlightMargin)
        let spotlightView = AwesomeSpotlightView(frame: view.frame, spotlight: [startStopSpotlight, startStopSpotlightDesc, UndoSpotlight, CopySpotlight, ExportSpotlight, ClearSpotlight, SettingsSpotlight])
        view.addSubview(spotlightView)
        spotlightView.enableSkipButton = true
        spotlightView.start()
    
    }
    

    
    
    
}
