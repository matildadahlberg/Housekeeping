//
//  ShowCleaningListViewController.swift
//  Housekeeping
//
//  Created by Matilda Dahlberg on 2018-11-12.
//  Copyright © 2018 Matilda Dahlberg. All rights reserved.
//

import UIKit

class ShowCleaningListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var sections = [
        SectionForCleaningList(title: "Varje dag", list: ["Bädda sängen","Torka av duschen","Rengöra toalettstolen","Torka av köksytorna","Torka av kokplattorna -", "efter att du använt dem","Diska","Sopa köksgolvet",
            "I slutet av dagen: plocka undan saker -", "som ligger framme och sätt smutsiga -", "kläder i tvättkorgen."], expanded: false),
        SectionForCleaningList(title: "Varje vecka", list: ["Byt sängkläder och handdukar","Tvätta","Dammtorka","Dammsug mattor och golv","Svabba golven med en mopp","Städa badrummet ordentligt","Rengör speglar och tandborstmuggen","Torka av insidan av mikrovågsugnen","Torka av köksmaskiner och alla ytor -", "som inte rengörs dagligen"], expanded: false),
        SectionForCleaningList(title: "Varje månad", list: ["Tvätta fönstren","Rengör persienner och gardiner","Tvätta alla dörrmattor","Rengör diskmaskinen, tvättmaskinen -", "och dammsugaren","Släng all mat som inte längre är ätbar –", "tänk på att smaka och lukta först,", "se dig inte blind på bäst-före-datumet","– och torka ur alla skåp."], expanded: false),
        SectionForCleaningList(title: "Var 3-6 månad", list: ["Dammsug madrasser","Tvätta täcken, kuddar och madrassöverdrag","Torka ur kylskåpet","Rengör frysen","Städa ugnen noggrant,", "både på ut- och insidan","Rensa garaget eller förrådet -", "på onödiga prylar"], expanded: false),
        SectionForCleaningList(title: "Varje år", list: ["Torka av fönsterramarna","Torka av glödlamporna","Rengör stoppade möbler och", "mattor på djupet","Rengör kakelugnar och eldstäder","Se till att skorstenen blir sotad"], expanded: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(sections[indexPath.section].expanded){
            return 44
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].title, section: section, delegate: self)
        return header
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        
        cell.textLabel?.text = sections[indexPath.section].list[indexPath.row]
        return cell
        
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        tableView.beginUpdates()
        for i in 0 ..< sections[section].list.count{
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

}
