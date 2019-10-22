//
//  AppDelegate.swift
//  Cloudkit Wshop
//
//  Created by Bruno Pastre on 22/10/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let notificationCenter = UNUserNotificationCenter.current()

    func setupSubscription(){
        let predicate = NSPredicate(value: true)
        
        let query = CKQuerySubscription(recordType: "RatoRobo", predicate: predicate, options: [.firesOnRecordCreation, .firesOnRecordDeletion, .firesOnRecordUpdate, .firesOnce])
        let notification = CKSubscription.NotificationInfo()
        
        notification.alertBody = "corpo"
        notification.subtitle = "sub"
        notification.title = "TITULUZAO"
        notification.shouldSendMutableContent = true
        notification.shouldSendContentAvailable = true
        
        query.notificationInfo = notification
        
        let privateDatabase = CKContainer.default().privateCloudDatabase
        
        privateDatabase.save(query) { (subs, error) in
            guard let subscription = subs else {
                print("Erro pra fazer a subscricao", error!.localizedDescription)
                return
            }
            
            print("Fez a subscricao!")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (worked, error) in
            if !worked{
                print("Erro pra enviar notificacoes", error!.localizedDescription)
            } else {
                print("Worked!")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                    self.setupSubscription()
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Esta apto a receber pushes
        print("Recebendo notificacoes")
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Deu ruim pra receber as notificacoes")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Recebi uma modificacao")
        completionHandler(.newData)
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Recebi uma push!")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Vai mostrar a notificacao")
        
        completionHandler([.alert])
    }
    

}

