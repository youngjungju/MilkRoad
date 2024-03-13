import Foundation
import AVFoundation

var soundtrack: AVAudioPlayer!

func playSound(sound: String) {
    let url = Bundle.main.url(forResource: sound, withExtension: "mp3")
    
    guard url != nil else {
        return
    }
    do {
        soundtrack = try AVAudioPlayer(contentsOf: url!)
        soundtrack?.setVolume(0.1, fadeDuration: 0.1)
        soundtrack?.play()
        soundtrack.numberOfLoops = -1
        
    } catch {
        print("error")
    }
    
    
}
