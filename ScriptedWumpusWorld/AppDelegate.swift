//
//  AppDelegate.swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 10.07.16.
//  Copyright (c) 2016 Entenwolf Software. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var guiDisabledWarning: NSTextField!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var guiHunter: GuiHunter!
    @IBOutlet weak var reloadHunterFileMenuItem: NSMenuItem!
    
    
    var mostRecentHunterUrl: URL?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.newGameWithGuiHunter(nil)
    }
    
    @IBAction func newGameWithGuiHunter(_ sender: AnyObject?) {
        guiHunter.clearActionQueue()
        
        self.presentNewScene(guiHunter, splashMessage: "GUI hunter")
    }
    
    @IBAction func reloadMostRecentHunterFile(_ sender: AnyObject?) {
        if let url = self.mostRecentHunterUrl {
            self.loadAndPresent(url)
        }
    }
    
    @IBAction func newGameWithHunterFromFile(_ sender: AnyObject?) {
        let openPanel = NSOpenPanel()
        
        //openPanel.beginSheet(self.window, completionHandler: {(response) in print(response) })
        let result = openPanel.runModal()
        
        if result != NSApplication.ModalResponse.OK
            || openPanel.urls.count == 0
        {
            return
        }
        
        if let url = openPanel.urls.first {
            self.loadAndPresent(url)
        } else {
            print("no url")
        }
    }
    
    func loadAndPresent(_ url: URL) {
        do {
            let script = try String(contentsOf: url)
            var luaError: NSString? = nil
            if let hunter = LuaHunter(script, error: &luaError) {
                self.mostRecentHunterUrl = url
                self.reloadHunterFileMenuItem.isEnabled = true
                self.presentNewScene(hunter, splashMessage: "Hunter from \(url.lastPathComponent)")
            } else {
                let alert = NSAlert()
                
                alert.messageText = (luaError as String?) ?? "No error description available."
                alert.runModal()
            }
        } catch let error as NSError {
            NSAlert(error: error).runModal()
        } catch {
            print(error)
        }
    }
    
    func presentNewScene(_ hunter: Hunter, splashMessage: String?) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            scene.splashScreenText = splashMessage
            
            self.skView!.presentScene(scene)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
            
            // enable/disable control panel
            self.guiDisabledWarning.isHidden = hunter.isManuallyControlled
            
            /* game logic */
            // scene.hunter = self.loadHunter()
            // scene.hunter = guiHunter
            scene.hunter = hunter
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
































