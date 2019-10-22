//
//  ViewController.swift
//  Cloudkit Wshop
//
//  Created by Bruno Pastre on 22/10/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    let publicDatabase = CKContainer.default().publicCloudDatabase
    let privateDatabase = CKContainer.default().privateCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.store()
    }

    func query(){
        var predicate = NSPredicate(format: "name = bot" )
        predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "RatoRobo", predicate: predicate)
        
        privateDatabase.perform(query, inZoneWith: nil) { (records, error) in
            guard let recs  = records else  {
                print(error!.localizedDescription)
                return
            }
            
            print("Encontramos ", recs.count, "gravacoes")
            
            for record in recs {
            
                let nome = record["nome"]
                let bateria = record["bateria"]
                let imagem = record["imagem"]
                
                print("Saca so esse rato:", nome, bateria, type(of: imagem))
            }
        }
        
    }
    
    func store(){
        let record = CKRecord(recordType: "RatoRobo")
        
        record["nome"] = "novo rato"
        record["bateria"] = 100
        record["imagem"] = UIImage(systemName: "add")?.pngData()
        
        privateDatabase.save(record) { (_, error) in
            if let e = error {
                print("Erro pra gravar", e.localizedDescription)
                return
            }
            
            print("Escrevi no banco")
        }
    }

}

