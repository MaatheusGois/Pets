//
//  PetCreateViewController.swift
//  pets
//
//  Created by Matheus Silva on 01/03/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import UIKit


class PetCreateViewController: UIViewController {
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petBreed: UITextField!
    @IBOutlet weak var petAge: UIPickerView!
    @IBOutlet weak var petGender: UIPickerView!
    @IBOutlet weak var petAgressive: UISwitch!
    
    var genderDataSource = GenderDataSource()
    var genderDelegate = GenderDelegate()
    
    var ageDataSource = AgeDataSource()
    var ageDelegate = AgeDelegate()
    
    lazy var genderSelected = genderDataSource.options[0]
    lazy var ageSelected  = ageDataSource.options[0]
    
    var agressive = false
    var imageName = ""
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        configGender()
        configAge()
        setupKeyboard()
    }
    
    func configGender() {
        petGender.delegate = genderDelegate
        petGender.dataSource = genderDataSource
    }
    
    func configAge() {
        petAge.delegate = ageDelegate
        petAge.dataSource = ageDataSource
    }
    
    // MARK: - Actions
    @IBAction func create() {
        self.showSpinner(onView: self.view)
        
        let date = Date().description.getFirst()
        let nameImage = "pet_\(Int.random(in: 0...100000000))_\(date).png"
        imageName = ImageHandler.url + nameImage
        
        ImageHandler.uploadRequest(imagemT: petImage.image, name: nameImage) { (response) in
            switch response {
            case .success(let result):
                if result {
                    self.uploadPet()
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
    
    func uploadPet() {
        PetHandler.create(params: formatPet().dictionaryRepresentation) { (response) in
            switch response {
            case .error(let description):
                DispatchQueue.main.async {
                    UIAlert.show(controller: self, title: "Não foi possível cadastrar o pet, tente novamente!", message: description) { (_) in }
                    self.removeSpinner()
                }
            case .success(_):
                DispatchQueue.main.async {
                    UIAlert.show(controller: self, title: "Pet cadastrado com sucesso!", message: "") { (_) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.removeSpinner()
                }
            }
        }
    }
    @IBAction func changeStatusAgressive(_ sender: UISwitch) {
        agressive = sender.isOn
    }
    
    
    // MARK: - Ultils
    func formatPet() -> Pet {
        let pet = Pet(_id: "",
                      name: petName.text ?? "",
                      age: ageSelected,
                      gender: genderSelected,
                      agressive: agressive,
                      image: imageName,
                      breed: petBreed.text ?? "")
        
        return pet
    }
    
    // MARK: - Keyboard
    var tap: UITapGestureRecognizer!
    func setupKeyboard() {
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc
    private func keyboardWillShow(sender: NSNotification) {
        view.frame.origin.y = -150
    }
    @objc
    private func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
    }
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - IMAGE
    @IBAction func loadImage() {
        ImagePickerManager().pickImage(self){ image in
            self.petImage.image = image
        }
    }
}
