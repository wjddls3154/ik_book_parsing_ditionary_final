//
//  ViewController.swift
//  ik_book_parsing_ditionary
//
//  Created by D7702_10 on 2018. 10. 8..
//  Copyright © 2018년 jik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myTableView: UITableView!
    var item:[String:String] = [:]
    var elements:[[String:String]] = []
    var currentElement = ""
    //배열 지정
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTableView.delegate = self
        myTableView.dataSource = self
        
        //delegate , datasource 연결
        
        if let path = Bundle.main.url(forResource: "book", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                
                if parser.parse() {
                    print("parse succeed")
                    print(elements)
                }
            } else {
                print("parse failed")
            }
        } else {
            print("xml not found")
        }
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        print("currentElement = \(elementName)")
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        print("data = \(data)")
        if !data.isEmpty {
            item[currentElement] = data
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "book" {
            elements.append(item)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        let myItem = elements[indexPath.row]
        let title = cell.viewWithTag(1) as! UILabel
        let author = cell.viewWithTag(2) as! UILabel
        //태그 번호에 해당하는 정보 호출
        
        title.text = myItem["title"] //text에 title 저장
        author.text = myItem["author"]  //text에 author 저장
        return cell
        
    }
}
