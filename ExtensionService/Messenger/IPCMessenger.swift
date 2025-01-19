//
//  IPCMessenger.swift
//  Copilot for Xcode
//
//  Created by daniel on 2025/1/19.
//

import AppKit
import SocketIPC
import XcodeInspector

class IPCMessenger {
    static let shared = IPCMessenger()

    func setup() {
        if let workspaces = XcodeInspector.shared.activeXcode?.workspaces {
            for (id, workspace) in workspaces {
                let element = workspace.element
                let info = workspace.info
                print("\(info)")
                print("\(element)")
                if info.tabs.contains("MyView.swift") {
                    print(element)
                }
            }
        }
    }
}



public func print(_ element: AXUIElement, depth: Int = 0) {
    let padding = String(repeating: "  ", count: depth)
    print("\(padding)\(element): {")
    for attribute in allAttributes {
        if let value: Any = try? element.copyValue(key: attribute) {
            print("\(padding)  \(attribute): \(value)")
        }
    }
    let children = element.children
    if !children.isEmpty {
        print("\(padding)  AXChildren: (")
        for child in children {
            print(child, depth: depth + 2)
        }
        print("\(padding)  )")
    }
    print("\(padding)}")
}

let allAttributes: [String] = [
 kAXRoleAttribute,
 kAXSubroleAttribute,
 kAXRoleDescriptionAttribute,
 kAXHelpAttribute,
 kAXTitleAttribute,
 kAXValueAttribute,
 kAXValueDescriptionAttribute,
 kAXMinValueAttribute,
 kAXMaxValueAttribute,
 kAXValueIncrementAttribute,
 kAXAllowedValuesAttribute,
 kAXPlaceholderValueAttribute,
 kAXEnabledAttribute,
 kAXElementBusyAttribute,
 kAXFocusedAttribute,
 kAXParentAttribute,
// kAXChildrenAttribute,
 kAXSelectedChildrenAttribute,
 kAXVisibleChildrenAttribute,
 kAXWindowAttribute,
 kAXTopLevelUIElementAttribute,
 kAXPositionAttribute,
 kAXSizeAttribute,
 kAXOrientationAttribute,
 kAXDescriptionAttribute,
 kAXDescription,
 kAXSelectedTextAttribute,
 kAXSelectedTextRangeAttribute,
 kAXSelectedTextRangesAttribute,
 kAXVisibleCharacterRangeAttribute,
 kAXNumberOfCharactersAttribute,
 kAXSharedTextUIElementsAttribute,
 kAXSharedCharacterRangeAttribute,
 kAXSharedFocusElementsAttribute,
 kAXInsertionPointLineNumberAttribute,
 kAXMainAttribute,
 kAXMinimizedAttribute,
 kAXCloseButtonAttribute,
 kAXZoomButtonAttribute,
 kAXMinimizeButtonAttribute,
 kAXToolbarButtonAttribute,
 kAXFullScreenButtonAttribute,
 kAXProxyAttribute,
 kAXGrowAreaAttribute,
 kAXModalAttribute,
 kAXDefaultButtonAttribute,
 kAXCancelButtonAttribute,
 kAXMenuItemCmdCharAttribute,
 kAXMenuItemCmdVirtualKeyAttribute,
 kAXMenuItemCmdGlyphAttribute,
 kAXMenuItemCmdModifiersAttribute,
 kAXMenuItemMarkCharAttribute,
 kAXMenuItemPrimaryUIElementAttribute,
 kAXMenuBarAttribute,
 kAXWindowsAttribute,
 kAXFrontmostAttribute,
 kAXHiddenAttribute,
 kAXMainWindowAttribute,
 kAXFocusedWindowAttribute,
 kAXFocusedUIElementAttribute,
 kAXExtrasMenuBarAttribute,
 kAXHeaderAttribute,
 kAXEditedAttribute,
 kAXValueWrapsAttribute,
 kAXTabsAttribute,
 kAXTitleUIElementAttribute,
 kAXHorizontalScrollBarAttribute,
 kAXVerticalScrollBarAttribute,
 kAXOverflowButtonAttribute,
 kAXFilenameAttribute,
 kAXExpandedAttribute,
 kAXSelectedAttribute,
 kAXSplittersAttribute,
 kAXNextContentsAttribute,
 kAXDocumentAttribute,
 kAXDecrementButtonAttribute,
 kAXIncrementButtonAttribute,
 kAXPreviousContentsAttribute,
 kAXContentsAttribute,
 kAXIncrementorAttribute,
 kAXHourFieldAttribute,
 kAXMinuteFieldAttribute,
 kAXSecondFieldAttribute,
 kAXAMPMFieldAttribute,
 kAXDayFieldAttribute,
 kAXMonthFieldAttribute,
 kAXYearFieldAttribute,
 kAXColumnTitleAttribute,
 kAXURLAttribute,
 kAXLabelUIElementsAttribute,
 kAXLabelValueAttribute,
 kAXShownMenuUIElementAttribute,
 kAXServesAsTitleForUIElementsAttribute,
 kAXLinkedUIElementsAttribute,
 kAXRowsAttribute,
 kAXVisibleRowsAttribute,
 kAXSelectedRowsAttribute,
 kAXColumnsAttribute,
 kAXVisibleColumnsAttribute,
 kAXSelectedColumnsAttribute,
 kAXSortDirectionAttribute,
 kAXIndexAttribute,
 kAXDisclosingAttribute,
 kAXDisclosedRowsAttribute,
 kAXDisclosedByRowAttribute,
 kAXDisclosureLevelAttribute,
 kAXMatteHoleAttribute,
 kAXMatteContentUIElementAttribute,
 kAXMarkerUIElementsAttribute,
 kAXUnitsAttribute,
 kAXUnitDescriptionAttribute,
 kAXMarkerTypeAttribute,
 kAXMarkerTypeDescriptionAttribute,
 kAXIsApplicationRunningAttribute,
 kAXSearchButtonAttribute,
 kAXClearButtonAttribute,
 kAXFocusedApplicationAttribute,
 kAXRowCountAttribute,
 kAXColumnCountAttribute,
 kAXOrderedByRowAttribute,
 kAXWarningValueAttribute,
 kAXCriticalValueAttribute,
 kAXSelectedCellsAttribute,
 kAXVisibleCellsAttribute,
 kAXRowHeaderUIElementsAttribute,
 kAXColumnHeaderUIElementsAttribute,
 kAXRowIndexRangeAttribute,
 kAXColumnIndexRangeAttribute,
 kAXHorizontalUnitsAttribute,
 kAXVerticalUnitsAttribute,
 kAXHorizontalUnitDescriptionAttribute,
 kAXVerticalUnitDescriptionAttribute,
 kAXHandlesAttribute,
 kAXTextAttribute,
 kAXVisibleTextAttribute,
 kAXIsEditableAttribute,
 kAXColumnTitlesAttribute,
 kAXIdentifierAttribute,
 kAXAlternateUIVisibleAttribute,
 kAXLineForIndexParameterizedAttribute,
 kAXRangeForLineParameterizedAttribute,
 kAXStringForRangeParameterizedAttribute,
 kAXRangeForPositionParameterizedAttribute,
 kAXRangeForIndexParameterizedAttribute,
 kAXBoundsForRangeParameterizedAttribute,
 kAXRTFForRangeParameterizedAttribute,
 kAXAttributedStringForRangeParameterizedAttribute,
 kAXStyleRangeForIndexParameterizedAttribute,
 kAXCellForColumnAndRowParameterizedAttribute,
 kAXLayoutPointForScreenPointParameterizedAttribute,
 kAXLayoutSizeForScreenSizeParameterizedAttribute,
 kAXScreenPointForLayoutPointParameterizedAttribute,
 kAXScreenSizeForLayoutSizeParameterizedAttribute]
