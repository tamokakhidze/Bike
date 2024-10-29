//
//  RentStatusLiveActivity.swift
//  RentStatus
//
//  Created by Tamuna Kakhidze on 26.08.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

extension BookingAttributes {
    fileprivate static var preview: BookingAttributes {
        BookingAttributes(bookingNumber: 23, bookingItems: "HELLO items")
    }
}

extension BookingAttributes.ContentState {
    fileprivate static var start: BookingAttributes.ContentState {
        BookingAttributes.ContentState(status: .bookingStarted)
    }
    
    fileprivate static var end: BookingAttributes.ContentState {
        BookingAttributes.ContentState(status: .bookingEnded)
    }
}

struct RentStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BookingAttributes.self) { context in
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Cyclo: Bike rental")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .italic()
                        .bold()
                    
                    Image(systemName: "bicycle")
                        .foregroundColor(.white)
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Rented bike: Hybrid")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .bold()
                        
                        Text("Mountain bike")
                            .font(.system(size: 16))
                            .foregroundColor(.gray.opacity(0.7))
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                }
                
            }
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(Color.black)
            .padding()
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("CYCLO")
                        .fontWeight(.black)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: "calendar.badge.clock.rtl")
                        .foregroundStyle(.green)
                        .frame(width: 50, height: 50)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: 300, height: 15)
                                .foregroundStyle(.gray.opacity(0.2))
                                .cornerRadius(50)
                            
                            Rectangle()
                                .frame(width: 20, height: 15)
                                .foregroundStyle(.green)
                                .cornerRadius(50)
                                .padding(.leading, 0)
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(.green)
                        
                        HStack {
                            Text("Start")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            Spacer()
                            Text("End")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 300)
                    }
                   
                }
                DynamicIslandExpandedRegion(.center) {
                        Text("Status")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    
                }
            } compactLeading: {
                Image(systemName: "point.bottomleft.forward.to.point.topright.scurvepath.fill")
                    .foregroundStyle(.white)
            } compactTrailing: {
                Image(systemName: "bicycle.circle.fill")
                    .foregroundStyle(.green)
            } minimal: {
                Text("\(context.state.status.rawValue.prefix(1))")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.gray)
        }
    }
}

#Preview("Notification", as: .content, using: BookingAttributes.preview) {
    RentStatusLiveActivity()
} contentStates: {
    BookingAttributes.ContentState.start
    BookingAttributes.ContentState.end
}
