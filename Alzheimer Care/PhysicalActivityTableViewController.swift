//
//  PhysicalActivityTableViewController.swift
//  Alzheimer Care
//
//  Created by Hugo Santos Piauilino Neto on 08/05/17.
//  Copyright © 2017 Hugo Santos Piauilino. All rights reserved.
//

import UIKit
import UserNotifications

class PhysicalActivityTableViewController: UITableViewController {
    
    var activities : [Activity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activities.append(Activity(name: "Correr", time: "13:00", frequency: [.Friday, .Tuesday]))
            
        activities.append(Activity(name: "Jogar Futebol", time: "14:00", frequency: [.Monday, .Wednesday]))
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "physicalActivityIdentifier", for: indexPath)
        
        if let physicalActivityCell = cell as? PhysicalActivityTableViewCell {
            
            let physicalActivity = self.activities[indexPath.row]
            
            physicalActivityCell.nameLabel.text = physicalActivity.name
            
            var frequency = "\(physicalActivity.time) - "
            
            for day in physicalActivity.frequency {
                frequency += " \(day.rawValue)"
            }
            
            physicalActivityCell.frequencyLabel.text = frequency
        }
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //registerForNotifications()
        
        
        
        scheduleNotificationTo10SecondsFromNow(repeating: false)
        
        /* let content = UNMutableNotificationContent()
         content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
         content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
         
         // Configure the trigger for a 7am wakeup.
         var dateInfo = DateComponents()
         dateInfo.hour = 22
         dateInfo.minute = 18
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
         
         // Create the request object.
         let request = UNNotificationRequest(identifier: "MorningAlarm", content: content, trigger: trigger)
         
         // Schedule the request.
         let center = UNUserNotificationCenter.current()
         center.add(request) { (error : Error?) in
         if let theError = error {
         print(theError.localizedDeion)
         }
         } */
        
        /* let center = UNUserNotificationCenter.current()
         
         center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
         if granted {
         print("Yay!")
         } else {
         print("D'oh")
         }
         }
         
         scheduleNotification() */
        
    }
    
    /* func scheduleNotification() {
     let center = UNUserNotificationCenter.current()
     
     let content = UNMutableNotificationContent()
     content.title = "Late wake up call"
     content.body = "The early bird catches the worm, but the second mouse gets the cheese."
     content.categoryIdentifier = "alarm"
     content.userInfo = ["customData": "fizzbuzz"]
     content.sound = UNNotificationSound.default()
     
     var dateComponents = DateComponents()
     dateComponents.hour = 9
     dateComponents.minute = 32
     let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
     
     //        var dateComponents = DateComponents()
     //        dateComponents.hour = 9
     //        dateComponents.minute = 23
     //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
     
     let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
     center.add(request)
     } */
    
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
    
    func scheduleNotificationTo10SecondsFromNow(repeating: Bool) {
        
        // Defina o conteúdo da notificação
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.subtitle = "Subtitle"
        content.body = "Body body body body"
        
        // Definimos o intervalo de tempo para disparar a ação
        var timeInterval = 10.0
        if repeating {
            // Se a notificação for se repetir o mínimo é de 60 segundos
            timeInterval = 60.0
        }
        
        // Defina o gatilho da notificação
        // O gatilho pode ser de várias formas, uma delas é intervalo de tempo
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: repeating
        )
        
        // Crie um request de notificação com
        //  - Identificação: identifica a notificação unicamente
        //  - Conteúdo: define o conteúdo da notificação
        //  - Gatilho: define quando a notificação será ativada
        let request = UNNotificationRequest(
            identifier: "10seconds.notification",
            content: content,
            trigger: trigger
        )
        
        // Pegue a instância unica do notification center no app
        let notificationCenter = UNUserNotificationCenter.current()
        
        
        // Aqui só removemos as notificações anteriores
        notificationCenter.removeAllPendingNotificationRequests()
        
        // Agora adicionamos nossa request de notificação no notification center
        notificationCenter.add(request) { (error) in
            print("Ops, temos um erro aqui! Veja: \(error)")
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
