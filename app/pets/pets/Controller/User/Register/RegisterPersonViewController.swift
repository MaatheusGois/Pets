//
//  RegisterPersonViewController.swift
//  pets
//
//  Created by Matheus Silva on 10/03/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit


class RegisterPersonViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        loadPreview()
    }
    
    private func loadPreview() {
        if let user = CommonData.shared.user {
            nameText.text = user.name
        } else {
            print("User not defined")
        }
    }
    
    func formartPerson() -> Person {
        
        return Person(_id: nil,
                      name: nameText.text ?? "",
                      image: imageName, pets: nil)
    }
        
    
    func createPerson() {
        let person = formartPerson()
        PersonHandler.create(person: person) { (response) in
            switch response {
            case .success(let answer):
                DispatchQueue.main.async {
                    CommonData.shared.user.person = answer
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                    self.removeSpinner()
                }
            case .error(let description):
                DispatchQueue.main.async {
                    UIAlert.show(controller: self, title: "Não foi possível fazer criar um usuário!", message: description) { (_) in }
                    self.removeSpinner()
                }
            }
        }
    }
    
    
    // MARK: - Actions
    @IBAction func loadImage() {
        ImagePickerManager().pickImage(self){ image in
            self.imageView.image = image
        }
    }
    
    @IBAction func finishRegister() {
        self.showSpinner(onView: self.view)
        
        let date = Date().description.getFirst()
        let nameImage = "person_\(Int.random(in: 0...100000000))_\(date).png"
        imageName = ImageHandler.url + nameImage
        
        ImageHandler.uploadRequest(imagemT: imageView.image, name: nameImage) { (response) in
            switch response {
            case .success(let result):
                if result {
                    self.createPerson()
                } else {
                    self.showAlert(title: "Erro ao subir a imagem", message: "Sem descrição!")
                    self.removeSpinner()
                }
                
            case .error(let description):
                self.showAlert(title: "Erro ao subir a imagem", message: description)
                self.removeSpinner()
            }
        }
    }
}
