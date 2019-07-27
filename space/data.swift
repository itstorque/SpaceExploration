//
//  data.swift
//  space
//
//  Created by Tareq El Dandachi on 1/19/19.
//  Copyright © 2019 Tareq El Dandachi. All rights reserved.
//


//THIS LINK WAS HELPFUL https://nssdc.gsfc.nasa.gov/planetary/factsheet/planet_table_ratio.html

struct data {

    static let planetPeriods : [String:Double] = ["Mercury":58.65,"Venus":116.75,"Earth":1,"Mars":1.025,"Jupiter":0.414,"Saturn":0.4458,"Uranus":0.718,"Neptune":0.671,"Pluto":6.4, "Moon Orbit":27.3, "Moon": 27]
    
    //Diameter of planets in km
    static let planetDiameters : [String:Int] = ["Mercury":4879,"Venus":12104,"Earth":12742,"Mars":6779,"Jupiter":139822,"Saturn":116464,"Uranus":50724,"Neptune":49244,"Pluto":2377, "Moon Orbit":385000, "Moon": 3474]
    
    static let planetsOrder : [String:Double] = ["Mercury":1, "Venus":2, "Earth":3, "Mars":4, "Jupiter":5, "Saturn":6, "Uranus":7, "Neptune":8, "Pluto":9]
    
    static let planetTilts : [String:Double] = ["Mercury":0.03, "Venus":177.4, "Earth":23.44, "Mars":25.19, "Jupiter":3.13, "Saturn":26.73, "Uranus":82.23, "Neptune":28.32, "Pluto":57.47, "Moon":6.68, "Ceres":4]
    
    //Distance of planets from Sun (Moon from earth) all in AU
    static let planetDistances : [String : Double] = ["Mercury":0.39,"Venus":0.723,"Earth":1,"Mars":1.524,"Jupiter":5.203,"Saturn":9.539,"Uranus":19.18,"Neptune":30.06,"Pluto":39.53, "Moon": 0.00256955529]
    
    //Mass of planets in Earth Masses M⊕
    static let planetMass : [String : Double] = ["Mercury":0.0553,"Venus":0.815,"Earth":1,"Mars":0.107,"Jupiter":317.8,"Saturn":95.2,"Uranus":14.5,"Neptune":17.1,"Pluto":0.0025, "Moon": 0.0123]
    
    //Density of planets compared to earth density
    static let planetDensity : [String : Double] = ["Mercury":0.984,"Venus":0.951,"Earth":1,"Mars":0.713,"Jupiter":0.240,"Saturn":0.125,"Uranus":0.230,"Neptune":0.297,"Pluto":0.380, "Moon": 0.605]
    
    //Gravitational Strength of planets comapred to that of earth
    static let planetGravity : [String : Double] = ["Mercury":0.378,"Venus":0.907,"Earth":1,"Mars":0.377,"Jupiter":2.36,"Saturn":0.916,"Uranus":0.889,"Neptune":1.12,"Pluto":0.071, "Moon": 0.166]
    
    //Mean Temperature of planets in Degrees Celsius
    static let planetTemperatures : [String : Double] = ["Mercury":167,"Venus":464,"Earth":15,"Mars":-65,"Jupiter":-110,"Saturn":-140,"Uranus":-195,"Neptune":-200,"Pluto":-225, "Moon": -20]
    
    // #mass of earth over (10^24) in kg
    static let earthMass = 5.97
    
    //Distance of earth from sun over (10^6) in km
    static let earthDistance = 149.6
    
    //Gravity of earth in m/s^2
    static let earthGravity = 9.807
    
}
