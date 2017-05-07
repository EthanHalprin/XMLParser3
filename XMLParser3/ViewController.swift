//
//  ViewController.swift
//  Parsers
//
//  Created by Ethan Halprin on 06/05/2017.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate
{
    @IBOutlet var xmlTextView: UITextView!
    @IBOutlet var memoryTextView: UITextView!
    @IBOutlet var parseButton: UIButton!
    @IBOutlet var arrowDownLabel: UILabel!
    
    var parser : XMLParser!
    var parsedFilmsArray : [TarantinoFilm] = []
    var lastElement : String!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        arrowDownLabel.text = "\u{2193}"
        parseButton.layer.borderColor = UIColor.yellow.cgColor
        parseButton.layer.borderWidth = 2.0
        parseButton.layer.cornerRadius = 8.0
    }
    //
    // @IBOutlet
    //
    @IBAction func parseButtonTouchUpInside(_ sender: UIButton)
    {
        let url = Bundle.main.url(forResource: "tarantino", withExtension: "xml")
        parser = XMLParser(contentsOf: url!)
        parser.delegate = self

        parsedFilmsArray.removeAll()
        
        if !parser.parse()
        {
            print("ERROR in Xml")
            
            if xmlTextView.text.isEmpty
            {
                xmlTextView.text = "XML Format ERROR"
            }
            else
            {
                xmlTextView.text = "Found Error. Pleae check error code at https://developer.apple.com/reference/foundation/xmlparser.errorcode"
            }
        }
        
        presenter()
    }
    //
    // Output Printer
    //
    func presenter()
    {
        print("\n")
        print("Films array property size after parse is \(parsedFilmsArray.count):\n")
        
        memoryTextView.text.removeAll()
        
        for (i,film) in parsedFilmsArray.enumerated()
        {
            let line1 = "Cell  #\(i) - \(film.name!) (\(film.year!))"
            if memoryTextView.text.isEmpty
            {
                memoryTextView.text = line1
            }
            else
            {
                memoryTextView.text! += line1
            }
            print(line1)
            
            memoryTextView.text! += "\n============================\n"
            print("=====================================")
            
            let line3 = "producer  : \(film.producer!)"
            memoryTextView.text! += line3 + "\n"
            print(line3)
            
            let line4 = "starring  : \(film.star!)"
            memoryTextView.text! += line4 + "\n"
            print(line4)
            
            let line5 = "full time : \(film.time!) minutes"
            memoryTextView.text! += line5 + "\n"
            print(line5)
            
            let budgetStr = currencyFormat(num: film.budget!)
            let line6 = "budget    : \(budgetStr)"
            memoryTextView.text! += line6 + "\n"
            print(line6)
            

            let boxStr = currencyFormat(num: film.boxOffice!)
            let line7 = "box office: \(boxStr)"
            memoryTextView.text! += line7 + "\n\n"
            print(line7)
        }
    }
    //
    // Formattor for numbers
    //
    func currencyFormat(num: Int32) -> String
    {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = Locale(identifier: Locale.current.identifier)
        
        let result = formatter.string(from: num as NSNumber)
        
        return result!
    }
    //
    //---- XMLParserDelegate -----------------------------------------------------------------------
    //
    
    //
    // Invokes as the parsing reached any element start e.g. "<element ...". Also supplies the
    // attributes (if any)
    //
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        self.lastElement = elementName
        
        if attributeDict.count > 0
        {
            //
            // Print data to Xcode output
            //
            print("\t didStartElement = \(elementName) with Attributes:")
            for (k,v) in attributeDict.enumerated()
            {
                print("\t\t attribute \(k) = \(v)")
            }
            //
            // If tag is film - build an instance for it
            //
            if elementName == "film"
            {
                let tfilm = TarantinoFilm()
                
                let name = attributeDict["name"]
                let year = attributeDict["year"]
                
                if let name = name { tfilm.name = name }
                if let year = year { tfilm.year = Int32(year) }
                
                self.parsedFilmsArray.append(tfilm)
            }
        }
        else
        {
            print("\t didStartElement = \(elementName)")
        }
    }
    //
    // Invokes as the parsing reached any end of element start e.g. "<\element>". Mind that ecery
    // element tag opened, there must a one to end it (otherwise error in xml validation)
    //
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        print("\t didEndElement = \(elementName)")
        
        if elementName == "film"
        {
            print("\t -----------------------------------------------")
        }
    }
    //
    // Invokes as the content of the element is found
    //
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if string.characters.count > 0
        {
            let index = string.index(string.startIndex, offsetBy: 0)
            
            if string[index] != "\n"
            {
                print("\t foundCharacters = \(string)")
                
                let index = parsedFilmsArray.count - 1
                
                guard index >= 0 else { return }
                
                switch lastElement
                {
                case "producer":
                    
                    self.parsedFilmsArray[index].producer = string
                    
                case "star":
                    
                    self.parsedFilmsArray[index].star = string
                    
                case "time":
                    
                    self.parsedFilmsArray[index].time = Int32(string)
                    
                case "budget":
                    
                    self.parsedFilmsArray[index].budget = Int32(string)
                    
                case "box_office":
                    
                    self.parsedFilmsArray[index].boxOffice = Int32(string)
                    
                default:
                    
                    break
                }
            }
        }
    }
    //
    // Reports error in XML. Its description will read something like:
    // "The operation couldn’t be completed. (NSXMLParserErrorDomain error 76.)"
    //
    // You should take that code number and check it out on API Refernce here:
    // https://developer.apple.com/reference/foundation/xmlparser.errorcode
    //
    //
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print("parseErrorOccurred = \(parseError.localizedDescription)")
        
        xmlTextView.text = "\(parseError.localizedDescription)"
    }
    func parserDidStartDocument(_ parser: XMLParser)
    {
        print("<<<<<<<<<<<<<<<<<<<  parserDidStartDocument  <<<<<<<<<<<<<<<<<<<\n")
    }
    func parserDidEndDocument(_ parser: XMLParser)
    {
        print("\n>>>>>>>>>>>>>>>>>>>  parserDidEndDocument  >>>>>>>>>>>>>>>>>>>")
    }
    //
    // Other optional delegate methods that you may find handy in specific cases
    //
    func parser(_ parser: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String)
    {
        print("didStartMappingPrefix = \(prefix)")
    }
    func parser(_ parser: XMLParser, didEndMappingPrefix prefix: String)
    {
        print("didEndMappingPrefix = \(prefix)")
    }
    func parser(_ parser: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?)
    {
        print("foundNotationDeclarationWithName = \(name)")
    }
    func parser(_ parser: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?)
    {
        print("foundUnparsedEntityDeclarationWithName = \(name)")
    }
    func parser(_ parser: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?)
    {
        print("foundAttributeDeclarationWithName = \(attributeName)")
    }
    func parser(_ parser: XMLParser, foundElementDeclarationWithName elementName: String, model: String)
    {
        print("foundElementDeclarationWithName = \(elementName)")
    }
    func parser(_ parser: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?)
    {
        print("foundInternalEntityDeclarationWithName = \(name)")
    }
    func parser(_ parser: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?)
    {
        print("foundExternalEntityDeclarationWithName = \(name)")
    }
    func parser(_ parser: XMLParser, foundIgnorableWhitespace whitespaceString: String)
    {
        print("foundIgnorableWhitespace = \(whitespaceString)")
    }
    func parser(_ parser: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?)
    {
        print("foundProcessingInstructionWithTarget = \(target)")
    }
    func parser(_ parser: XMLParser, foundComment comment: String)
    {
        print("foundComment = \(comment)")
    }
    func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data)
    {
        print("foundCDATA = \(CDATABlock.description)")
    }
    func parser(_ parser: XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Data?
    {
        print("resolveExternalEntityName = \(name)")
        
        return nil
    }
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error)
    {
        print("validationErrorOccurred = \(validationError.localizedDescription)")
    }
}

