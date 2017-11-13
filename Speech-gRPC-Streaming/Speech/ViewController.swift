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

class ViewController : UIViewController, AudioControllerDelegate, ClassBackgroundDelegate, ClassFontColorDelegate, ClassFontSizeDelegate, ClassFontDelegate {
  
@IBOutlet weak var textView: UITextView!
  var audioData: NSMutableData!
    var timer = Timer()

    let backColor = UIColor(red: 20/255.0, green: 50/255.0, blue: 64/255.0, alpha: 1.0)
    
  override func viewDidLoad() {
    
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
                                    strongSelf.textView.text = currentText + alternative.transcript
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
    func getAlternatives(url_param: String) -> [String: AnyObject] {
        var data: [String: AnyObject] = [:]
        let url = URL(string: "https://api.datamuse.com/words?sl=" + url_param)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSON(data: data!)
                    print(json[1]["word"])
                    print(json[2]["word"])
                    print(json[3]["word"])
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        return data
    }
        
//        let full_url = URL(string: "https://api.datamuse.com/words?sl=" + url)
//
//        let task = URLSession.shared.dataTask(with: full_url!) { data, response, error in
//            guard error == nil else {
//                print(error!)
//                return
//            }
//            guard let data = data else {
//                print("Data is empty")
//                return
//            }
//
//            json = (try! JSONSerialization.jsonObject(with: data, options: []) as? String)!
//
//            print("JSON String", json)
//
//
    @IBAction func exportButtonPressed(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [textView.text], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func getThreeWords(text: String, endIndex: String.Index){
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
    }
    

    
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
            var json = getAlternatives(url_param: (tempText?.lastWord)!)
            var offset = (tempText?.lastWord.count)!+1
            if offset > (tempText?.count)!{
                offset = (tempText?.count)!
            }
            if let endIndex = tempText?.index((tempText?.endIndex)!, offsetBy: -1*offset) {
                self.textView.text = String(tempText![..<endIndex])    // pos is an index, it works
            }
            currentText = self.textView.text + " "
        }
        
        if recordAgain {
            recordAudio(self)
        }
        
        print("undo")
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //MARK: step 5 create a reference of Class B and bind them through the prepareforsegue method
        if let nav = segue.destination as? UINavigationController, let classBVC = nav.topViewController as? SettingTableViewController {
            classBVC.delegate = self
            classBVC.delegate2 = self
            classBVC.delegate3 = self
            classBVC.delegate4 = self
        }
        
    }
    
    //MARK: step 6 finally use the method of the contract here
    func changeBackgroundColor(_ color: UIColor?) {
        view.backgroundColor = color
        if(view.backgroundColor ==  UIColor.lightGray) {
            self.copyButton.setTitleColor(.black, for: .normal)
            self.clearButton.setTitleColor(.black, for: .normal)
            self.undoButton.setTitleColor(.black, for: .normal)
            self.startStreaming.setTitleColor(.black, for: .normal)
            self.stopStreaming.setTitleColor(.black, for: .normal)
            
        }
        else if(view.backgroundColor == UIColor(red: 20/255.0, green: 50/255.0, blue: 64/255.0, alpha: 1.0)) {
            self.copyButton.setTitleColor(buttonColor, for: .normal)
            self.clearButton.setTitleColor(buttonColor, for: .normal)
            self.undoButton.setTitleColor(buttonColor, for: .normal)
            self.startStreaming.setTitleColor(buttonColor, for: .normal)
            self.stopStreaming.setTitleColor(buttonColor, for: .normal)
        }
        else if (view.backgroundColor == beccaColor) {
            self.copyButton.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
            self.clearButton.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
            self.undoButton.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
            self.startStreaming.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
            self.stopStreaming.setTitleColor(UIColor(red: 131/255.0, green: 182/255.0, blue: 126/255.0, alpha: 1.0), for: .normal)
        }
        else if (view.backgroundColor == chrisColor || view.backgroundColor == nickColor) {
            self.copyButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
            self.clearButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
            self.undoButton.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
            self.startStreaming.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
            self.stopStreaming.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 73/255.0, alpha: 1.0), for: .normal)
        }
        else if (view.backgroundColor == javierColor) {
            self.copyButton.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
            self.clearButton.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
            self.undoButton.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
            self.startStreaming.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
            self.stopStreaming.setTitleColor(UIColor(red: 249/255.0, green: 85/255.0, blue: 30/255.0, alpha: 1.0), for: .normal)
        }
        else {
            self.copyButton.setTitleColor(.white, for: .normal)
            self.clearButton.setTitleColor(.white, for: .normal)
            self.undoButton.setTitleColor(.white, for: .normal)
            self.startStreaming.setTitleColor(.white, for: .normal)
            self.stopStreaming.setTitleColor(.white, for: .normal)
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
    
    
    
}
