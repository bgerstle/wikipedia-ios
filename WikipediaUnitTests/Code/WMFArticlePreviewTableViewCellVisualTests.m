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
    
}

@end

NS_ASSUME_NONNULL_END
