//
//  ViewController.swift
//  SoundBoard
//
//  Created by Bayard Junior on 08/02/17.
//  Copyright © 2017 Bayard Junior. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sons : [Sound] = []
    var tocaAudio : AVAudioPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //sempre que essa tela aparecer ela buscar os dados no coredata
    //e atualizar a tabela.
    override func viewWillAppear(_ animated: Bool) {
        
        let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            sons = try contexto.fetch(Sound.fetchRequest())
            tableView.reloadData()
        }catch{}
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //quantidade de linhas = quantidade de objetos
        return sons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cria uma celula
        let cell = UITableViewCell()
        
        let som = sons[indexPath.row]
        
        cell.textLabel?.text = som.nome
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pega o item selecionado
        let som = sons[indexPath.row]
        
        do{
            tocaAudio = try AVAudioPlayer(data: som.audio! as Data)
            tocaAudio?.play()
        }catch{}
        
        //tira o foco do item selecionado
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //deletando pelo deslizado
        if editingStyle == .delete{
            let som = sons[indexPath.row]
            
            let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            contexto.delete(son)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do{
                sons = try contexto.fetch(Sound.fetchRequest())
                tableView.reloadData()
            }catch{}

            
        }
    }
}
