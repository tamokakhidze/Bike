//
//  BikeAppWidget.swift
//  BikeAppWidget
//
//  Created by Tamuna Kakhidze on 25.08.24.
//

import WidgetKit
import SwiftUI
import MapKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct BikeAppWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch widgetFamily {
        case .accessoryInline:
            
            Text(entry.date, format: .dateTime.year())
            
            
        case .accessoryCircular:
            Gauge(value: 0.5) {
                Text(entry.date, format: .dateTime.year())
            }.gaugeStyle(.accessoryCircular)
            
        case .accessoryRectangular:
            Gauge(value: 0.5) {
                Text(entry.date, format: .dateTime.year())
            }.gaugeStyle(.accessoryLinear)
        case .systemMedium:
            HStack {
                VStack(alignment: .leading) {
                    Image(.widgetPhoto1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 140, height: 78)
                        .cornerRadius(10)
                        .clipped()
                    Text("Next Gen")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                    
                    Text("3.56$ an hour")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Image(.widgetPhoto2)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 140, height: 78)
                        .cornerRadius(10)
                        .clipped()
                    Text("Peugeot Bicycle")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                    
                    Text("4.27$ an hour")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                
            }
            
        case .systemSmall:
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(.smallWidgetPhoto)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 62, height: 62)
                        .cornerRadius(10)
                        .clipped()
                    
                    Spacer()
                    
                    Image(.widgetIcon)
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 28)
                        .foregroundStyle(.black.opacity(0.5))
                        .clipped()
                }
                
                Text("15 min left")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundStyle(.black.opacity(0.2))
                
                Text("Best deal of today")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
            }
            
        default:
            Text("not implemented")
        }
    }
}

struct largeWidgetCard: View {
    
    var title: String
    var statistic: String
    var image: String
    var percentage: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(20)
            
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 17))
                Text(statistic)
                    .foregroundStyle(.primary)
                    .font(.system(size: 14))
                    .bold()
                
                HStack {
                    Image(image)
                    Text(percentage)
                    Text("vs Prev Week")
                        .font(.system(size: 13))
                }
            }
        }
        .frame(width: 160, height: 120)
        
    }
}

struct BikeAppWidget: Widget {
    let kind: String = "BikeAppWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            BikeAppWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
        }.supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular, .systemMedium, .systemSmall, .systemLarge])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    BikeAppWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
}
