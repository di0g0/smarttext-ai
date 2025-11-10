//
//  HotKeyManager.swift
//  QuickTranslateAI
//
//  Gerencia atalhos de teclado globais
//

import Foundation
import AppKit
import Carbon

class HotKeyManager {
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?
    private var callback: (() -> Void)?
    
    // Cmd+Shift+T por padrão
    private let keyCode: UInt32 = 17 // T key
    private let modifiers: UInt32 = UInt32(cmdKey | shiftKey)
    
    func registerHotKey(callback: @escaping () -> Void) {
        self.callback = callback
        
        var hotKeyID = EventHotKeyID()
        hotKeyID.signature = UTGetOSTypeFromString("QKAI" as CFString)
        hotKeyID.id = 1
        
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)
        
        // Install event handler
        InstallEventHandler(GetApplicationEventTarget(), { (nextHandler, theEvent, userData) -> OSStatus in
            guard let userData = userData else { return OSStatus(eventNotHandledErr) }
            
            let manager = Unmanaged<HotKeyManager>.fromOpaque(userData).takeUnretainedValue()
            manager.callback?()
            
            return noErr
        }, 1, &eventType, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), &eventHandler)
        
        // Register hot key
        RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        
        print("✅ HotKey registered: Cmd+Shift+T")
    }
    
    func unregisterHotKey() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
        
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
        }
    }
    
    deinit {
        unregisterHotKey()
    }
}

