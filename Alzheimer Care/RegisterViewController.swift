//
//  RegisterViewController.swift
//  Alzheimer Care
//
//  Created by Hugo Santos Piauilino Neto on 05/05/17.
//  Copyright © 2017 Hugo Santos Piauilino. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class RegisterViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var profilePicture: UIImageView!
  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var userNumberTextField: UITextField!
  
  let context = DataManager.context
  // capturador / carregador de imagem
  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    registerForNotifications()
  }
  
  func registerForNotifications() {
    // Defina o tipo de notificações que você quer permitir
    let notificationTypes: UNAuthorizationOptions = [.sound, .alert, .badge]
    
    // Utilizamos o notification center para solicitar autorização
    let notificationCenter = UNUserNotificationCenter.current()
    
    // Solicitamos autorização
    notificationCenter.requestAuthorization(options: notificationTypes) {
      (granted, error) in
      if granted {
        print("Autorização concedida :D")
      } else {
        print("Autorização negada :(")
      }
    }
  }
  
  // MARK: - Actions
  
  @IBAction func capture(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      imagePicker.sourceType = .camera
      imagePicker.cameraCaptureMode = .photo
      imagePicker.modalPresentationStyle = .fullScreen
      present(imagePicker, animated: true, completion: nil)
    } else {
      let alert = UIAlertController(title: "Sem câmera", message: "Desculpe, esse dispositivo não tem câmera", preferredStyle: .alert)
      alert.addAction(OKButton())
      present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func load(_ sender: Any) {
    imagePicker.sourceType = .photoLibrary
    imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func registerButton(_ sender: Any) {
    guard let name = userNameTextField.text, let number = userNumberTextField.text, !name.isEmpty, !number.isEmpty else {
      let alert = UIAlertController(title: "Erro!", message: "Preencha todos os campos :D", preferredStyle: .actionSheet)
      alert.addAction(OKButton())
      return present(alert, animated: true, completion: nil)
    }
    
    let newUser = User(name, number)
    
    if UserDAO.create(newUser), let image = profilePicture.image {
      guard let imgData = UIImageJPEGRepresentation(image, 1) as NSData? else {
        NSLog("Image conversion error")
        return
      }
      
      let picture = ProfilePicture(imgData, newUser)
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  private func setupUI() {
    self.hideKeyboardWhenTappedAround()
    
    self.imagePicker.delegate = self
    self.imagePicker.allowsEditing = false
    
    self.profilePicture.layer.borderWidth = 1
    self.profilePicture.layer.masksToBounds = false
    self.profilePicture.layer.borderColor = UIColor.black.cgColor
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.height / 2
    self.profilePicture.clipsToBounds = true
    
    self.userNumberTextField.keyboardType = .phonePad
  }
  
  private func OKButton() -> UIAlertAction {
    return UIAlertAction(title: "OK", style: .default, handler: nil)
  }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      profilePicture.contentMode = .scaleAspectFit
      profilePicture.image = pickedImage
    } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      profilePicture.contentMode = .scaleAspectFit
      profilePicture.image = pickedImage
    } else {
      print("Failed to convert image for some reason")
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

