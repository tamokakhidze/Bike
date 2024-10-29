//
//  BikeAppWidgetLiveActivity.swift
//  BikeAppWidget
//
//  Created by Tamuna Kakhidze on 25.08.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BikeAppWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BikeAppWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BikeAppWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BikeAppWidgetAttributes {
    fileprivate static var preview: BikeAppWidgetAttributes {
        BikeAppWidgetAttributes(name: "World")
    }
}

extension BikeAppWidgetAttributes.ContentState {
    fileprivate static var smiley: BikeAppWidgetAttributes.ContentState {
        BikeAppWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BikeAppWidgetAttributes.ContentState {
         BikeAppWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BikeAppWidgetAttributes.preview) {
   BikeAppWidgetLiveActivity()
} contentStates: {
    BikeAppWidgetAttributes.ContentState.smiley
    BikeAppWidgetAttributes.ContentState.starEyes
}
