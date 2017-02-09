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
    
    @IBOutlet weak var adicionarOutlet: UIButton!
    @IBOutlet weak var tocarOutlet: UIButton!
    @IBOutlet weak var gravarOutlet: UIButton!
    @IBOutlet weak var nomeDoAudio: UITextField!
    
    // var audioGravado : AVAudioRecorder = nil
    var audioGravado : AVAudioRecorder?
    var tocaAudio : AVAudioPlayer?
    
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGravacao()
        tocarOutlet.isEnabled = false
        adicionarOutlet.isEnabled = false
        
        nomeDoAudio.addTarget(self, action: #selector(SoundViewController.verificaTexto), for: UIControlEvents.editingChanged)
        
        
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
             audioURL = NSURL.fileURL(withPathComponents: caminhoComponentes)!
            
            /*
            printar o caminho da url pra ver se realenmte tem algum aquivo la
            ########
                    print(audioURL)
            ########
            */
            
            
            //criando as configuraçoes
            
            var configuracoes : [String:Any] = [:]
            configuracoes[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            configuracoes[AVSampleRateKey] = 44100.0
            configuracoes[AVNumberOfChannelsKey] = 2
            
            //Criação do objeto audioGravado
            audioGravado = try AVAudioRecorder(url: audioURL!, settings: configuracoes)
            
            audioGravado!.prepareToRecord()
            
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    func verificaTexto(){

        if nomeDoAudio.hasText && tocarOutlet.isEnabled {
            adicionarOutlet.isEnabled = true
        }else{
          adicionarOutlet.isEnabled = false
        }
    }
    
    @IBAction func gravar(_ sender: Any) {
        if audioGravado!.isRecording {
            //parar a gravaçao
            audioGravado?.stop()
            
            //mudar o titulo do botao para "gravar"
            gravarOutlet.setTitle("Gravar", for: .normal)
            
            tocarOutlet.isEnabled = true
            
        }else{
            //começar a gravar
            audioGravado?.record()
            
            tocarOutlet.isEnabled = false
            //mudar o titulo do botao para "parar"
            gravarOutlet.setTitle("Parar", for: .normal)
            
        }
    }
    
    @IBAction func tocar(_ sender: Any) {
        do{
        tocaAudio = try AVAudioPlayer(contentsOf: audioURL!)
            tocaAudio!.play()
        }catch let error as NSError{
            print(error)
        }
    }
    
    @IBAction func adicinoar(_ sender: Any) {
        
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let musica = Sound(context: contexto)
        
        musica.audio = NSData(contentsOf: audioURL!)
        musica.nome = nomeDoAudio.text
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    
}
