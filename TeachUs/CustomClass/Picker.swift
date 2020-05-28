//
//  Picker.swift
//  TeachUs
//
//  Created by iOS on 28/05/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import Foundation
class PickerSource : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }
    
    
    var data: [[String]] = []
    var selectionUpdated: ((_ component: Int, _ row: Int) -> Void)?
    
    // MARK: UIPickerViewDataSource
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let rows = data[component]
        return rows.count
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(data[component][row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectionUpdated?(component, row)
    }
}

class Picker<T : CustomStringConvertible> : UIPickerView {
    
    var data: [[T]] = [] {
        didSet {
            source.data = data.map { $0.map { "\($0)" } }
            reloadAllComponents()
        }
    }
    
    var selectionUpdated: ((_ selections: [T?]) -> Void)?
    
    private let source = PickerSource()
    
    // MARK: Initialization
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    convenience init(data: [[T]]) {
        self.init(frame: CGRect.zero)
        setData(newData: data)
    }
    
    private func setData (newData:[[T]]){
        self.data = newData
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        dataSource = source
        delegate = source
        source.selectionUpdated = { [weak self] component, row in
            if let _self = self {
                var selections: [T?] = []
                for (idx, componentData) in (_self.data).enumerated() {
                    let selectedRow = _self.selectedRow(inComponent: idx)
                    if selectedRow >= 0 {
                        selections.append(componentData[selectedRow])
                    } else {
                        selections.append(nil)
                    }
                }
                _self.selectionUpdated?(selections)
            }
        }
    }
}
