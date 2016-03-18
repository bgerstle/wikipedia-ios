//
//  WMFGalleryDataSourceTests.m
//  Wikipedia
//
//  Created by Brian Gerstle on 12/8/15.
//  Copyright © 2015 Wikimedia Foundation. All rights reserved.
//

@import Quick;
@import Nimble;
@import NSDate_Extensions;
#import <SSDataSources/SSDataSources.h>

#import "WMFModalPOTDGalleryDataSource.h"
#import "WMFArticleImageGalleryDataSource.h"
#import "WMFModalArticleImageGalleryDataSource.h"
#import "Wikipedia-Swift.h"

#import "SSArrayDataSource+WMFReverseIfRTL.h"
#import "MWKDataStore+TempDataStoreForEach.h"
#import "NSDate+WMFDateRanges.h"

QuickConfigurationBegin(WMFGalleryDataSourceTestsConfiguration)

+ (void)configure : (Configuration*)configuration {
    sharedExamples(@"an RTL compliant gallery data source", ^(QCKDSLSharedExampleContext contextProvider) {
        __block NSArray* rawItems;
        __block SSBaseDataSource* dataSource;
        beforeEach(^{
            NSDictionary* context = contextProvider();
            rawItems = context[@"items"];
            dataSource = context[@"dataSource"];
        });

        it(@"should reorder the items if necessary", ^{
            BOOL shouldReverse = [[NSProcessInfo processInfo] wmf_isOperatingSystemVersionLessThan9_0_0]
                                 && [[UIApplication sharedApplication] wmf_isRTL];
            
            NSArray* expectedItems = shouldReverse ? [rawItems wmf_reverseArray] : rawItems;
            
            [expectedItems enumerateObjectsUsingBlock:^(id _Nonnull expectedItem, NSUInteger idx, BOOL* _) {
                id itemAtIndexPath = [dataSource itemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
                expect(itemAtIndexPath).to(equal(expectedItem));
            }];
        });
    });
}

QuickConfigurationEnd

QuickSpecBegin(WMFGalleryDataSourceTests)

describe(@"SSArrayDataSource.wmf_initWithitemsAndReverseIfNeeded", ^{
    itBehavesLike(@"an RTL compliant gallery data source", ^{
        NSArray* items = @[@0, @1, @2];
        return @{
            @"items": items,
            @"dataSource": [[SSArrayDataSource alloc] initWithItemsAndReverseIfNeeded:items]
        };
    });
});

describe(@"WMFArticleImageGalleryDataSource", ^{
    __block MWKArticle* obamaArticle;
    configureTempDataStoreForEach(tempDataStore, ^{
        NSDictionary* fixtureJSON = [[self wmf_bundle] wmf_jsonFromContentsOfFile:@"Obama"][@"mobileview"];
        obamaArticle = [[MWKArticle alloc] initWithTitle:[MWKTitle random]
                                               dataStore:tempDataStore
                                                    dict:fixtureJSON];
    });

    itBehavesLike(@"an RTL compliant gallery data source", ^{
        return @{ @"items": obamaArticle.images.uniqueLargestVariants,
                  @"dataSource": [[WMFArticleImageGalleryDataSource alloc] initWithArticle:obamaArticle] };
    });

    // test the subclass too, same context
    itBehavesLike(@"an RTL compliant gallery data source", ^{
        return @{ @"items": obamaArticle.images.uniqueLargestVariants,
                  @"dataSource": [[WMFModalArticleImageGalleryDataSource alloc] initWithArticle:obamaArticle] };
    });
});

describe(@"WMFModalPOTDImageGalleryDataSource", ^{
    itBehavesLike(@"an RTL compliant gallery data source", ^{
        NSDate* testDate = [NSDate date];
        NSArray<NSDate*>* dates = [[testDate dateBySubtractingDays:WMFDefaultNumberOfPOTDDates] wmf_datesUntilDate:testDate];
        MWKImageInfo* info = [[MWKImageInfo alloc] initWithCanonicalPageTitle:@"Foo"
                                                             canonicalFileURL:[NSURL URLWithString:@"http://foo.org/bar"]
                                                             imageDescription:nil
                                                                      license:nil
                                                                  filePageURL:nil
                                                                imageThumbURL:nil
                                                                        owner:nil
                                                                    imageSize:CGSizeZero
                                                                    thumbSize:CGSizeZero];
        return @{ @"items": dates,
                  @"dataSource": [[WMFModalPOTDGalleryDataSource alloc] initWithInfo:info forDate:testDate] };
    });
});

QuickSpecEnd
