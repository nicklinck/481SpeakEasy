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

class ViewController : UIViewController, AudioControllerDelegate {
  @IBOutlet weak var textView: UITextView!
  var audioData: NSMutableData!
    var timer = Timer()

  override func viewDidLoad() {
    
    super.viewDidLoad()
    AudioController.sharedInstance.delegate = self
  }

  func invalidateTimer(){
    timer.invalidate()
    _ = AudioController.sharedInstance.stop()
    SpeechRecognitionService.sharedInstance.stopStreaming()
    recordAudio(self)
  }

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
  }

  @IBAction func stopAudio(_ sender: NSObject) {
    timer.invalidate()
    _ = AudioController.sharedInstance.stop()
    SpeechRecognitionService.sharedInstance.stopStreaming()
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
                    currentText = strongSelf.textView.text + " "
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
    

    
    @IBAction func undoButtonPressed(_ sender: Any) {
        print("Undo pressed")
        
        let tempText = self.textView.text
        var json = getAlternatives(url_param: (tempText?.lastWord)!)
        let endIndex = tempText?.index((tempText?.endIndex)!, offsetBy: -1*((tempText?.lastWord.count)!+1))
        self.textView.text = tempText?.substring(with: tempText!.startIndex..<endIndex)
        stopAudio(self)
        recordAudio(self)
        
    }
    
    
}
