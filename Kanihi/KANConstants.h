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

// API (relative paths)
NSString * const KANAPITracksRootPath;
NSString * const KANAPITracksPath;
NSString * const KANAPITrackCountPath;
NSString * const KANAPITrackCountKey; // key for the returned json object
NSString * const KANAPIDeletedTracksPath;
NSString * const KANAPITrackStreamPathComponent;
NSString * const KANAPIServerInfoPath;
NSString * const KANAPIArtworkPath;

NSString * const KANAPIDeletedTracksRequestJSONKey;
NSString * const KANAPIDeletedTracksResponseJSONKey;

NSString * const KANAPIServerDidBecomeAvailableNotification;
NSString * const KANAPIServerDidBecomeUnavailableNotification;

NSUInteger const KANAPIMaxConcurrentConnections; // limit how many requests can hit the server at once

// KANDataStore
NSUInteger const KANDataStoreFetchLimit;

NSString * const KANDataStoreWillBeginUpdatingNotification;
NSString * const KANDataStoreDidBeginUpdatingNotification;
NSString * const KANDataStoreWillFinishUpdatingNotification;
NSString * const KANDataStoreDidFinishUpdatingNotification;

// KANArtworkStore
NSString * const KANArtworkStoreThumbnailDirectoryName;
NSString * const KANArtworkStoreFullSizeDirectoryName;

// Model Entity Names
NSString * const KANTrackEntityName;
NSString * const KANTrackArtistEntityName;
NSString * const KANAlbumEntityName;
NSString * const KANAlbumArtistEntityName;
NSString * const KANDiscEntityName;
NSString * const KANGenreEntityName;
NSString * const KANArtworkEntityName;

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
NSString * const KANTrackArtworkKey;

NSString * const KANDiscNameKey;
NSString * const KANDiscNumKey;
NSString * const KANDiscTrackTotalKey;

NSString * const KANAlbumNameKey;
NSString * const KANAlbumDiscTotalKey;

NSString * const KANAlbumArtistNameKey;
NSString * const KANAlbumArtistNameSortOrderKey;

NSString * const KANTrackArtistNameKey;
NSString * const KANTrackArtistNameSortOrderKey;

NSString * const KANGenreNameKey;

NSString * const KANArtworkKey;
NSString * const KANArtworkChecksumKey;
NSString * const KANArtworkTypeKey;
NSString * const KANArtworkDescriptionKey;