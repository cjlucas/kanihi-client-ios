//
//  KANConstants.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANConstants.h"

// User Defaults
NSString * const KANUserDefaultsLastUpdatedKey  = @"lastUpdated";
NSString * const KANUserDefaultsHostKey         = @"host";
NSString * const KANUserDefaultsPortKey         = @"port";
NSString * const KANUserDefaultsAuthUserKey     = @"authUser";
NSString * const KANUserDefaultsAuthPassKey     = @"authPass";

// API
NSString * const KANAPITracksRootPath       = @"tracks";
NSString * const KANAPITracksPath           = @"tracks.json";
NSString * const KANAPITrackCountPath       = @"tracks/count.json";
NSString * const KANAPITrackCountKey        = @"track_count";
NSString * const KANAPIDeletedTracksPath    = @"tracks/deleted.json";
NSString * const KANAPITrackStreamPathComponent = @"stream";
NSString * const KANAPIServerInfoPath       = @"info.json";
NSString * const KANAPIArtworkPath          = @"images";

NSString * const KANAPIDeletedTracksRequestJSONKey  = @"current_tracks";
NSString * const KANAPIDeletedTracksResponseJSONKey = @"deleted_tracks";

NSString * const KANAPIServerDidBecomeAvailableNotification     = @"KANAPIServerDidBecomeAvailableNotification";
NSString * const KANAPIServerDidBecomeUnavailableNotification   = @"KANAPIServerDidBecomeUnavailableNotification";

NSUInteger const KANAPIMaxConcurrentConnections = 1;

// KANDataStore
NSUInteger const KANDataStoreFetchLimit = 1000;

NSString * const KANDataStoreWillBeginUpdatingNotification  = @"KANDataStoreWillBeginUpdatingNotification";
NSString * const KANDataStoreDidBeginUpdatingNotification   = @"KANDataStoreDidBeginUpdatingNotification";
NSString * const KANDataStoreWillFinishUpdatingNotification = @"KANDataStoreWillFinishUpdatingNotification";
NSString * const KANDataStoreDidFinishUpdatingNotification  = @"KANDataStoreDidFinishUpdatingNotification";

// KANArtworkStore
NSString * const KANArtworkStoreThumbnailDirectoryPath  = @"images/thumbs";
NSString * const KANArtworkStoreFullSizeDirectoryPath   = @"images/fullsize";
NSString * const KANArtworkStoreBlurredDirectoryPath    = @"images/blurred";

// Model Entity Names
NSString * const KANTrackEntityName         = @"Track";
NSString * const KANTrackArtistEntityName   = @"TrackArtist";
NSString * const KANAlbumEntityName         = @"Album";
NSString * const KANAlbumArtistEntityName   = @"AlbumArtist";
NSString * const KANDiscEntityName          = @"Disc";
NSString * const KANGenreEntityName         = @"Genre";
NSString * const KANArtworkEntityName       = @"Artwork";

// Keys for tracks.json API
NSString * const KANTrackUUIDKey            = @"uuid";
NSString * const KANTrackNameKey            = @"name";
NSString * const KANTrackNumKey             = @"num";
NSString * const KANTrackDurationKey        = @"duration";
NSString * const KANTrackGroupKey           = @"group";
NSString * const KANTrackLyricsKey          = @"lyrics";
NSString * const KANTrackMoodKey            = @"mood";
NSString * const KANTrackDateKey            = @"date";
NSString * const KANTrackOriginalDateKey    = @"original_date";
NSString * const KANTrackSubtitleKey        = @"subtitle";
// keys to children
NSString * const KANTrackArtworkKey         = @"images";
NSString * const KANTrackDiscKey            = @"disc";
NSString * const KANTrackTrackArtistKey     = @"track_artist";
NSString * const KANTrackGenreKey           = @"genre";

NSString * const KANDiscUUIDKey             = @"uuid";
NSString * const KANDiscNameKey             = @"subtitle";
NSString * const KANDiscNumKey              = @"num";
NSString * const KANDiscTrackTotalKey       = @"total_tracks";
NSString * const KANDiscAlbumKey            = @"album";

NSString * const KANAlbumUUIDKey            = @"uuid";
NSString * const KANAlbumNameKey            = @"name";
NSString * const KANAlbumDiscTotalKey       = @"total_discs";
NSString * const KANAlbumAlbumArtistKey     = @"album_artist";

NSString * const KANAlbumArtistUUIDKey          = @"uuid";
NSString * const KANAlbumArtistNameKey          = @"name";
NSString * const KANAlbumArtistNameSortOrderKey = @"sort_name";

NSString * const KANTrackArtistUUIDKey          = @"uuid";
NSString * const KANTrackArtistNameKey          = @"name";
NSString * const KANTrackArtistNameSortOrderKey = @"sort_name";

NSString * const KANGenreUUIDKey    = @"uuid";
NSString * const KANGenreNameKey    = @"name";

NSString * const KANArtworkKey              = @"image"; // key to the single image
NSString * const KANArtworkChecksumKey      = @"checksum";
NSString * const KANArtworkTypeKey          = @"type";
NSString * const KANArtworkDescriptionKey   = @"description";