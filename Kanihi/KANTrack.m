//
//  KANTrack.m
//  Kanihi
//
//  Created by Chris Lucas on 7/7/13.
//  Copyright (c) 2013 Chris Lucas. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "KANTrack.h"

#import "NSDictionary+CJExtensions.h"
#import "CJStringNormalization.h"

#import "KANDisc.h"
#import "KANGenre.h"
#import "KANTrackArtist.h"
#import "KANAlbum.h"
#import "KANArtwork.h"

#import "KANAPI.h"
#import "KANDataStore.h"
#import "KANAudioStore.h"

@implementation KANTrack

@dynamic date;
@dynamic duration;
@dynamic group;
@dynamic lyrics;
@dynamic mood;
@dynamic name;
@dynamic sectionTitle;
@dynamic normalizedName;
@dynamic num;
@dynamic originalDate;
@dynamic subtitle;
@dynamic uuid;
@dynamic artist;
@dynamic disc;
@dynamic genre;
@dynamic artworks;

+ (NSString *)entityName
{
    return KANTrackEntityName;
}

+ (NSPredicate *)uniquePredicateForData:(NSDictionary *)data
{
    return [NSPredicate predicateWithFormat:@"uuid = %@", data[KANTrackUUIDKey]];
}

- (void)updateWithData:(NSDictionary *)data context:(NSManagedObjectContext *)context
{
    self.uuid = [data nonNullObjectForKey:KANTrackUUIDKey];
    self.name = [data nonNullObjectForKey:KANTrackNameKey];
    self.duration = [data nonNullObjectForKey:KANTrackDurationKey];
    self.group = [data nonNullObjectForKey:KANTrackGroupKey];
    self.lyrics = [data nonNullObjectForKey:KANTrackLyricsKey];
    self.mood = [data nonNullObjectForKey:KANTrackMoodKey];
    self.num = [data nonNullObjectForKey:KANTrackNumKey];
    self.subtitle = [data nonNullObjectForKey:KANTrackSubtitleKey];
    
    if ([data nonNullObjectForKey:KANTrackDateKey] != nil) {
        self.date = [KANUtils dateFromRailsDateString:[data nonNullObjectForKey:KANTrackDateKey]];
        //NSLog(@"%@", track.date);
    }
    if ([data nonNullObjectForKey:KANTrackOriginalDateKey] != nil) {
        self.originalDate = [KANUtils dateFromRailsDateString:[data nonNullObjectForKey:KANTrackOriginalDateKey]];
    }

    KANDataStore *dataStore = [KANDataStore sharedDataStore];
    self.artist    = [KANTrackArtist uniqueEntityForData:data[KANTrackTrackArtistKey] withCache:dataStore.trackArtistCache cacheKey:data[KANTrackTrackArtistKey][KANTrackArtistUUIDKey] lookupEntity:YES context:context];
    self.disc      = [KANDisc uniqueEntityForData:data[KANTrackDiscKey] withCache:dataStore.discCache cacheKey:data[KANTrackDiscKey][KANDiscUUIDKey] lookupEntity:YES context:context];
    self.genre     = [KANGenre uniqueEntityForData:data[KANTrackGenreKey] withCache:dataStore.genreCache cacheKey:data[KANTrackGenreKey][KANGenreUUIDKey] lookupEntity:YES context:context];

    NSMutableSet *artworks = [self mutableSetValueForKey:@"artworks"]; // core data proxy set

    // ensure artwork isn't already in track.artworks by doing a checksum lookup before adding
    NSMutableSet *checksums = [[NSMutableSet alloc] initWithCapacity:artworks.count];
    for (KANArtwork *artwork in artworks)
        [checksums addObject:[artwork.checksum lowercaseString]];

    for (NSDictionary *artworkData in data[KANTrackArtworkKey]) {
        KANArtwork *artwork = [KANArtwork uniqueEntityForData:artworkData withCache:nil cacheKey:nil lookupEntity:YES context:context];

        if (![checksums containsObject:[artwork.checksum lowercaseString]])
            [artworks addObject:artwork];
    }
}

- (void)setName:(NSString *)name
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:name forKey:@"name"];
    self.normalizedName = [KANUtils normalizedStringForString:name];
    self.sectionTitle = [KANUtils sectionTitleForString:name];
    
    [self didChangeValueForKey:@"name"];
}

- (NSMutableDictionary *)nowPlayingInfo
{
    NSMutableDictionary *npi = [[NSMutableDictionary alloc] init];

    npi[MPMediaItemPropertyTitle]                   = self.name;
    npi[MPMediaItemPropertyArtist]                  = self.artist.name;
    npi[MPMediaItemPropertyAlbumTrackCount]         = [NSNumber numberWithInteger:self.disc.album.tracks.count],
    npi[MPMediaItemPropertyAlbumTrackNumber]        = self.num;

    return npi;
}

#pragma mark - CJAudioPlayerQueueItem methods

- (NSURL *)httpURL
{
    return [KANAPI streamURLForTrack:self];
}

- (NSURL *)cacheURL
{
    NSURL *url;
    NSString *filename = [KANAPI suggestedFilenameForTrack:self];

    if (filename)
        url = [KANAudioStore cacheURLWithFilename:filename];

    return url;
}

- (id)queueID
{
    return self.uuid;
}


@end
