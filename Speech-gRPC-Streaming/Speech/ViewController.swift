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

let SAMPLE_RATE = 16000
var currentText = ""
//var previousStringsStack = []

let colorArray = [UIColor.black, UIColor.gray, UIColor.blue, UIColor.red]

let buttonColor = UIColor(red: 61/255.0, green: 136/255.0, blue: 209/255.0, alpha: 1.0)
let javierColor = UIColor(red: 17/255.0, green: 106/255.0, blue: 163/255.0, alpha: 1.0)
let defaultColor = UIColor(red: 20/255.0, green: 50/255.0, blue: 64/255.0, alpha: 1.0)


let backgroundColorArray = [UIColor.black, UIColor.darkGray, UIColor.lightGray, defaultColor, UIColor(red: 25/255.0, green: 25/255.0, blue: 112/255.0, alpha: 1.0), javierColor, UIColor(red: 0/255.0, green: 50/255.0, blue: 0/255.0, alpha: 1.0), UIColor(red: 227/255.0, green: 207/255.0, blue: 13/255.0, alpha: 1.0), UIColor(red: 223/255.0, green: 124/255.0, blue: 2/255.0, alpha: 1.0), UIColor(red: 131/255.0, green: 4/255.0, blue: 4/255.0, alpha: 1.0), UIColor(red: 69/255.0, green: 3/255.0, blue: 116/255.0, alpha: 1.0)]


extension String {
    var byWords: [String] {
        var byWords:[String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) {
            guard let word = $0 else { return }
            print($1,$2,$3)
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
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.stopStreaming.isHidden = true
    AudioController.sharedInstance.delegate = self
    textView.font = UIFont(name: "Helvetica Neue", size: 18)
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
                for result in response.resultsArray! {
                   // print("result: ", result)
                    
                    if let result = result as? StreamingRecognitionResult {
                        if result.isFinal {
                            finished = true
                        }
                        //for alternative in result.alternativesArray{
                            var alternative = result.alternativesArray[0]
                            if let alternative = alternative as? SpeechRecognitionAlternative{
                                //print("alternative transcript: ", alternative.transcript)
                                if result.stability > 0.8 {
                                    strongSelf.textView.text = currentText + alternative.transcript
                                    //previousStringsStack.append(strongSelf.textView.text.lastWord)
                                }
                                if finished{
                                    print("got here")
                                    //strongSelf.textView.text = currentText + alternative.transcript
                                }
                            }
                            
                        //}
                    }
                    
                    
                }
                //strongSelf.textView.text = response.description
                
                if finished {
                    //strongSelf.stopAudio(strongSelf)
                    print("is finished!")
                    //strongSelf.textView.text.append(alternative.transcript)
                    currentText = strongSelf.textView.text + " "
                }
            }
      })
      self.audioData = NSMutableData()
    }
  }
    @IBAction func exportButtonPressed(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [textView.text], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = (sender as! UIBarButtonItem)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var undoButton: UIButton!
    @IBAction func undoButtonPressed(_ sender: Any) {
        /*let tempText = self.textView.text
        let endIndex = tempText?.index((tempText?.endIndex)!, offsetBy: -1*((tempText?.lastWord.count)!+1))
        self.textView.text = tempText?.substring(with: tempText!.startIndex..<endIndex)
        stopAudio(self)
        recordAudio(self)
        */
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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print(UserDefaults.standard.integer(forKey: "fontColor"))
        if let fontColor = UserDefaults.standard.value(forKey: "fontColor") as? Int {
            self.textView.textColor = colorArray[fontColor]
        }
        print(UserDefaults.standard.integer(forKey: "backgroundColor"))
        if let backgroundColor = UserDefaults.standard.value(forKey: "backgroundColor") as? Int {
            self.view.backgroundColor = backgroundColorArray[backgroundColor]
        }
    }
    
}
