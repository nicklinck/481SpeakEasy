# SpeakEasy Omega Release

This app demonstrates how to make streaming gRPC connections to the [Cloud Speech API](https://cloud.google.com/speech/) to recognize speech in recorded audio and using Datamuse API find words that match a given set of constraints and that are likely in a given context.

## Prerequisites
- An API key for the Cloud Speech API (See
  [the docs][getting-started] to learn more)
- An OSX machine or emulator
- [Xcode 9][xcode] or later
- [Cocoapods][cocoapods] version 1.0 or later

## Quickstart
- Clone this repo and `cd` into this directory.
- Run `./INSTALL`
- `open Speech.xcworkspace` to open this project in Xcode. Since we are using Cocoapods, be sure to open the workspace and not Speech.xcodeproj.
- In `Speech/SpeechRecognitionService.swift`, replace `YOUR_API_KEY` with the API key obtained above (use our key already inserted)
- Build and run the app.

## Using the App
- Tap the `Start Streaming` button to begin recording.
- Tap the `Stop Streaming` button to end the recording (can press `start streaming` to continue from the old text).
- Tap the `Clear` button to clear the text field.
- Tap the `Copy` button to copy text to the clipboard to be exported.
- Tap the `Undo` button to undo the last word on the screen.  A prompt will show up three likely alternatives or the user can manually type the word.
- Tap the `Settings` button to navigate to a new view to change the background color, font color, font size and font.
- Tap the `Export` button to export the current text field to a selected app.


## Running the App (Setting up Google Cloud)

- As with all Google Cloud APIs, every call to the Speech API must be associated
  with a project within the [Google Cloud Console][cloud-console] that has the
  Speech API enabled. This is described in more detail in the [getting started
  doc][getting-started], but in brief:
  - Create a project (or use an existing one) in the [Cloud
    Console][cloud-console]
  - [Enable billing][billing] and the [Speech API][enable-speech].
  - Create an [API key][api-key], and save this for later.

- Clone this repository on GitHub. If you have [`git`][git] installed, you can do this by executing the following command:

        $ git clone https://github.com/GoogleCloudPlatform/ios-docs-samples.git

    This will download the repository of samples into the directory
    `ios-docs-samples`.

- `cd` into this directory in the repository you just cloned, and run the command `pod install` to prepare all Cocoapods-related dependencies.

- `open Speech.xcworkspace` to open this project in Xcode. Since we are using Cocoapods, be sure to open the workspace and not Speech.xcodeproj.

- In Xcode's Project Navigator, open the `SpeechRecognitionService.swift` file within the `Speech` directory.

- Find the line where the `API_KEY` is set. Replace the string value with the API key obtained from the Cloud console above. This key is the credential used to authenticate all requests to the Speech API. Calls to the API are thus associated with the project you created above, for access and billing purposes.

- You are now ready to build and run the project. In Xcode you can do this by clicking the 'Play' button in the top left. This will launch the app on the simulator or on the device you've selected. Be sure that the 'Speech' target is selected in the popup near the top left of the Xcode window. In order to run this on your phone, plug in an IOS device to your computer which has IOS 11.1 or higher. In Xcode, go to your project settings and under General -> Signing and change "team" to your apple ID account. Then simply run the Xcode Project and the app will get installed on your phone. 

- Tap the `Start Streaming` button. This uses a custom AudioController class to capture audio in an in-memory instance of NSMutableData. When this data reaches a certain size, it is sent to the SpeechRecognitionService class, which streams it to the speech recognition service. Packets are streamed as instances of the RecognizeRequest object, and the first RecognizeRequest object sent also includes configuration information in an instance of InitialRecognizeRequest. As it runs, the AudioController logs the number of samples and average sample magnitude for each packet that it captures.

- Say a few words and wait for the display to update when your speech is recognized.

- Tap the `Stop Streaming` button to stop capturing audio and close your gRPC connection.

[vision-zip]: https://github.com/GoogleCloudPlatform/cloud-vision/archive/master.zip
[getting-started]: https://cloud.google.com/vision/docs/getting-started
[cloud-console]: https://console.cloud.google.com
[git]: https://git-scm.com/
[xcode]: https://developer.apple.com/xcode/
[billing]: https://console.cloud.google.com/billing?project=_
[enable-speech]: https://console.cloud.google.com/apis/api/speech.googleapis.com/overview?project=_
[api-key]: https://console.cloud.google.com/apis/credentials?project=_
[cocoapods]: https://cocoapods.org/
[gRPC Objective-C setup]: https://github.com/grpc/grpc/tree/master/src/objective-c

