//
//  KANConstants.h
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

// User Defaults
NSString * const KANUserDefaultsLastUpdatedKey;
NSString * const KANUserDefaultsHostKey;
NSString * const KANUserDefaultsPortKey;
NSString * const KANUserDefaultsAuthUserKey;
NSString * const KANUserDefaultsAuthPassKey;

// API
NSString * const KANAPITracksPath;

// KANDataStore
// TODO: Notifications
NSUInteger const KANDataStoreFetchLimit;

// Model Entity Names
NSString * const KANTrackEntityName;
NSString * const KANTrackArtistEntityName;
NSString * const KANAlbumEntityName;
NSString * const KANAlbumArtistEntityName;
NSString * const KANDiscEntityName;
NSString * const KANGenreEntityName;

// Keys for tracks.json API
NSString * const KANTrackUUIDKey;
NSString * const KANTrackNameKey;
NSString * const KANTrackNumKey;
NSString * const KANTrackDurationKey;
NSString * const KANTrackGroupKey;
NSString * const KANTrackLyricsKey;
NSString * const KANTrackMoodKey;
NSString * const KANTrackDateKey;
NSString * const KANTrackOriginalDateKey;
NSString * const KANTrackSubtitleKey;

NSString * const KANDiscNameKey;
NSString * const KANDiscNumKey;
NSString * const KANDiscTrackTotalKey;

NSString * const KANAlbumNameKey;
NSString * const KANAlbumTotalDiscsKey;

NSString * const KANAlbumArtistNameKey;
NSString * const KANAlbumArtistNameSortOrderKey;

NSString * const KANTrackArtistNameKey;
NSString * const KANTrackArtistNameSortOrderKey;

NSString * const KANGenreNameKey;

