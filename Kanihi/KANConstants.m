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
NSString * const KANAPITracksPath           = @"tracks.json";
NSString * const KANAPITrackCountPath       = @"tracks/count.json";
NSString * const KANAPITrackCountKey        = @"track_count";
NSString * const KANAPIDeletedTracksPath    = @"tracks/deleted.json";
NSString * const KANAPIServerInfoPath       = @"info.json";
NSString * const KANAPIArtworkPath          = @"images";

NSString * const KANAPIDeletedTracksRequestJSONKey  = @"current_tracks";
NSString * const KANAPIDeletedTracksResponseJSONKey = @"deleted_tracks";

NSString * const KANAPIServerDidBecomeAvailableNotification     = @"KANAPIServerDidBecomeAvailableNotification";
NSString * const KANAPIServerDidBecomeUnavailableNotification   = @"KANAPIServerDidBecomeUnavailableNotification";

// KANDataStore
NSUInteger const KANDataStoreFetchLimit = 1000;
NSString * const KANBackgroundThreadName = @"KANBackgroundThread";

NSString * const KANDataStoreWillBeginUpdatingNotification  = @"KANDataStoreWillBeginUpdatingNotification";
NSString * const KANDataStoreDidBeginUpdatingNotification   = @"KANDataStoreDidBeginUpdatingNotification";
NSString * const KANDataStoreWillFinishUpdatingNotification = @"KANDataStoreWillFinishUpdatingNotification";
NSString * const KANDataStoreDidFinishUpdatingNotification  = @"KANDataStoreDidFinishUpdatingNotification";

// KANArtworkStore
NSString * const KANArtworkStoreThumbnailDirectoryName  = @"thumbs";
NSString * const KANArtworkStoreFullSizeDirectoryName   = @"fullsize";

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
NSString * const KANTrackNameKey            = @"track_name";
NSString * const KANTrackNumKey             = @"track_num";
NSString * const KANTrackDurationKey        = @"duration";
NSString * const KANTrackGroupKey           = @"group";
NSString * const KANTrackLyricsKey          = @"lyrics";
NSString * const KANTrackMoodKey            = @"mood";
NSString * const KANTrackDateKey            = @"date";
NSString * const KANTrackOriginalDateKey    = @"original_date";
NSString * const KANTrackSubtitleKey        = @"subtitle";
NSString * const KANTrackArtworkKey         = @"images"; // key to the array of images

NSString * const KANDiscNameKey             = @"disc_subtitle";
NSString * const KANDiscNumKey              = @"disc_num";
NSString * const KANDiscTrackTotalKey       = @"track_total";

NSString * const KANAlbumNameKey            = @"album_name";
NSString * const KANAlbumDiscTotalKey       = @"disc_total";

NSString * const KANAlbumArtistNameKey          = @"album_artist";
NSString * const KANAlbumArtistNameSortOrderKey = @"album_artist_sort_order";

NSString * const KANTrackArtistNameKey          = @"track_artist";
NSString * const KANTrackArtistNameSortOrderKey = @"track_artist_sort_order";

NSString * const KANGenreNameKey    = @"genre";

NSString * const KANArtworkKey              = @"image"; // key to the single image
NSString * const KANArtworkChecksumKey      = @"checksum";
NSString * const KANArtworkTypeKey          = @"type";
NSString * const KANArtworkDescriptionKey   = @"description";