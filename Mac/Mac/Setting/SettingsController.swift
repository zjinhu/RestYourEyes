//
//  SettingsController.swift
//  Mac
//
//  Created by FunWidget on 2024/7/4.
//

import SwiftUI
import Settings

let settingsWindowController = SettingsWindowController(
    panes: [
        GeneralSettingsViewController(),
//        ThemeSettingsViewController(),
        PromptSettingsViewController(),
        AboutSettingsViewController()
    ],
    style: .toolbarItems,
    animated: true,
    hidesToolbarForSingleItem: true
)

extension AppSettings.PaneIdentifier {
    static let general = Self("general")
//    static let theme = Self("theme")
    static let prompt = Self("prompt")
    static let about = Self("about")
}

let GeneralSettingsViewController: () -> SettingsPane = {
    let paneView = AppSettings.Pane(
        identifier: .general,
        title: "General".localized,
        toolbarIcon: NSImage(systemSymbolName: "gearshape", accessibilityDescription: "General settings")!
    ) {
        SettingView()
    }

    return AppSettings.PaneHostingController(pane: paneView)
}

//let ThemeSettingsViewController: () -> SettingsPane = {
//    let paneView = AppSettings.Pane(
//        identifier: .theme,
//        title: "Theme".localized,
//        toolbarIcon: NSImage(systemSymbolName: "paintbrush.fill", accessibilityDescription: "Theme settings")!
//    ) {
//        ThemeView()
//    }
//
//    return AppSettings.PaneHostingController(pane: paneView)
//}

let PromptSettingsViewController: () -> SettingsPane = {
    let persistenceController = PersistenceController.shared
    
    let paneView = AppSettings.Pane(
        identifier: .prompt,
        title: "Prompt".localized,
        toolbarIcon: NSImage(systemSymbolName: "textformat", accessibilityDescription: "Prompt settings")!
    ) {
        PromptView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }

    return AppSettings.PaneHostingController(pane: paneView)
}

let AboutSettingsViewController: () -> SettingsPane = {
    let paneView = AppSettings.Pane(
        identifier: .about,
        title: "About".localized,
        toolbarIcon: NSImage(systemSymbolName: "exclamationmark.circle.fill", accessibilityDescription: "About settings")!
    ) {
        AboutView()
    }

    return AppSettings.PaneHostingController(pane: paneView)
}
