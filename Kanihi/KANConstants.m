//
//  KANConstants.m
//  Kanihi
//
//  Created by Chris Lucas on 7/8/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import "KANConstants.h"

// KANDataStore
NSUInteger const KANDataStoreFetchLimit = 1000;

// Model Entity Names
NSString * const KANTrackEntityName         = @"Track";
NSString * const KANTrackArtistEntityName   = @"TrackArtist";
NSString * const KANAlbumEntityName         = @"Album";
NSString * const KANAlbumArtistEntityName   = @"AlbumArtist";
NSString * const KANDiscEntityName          = @"Disc";
NSString * const KANGenreEntityName         = @"Genre";

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

NSString * const KANDiscNameKey             = @"disc_subtitle";
NSString * const KANDiscNumKey              = @"disc_num";
NSString * const KANDiscTrackTotalKey       = @"track_total";

NSString * const KANAlbumNameKey            = @"album_name";
NSString * const KANAlbumTotalDiscsKey      = @"disc_total";

NSString * const KANAlbumArtistNameKey          = @"album_artist";
NSString * const KANAlbumArtistNameSortOrderKey = @"album_artist_sort_order";

NSString * const KANTrackArtistNameKey          = @"track_artist";
NSString * const KANTrackArtistNameSortOrderKey = @"track_artist_sort_order";

NSString * const KANGenreNameKey    = @"genre";