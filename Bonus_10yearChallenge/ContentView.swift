//
//  ContentView.swift
//  Bonus_10yearChallenge
//
//  Created by 王瑋 on 2020/5/26.
//  Copyright © 2020 王瑋. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var picTime : Date = Calendar.current.date(byAdding: DateComponents(year: -10), to: Date()) ?? Date()
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter
    }()
    var year: Int {
        Calendar.current.component(.year, from: picTime)
    }
    @State private var number: Int = 0
    @State private var number_year : Double = 2010
    @State private var picNum: Int = 2010
    @State private var autoPlay2: Bool = false
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Toggle("自動播放", isOn: Binding(get: {
                self.autoPlay2
            }, set: {
                print($0)
                self.autoPlay2 = $0}))
                .onReceive(timer) { (value) in
                    if self.autoPlay2{
                        self.number += 1
                        self.number_year = Double(self.number % 10 + 2010)
                        var components = DateComponents()
                        components.calendar = Calendar.current
                        components.year = Int(self.number_year)
                        self.picTime = components.date!
                    }
            }
            .padding(.top,50)
            GeometryReader { geometry in
                Image("\(self.autoPlay2 ? (self.number % 10) + 2010 : self.year )")
                    .resizable()
                    .scaledToFit()
                    .border(Color.white, width: 5)
                    .frame(width: geometry.size.width-50)
            }
            .frame(height: 450)
            
            // selection: $picTime
            DatePicker("",selection: Binding(get: {
                self.picTime
            }, set: {
                self.picTime = $0
                self.number_year = Double(Calendar.current.component(.year, from: self.picTime))
            }), in: dateFormatter.date(from: "201001")! ... dateFormatter.date(from:"201912")!, displayedComponents: .date)
                .labelsHidden()
            //value: $number_year
            Slider(value: Binding(get: {
                self.number_year
            }, set: {
                self.number_year = $0
                var components = DateComponents()
                components.calendar = Calendar.current
                components.year = Int(self.number_year)
                self.picTime = components.date!
            }), in: 2010...2019 ,step: 1, minimumValueLabel: Text("2010"), maximumValueLabel: Text("2019")) {Text("")}
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
