//
//  ViewController.swift
//  hangmanProject
//
//  Created by Adnan Nizami on 9/7/22.
//

import UIKit
import Darwin

class ViewController: UIViewController {
    var allWords = [String]()
    var clues = ["Opposite of sunset", "A citrus fruit", "Monkeys love these", "Apple's smartphone"]
    var imageViews = [UIImageView]()
    var questionWord: String = ""
    var currentWord: String = ""
    var letterButtons = [UIButton]()
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", ""]
    var img1 = [String]()
    var letterFound = 0
    @IBOutlet var hanger: UIImageView!
    @IBOutlet var head: UIImageView!
    @IBOutlet var body: UIImageView!
    @IBOutlet var leg1: UIImageView!
    @IBOutlet var leg2: UIImageView!
    @IBOutlet var arm1: UIImageView!
    @IBOutlet var arm2: UIImageView!
    @IBOutlet var word: UILabel!
    @IBOutlet var buttonsView: UIView!
    @IBOutlet var clue: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let file = Bundle.main.url(forResource:"level1", withExtension: "txt") else { return } // returns URL
        if let words = try? String(contentsOf: file) { // Converts contents to a string
            allWords = words.components(separatedBy: "\n")
        }
        hanger.image = UIImage(named: "hanger")
        leg1.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        leg2.transform = CGAffineTransform(rotationAngle: CGFloat.pi/1.35)
        arm1.transform = CGAffineTransform(rotationAngle: CGFloat.pi/4)
        arm2.transform = CGAffineTransform(rotationAngle: CGFloat.pi/1.35)
        word.textColor = .black
        word.backgroundColor = .white
        
        let width = 50
        let height = 50
        
        for row in 0..<4 {
            for column in 0..<7 {
                if alphabet[0] == "" {
                    break
                }
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle(alphabet[0], for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                alphabet.remove(at: 0)
                
            }
        }
        
        loadLevel()
}
    
    @objc func loadLevel() {
        if allWords.isEmpty == true {
            let ac = UIAlertController(title: "Congrats! Game over", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            exit(0)
        }
        currentWord = ""
        for _ in allWords[0] {
            currentWord += "-"
        }
        clue.text = clues[0]
        word.text = currentWord
        imageViews = [head, body, arm1, arm2, leg1, leg2]
        img1 = ["head", "body", "body",  "body", "body", "body"]
        for currentView in imageViews {
            currentView.isHidden = true
        }
        for currentButton in letterButtons {
            currentButton.isUserInteractionEnabled = true
            currentButton.setTitleColor(.systemBlue, for: .normal)
        }
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        var correctCount = 0
        sender.isUserInteractionEnabled = false
        sender.setTitleColor(.black, for: .normal)
        let letter = sender.titleLabel?.text
        for (idx, char) in allWords[0].enumerated() {
            if String(char) == letter {
                letterFound = 1
                var tempList = Array(currentWord) // ["?","?","?"]
                tempList[idx] = Character(letter!)
                currentWord = String(tempList)
                word.text = currentWord
            }
        }
        for letter in word.text! {
            if letter != "-" {
                correctCount += 1
            }
            if correctCount == word.text!.count {
                let ac = UIAlertController(title: "You won!", message: "Press OK to continue to next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                clues.remove(at: 0)
                allWords.remove(at: 0)
                loadLevel()
            }
        }
        if letterFound == 0 {
        imageViews[0].isHidden = false
        imageViews[0].image = UIImage(named: img1[0])
        imageViews.remove(at: 0)
        img1.remove(at: 0)
        }
        letterFound = 0
        
        if imageViews.isEmpty == true {
            allWords.remove(at: 0)
            clues.remove(at: 0)
            let ac = UIAlertController(title: "You lost!", message: "Press OK to try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            loadLevel()
        }
    }

}
