//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Bayard Junior on 09/02/17.
//  Copyright © 2017 Bayard Junior. All rights reserved.
//

import UIKit

//biblioteca que a apple fez para que possamos manipular audios.
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var gravarOutlet: UIButton!
    @IBOutlet weak var nomeDoAudio: UITextField!
    
    // var audioGravado : AVAudioRecorder = nil
    var audioGravado : AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGravacao()
        
    }
    
    // preparação do componente
    func setUpGravacao() {
        
        do{
            //criando a sessao
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //criando a url
            
            let caminhoBase : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let caminhoComponentes = [caminhoBase, "audio.m4a"]
            let audioURL = NSURL.fileURL(withPathComponents: caminhoComponentes)!
            
            //criando as configuraçoes
            
            var configuracoes : [String:Any] = [:]
            configuracoes[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            configuracoes[AVSampleRateKey] = 44100.0
            configuracoes[AVNumberOfChannelsKey] = 2
            
            //Criação do objeto audioGravado
            audioGravado = try AVAudioRecorder(url: audioURL, settings: configuracoes)
            
            audioGravado!.prepareToRecord()
            
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    @IBAction func gravar(_ sender: Any) {
    }
    
    @IBAction func tocar(_ sender: Any) {
    }
    
    @IBAction func adicinoar(_ sender: Any) {
        
    }
    
}
