#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import "WMFArticlePreviewTableViewCell.h"
#import "UIView+WMFDefaultNib.h"
#import "UIView+VisualTestSizingUtils.h"
#import "UIApplication+VisualTestUtils.h"

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
    FBSnapshotVerifyViewWithOptions(self.cell,
                                    [[UIApplication sharedApplication] wmf_userInterfaceLayoutDirectionAsString],
                                    FBSnapshotTestCaseDefaultSuffixes(),
                                    0.05);
}

@end

NS_ASSUME_NONNULL_END
