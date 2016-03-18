#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import "WMFArticlePreviewTableViewCell.h"
#import "UIView+WMFDefaultNib.h"
#import "UIView+VisualTestSizingUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMFArticlePreviewTableViewCellVisualTests : FBSnapshotTestCase
@property (nonatomic, strong) WMFArticlePreviewTableViewCell* cell;
@end

@implementation WMFArticlePreviewTableViewCellVisualTests

- (void)setUp {
    [super setUp];
    self.recordMode = YES;
    self.cell = [WMFArticlePreviewTableViewCell wmf_viewFromClassNib];
}

- (void)testExampleWithShortText {
    // populate w/ data
    [self.cell setImageURL:nil];
    [self.cell setTitleText:@"Title"];
    [self.cell setDescriptionText:@"Short description."];
    [self.cell setSnippetText:@"Short extract."];
    // cells are usually laid out by their table view, here we do it manually
    [self.cell wmf_sizeToFitWindowWidth];
    // take/verify snapshot!
    FBSnapshotVerifyView(self.cell, nil);
}

@end

NS_ASSUME_NONNULL_END
