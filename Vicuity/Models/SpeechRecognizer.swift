//
//  SpeechRecognizer.swift
//  Vicuity
//
//  Created by Nicholas Christian Irawan on 26/04/24.
//

import Foundation
import Speech

final class SpeechRecognizer: NSObject, SFSpeechRecognizerDelegate {
    
    @objc dynamic var recognizedText: String?
    @objc dynamic var isProcessing: Bool = false
    
    private let audioEngine = AVAudioEngine()
    private var inputNode: AVAudioInputNode?
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioSession: AVAudioSession?

    func start() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Couldn't configure the audio session properly")
        }
        
        inputNode = audioEngine.inputNode
        
        speechRecognizer = SFSpeechRecognizer()
        print("Supports on device recognition: \(speechRecognizer?.supportsOnDeviceRecognition == true ? "✅" : "🔴")")

        // Force specified locale
        // self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pl_PL"))
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        // Disable partial results
        // recognitionRequest?.shouldReportPartialResults = false
        
        // Enable on-device recognition
        // recognitionRequest?.requiresOnDeviceRecognition = true

        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable,
              let recognitionRequest = recognitionRequest,
              let inputNode = inputNode
        else {
            assertionFailure("Unable to start the speech recognition!")
            return
        }
        
        speechRecognizer.delegate = self
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            if let result = result {
                let characters = Array(result.bestTranscription.formattedString)
                self?.recognizedText = String(characters.last ?? " ")
                print("char:\(characters)")
            }
            
            guard error != nil || result?.isFinal == true else { return }
            self?.stop()
        }

        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            isProcessing = true
        } catch {
            print("Coudn't start audio engine!")
            stop()
        }
    }
    
    func stop() {
        recognitionTask?.cancel()
        
        audioEngine.stop()
        
        inputNode?.removeTap(onBus: 0)
        try? audioSession?.setActive(false)
        audioSession = nil
        inputNode = nil
        
        isProcessing = false
        
        recognitionRequest = nil
        recognitionTask = nil
        speechRecognizer = nil
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("✅ Available")
        } else {
            print("🔴 Unavailable")
            recognizedText = "Text recognition unavailable. Sorry!"
            stop()
        }
    }
    
    func observeRecognizedText(_ observer: NSObject, closure: @escaping (String?) -> Void) -> NSKeyValueObservation {
        return observe(\.recognizedText, options: [.new]) { _, change in
            closure(change.newValue as? String)
        }
    }

    func observeIsProcessing(_ observer: NSObject, closure: @escaping (Bool) -> Void) -> NSKeyValueObservation {
        return observe(\.isProcessing, options: [.new]) { _, change in
            closure(change.newValue ?? false)
        }
    }

}
