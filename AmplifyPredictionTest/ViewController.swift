//
//  ViewController.swift
//  AmplifyPredictionTest
//
//  Created by Keishin CHOU on 2019/12/24.
//  Copyright © 2019 Keishin CHOU. All rights reserved.
//

import AVFoundation
import NaturalLanguage
import UIKit

import Amplify

class ViewController: UIViewController {
    
    var audioData: Data?
    var player: AVAudioPlayer?
    
    let str = "無料利用枠。1ヶ月200万文字を12ヶ月間。無料利用枠は、最初の翻訳リクエストを作成した日から12ヶ月間ご利用いただけます。無料使用の有効期限が切れた場合、またはアプリケーションでの使用量が無料利用枠を超えた場合は、従量課金制での標準料金が発生します。"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        detectText(URL(string: "https://user-images.githubusercontent.com/22829656/63222534-f8579a00-c1db-11e9-9f2b-d43fec6e7142.png")!)
        
        
    }
    @IBAction func buttonTapped(_ sender: Any) {        
        textToSpeech(text: str)
        if let language = detectedLangauge(for: str) {
            print(language)
        }
    }
    
    func detectedLangauge(for string: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(string)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        let detectedLangauge = Locale.current.localizedString(forIdentifier: languageCode)
        return detectedLangauge
    }
    
    func detectText(_ image: URL) {
        _ = Amplify.Predictions.identify(type: .detectText(.plain), image: image, options: PredictionsIdentifyRequest.Options(), listener: { (event) in
            switch event {
            case .completed(let result):
                let data = result as! IdentifyTextResult
//                self.setNewText(result: data)
                print("data is \(data)")
                print("result is \(result)")
            case .failed(let error):
                print(error)
            default:
                print("")
            }
        })
    }
    
    func textToSpeech(text: String) {
        let options = PredictionsTextToSpeechRequest.Options(voiceType: .japaneseFemaleMizuki, pluginOptions: nil)

        _ = Amplify.Predictions.convert(textToSpeech: text, options: options, listener: { (event) in

            switch event {
            case .completed(let result):
                print(result.audioData)
                self.audioData = result.audioData
                self.player = try? AVAudioPlayer(data: result.audioData)
                self.player?.play()
            default:
                print("")

            }
        })
    }


}

