//
//  XMLParser.swift
//  UvoteamApp
//
//  Created by Alexandr on 9/11/19.
//  Copyright © 2019 Alex.Ltd. All rights reserved.
//

import Foundation

class NewsParser: NSObject, XMLParserDelegate {
    private var items: [BusinessModel] = []
    private var currentElement = ""
    private var currentTitle = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var currentDescription = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var parserComplitionHandler: (([BusinessModel]) -> Void)?

    func parseFeed(url: URL, completionHandler: (([BusinessModel]) -> Void)?) {
        self.parserComplitionHandler = completionHandler

        let request = URLRequest(url: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }

    // MARK: - XML Parser Delegate

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "description":
            currentDescription += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let newItem = BusinessModel(title: currentTitle, description: currentDescription)
            self.items.append(newItem)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserComplitionHandler?(items)
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
