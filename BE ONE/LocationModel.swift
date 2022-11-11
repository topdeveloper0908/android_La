//
//  LocationModel.swift
//  SQLApp
//
//  Created by kurt warson on 16/04/16.
//  Copyright © 2016 kurt warson. All rights reserved.
//

import Foundation

class LocationModel: NSObject {
    
    //properties
    
    var name: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var imagename: String?
    var song: String?
    var beschrijving: String?
    var datum: String?
    
    var dag: String?
    var uur: String?
    var programma: String?
    var id:Int?
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(name: String, address: String, latitude: String, longitude: String, imagename: String, song: String, beschrijving: String, datum: String, dag: String, uur: String, programma: String,id:Int) {
        
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.imagename = imagename
        self.song = song
        self.beschrijving = beschrijving
        self.datum = datum
        self.dag = dag
        self.uur = uur
        self.programma = programma
        
       
        
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Name: \(name), Address: \(address), Latitude: \(latitude), Longitude: \(longitude),Imagename: \(imagename),Song: \(song),Beschrijving: \(beschrijving),Datum: \(datum),Dag: \(dag),Uur: \(uur),Programma: \(programma)"}
    
    
}

