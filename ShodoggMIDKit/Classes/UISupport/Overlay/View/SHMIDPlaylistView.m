//
//  SHMIDPlaylistView.m
//  ShodoggMIDKit
//
//  Created by Aamir Khan on 7/18/16.
//
//

#import "SHMIDPlaylistView.h"
#import "SHMIDPlaylistItemView.h"
#import "SHMIDCastController.h"
#import "SHMIDUtilities.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * cellIdentifier    = @"kSHMIDPlaylistItemIdentifier";
static NSString * const kItemHeader = @"SHMIDPlaylistItemHeaderKey";
static NSString * const kItemTitle  = @"SHMIDPlaylistItemTitleKey";
static NSString * const kItemUrl    = @"SHMIDPlaylistItemUrlKey";

@interface SHMIDPlaylistView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *playlistCollectionView;
@property (nonatomic, strong) NSArray *playlist;
@end

@implementation SHMIDPlaylistView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UICollectionViewFlowLayout *collectionViewflowLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _playlistCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:collectionViewflowLayout];
        _playlistCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        self.playlistCollectionView.backgroundColor = [UIColor clearColor];
        _playlistCollectionView.pagingEnabled = YES;
        _playlistCollectionView.dataSource = self;
        _playlistCollectionView.delegate = self;
        [_playlistCollectionView registerClass:[SHMIDPlaylistItemView class] forCellWithReuseIdentifier:cellIdentifier];
        [self addSubview:_playlistCollectionView];
        
        NSDictionary *views = @{@"PlaylistCollectionView" : _playlistCollectionView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[PlaylistCollectionView]|" options:0 metrics:0 views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[PlaylistCollectionView]|" options:0 metrics:0 views:views]];
        
        [self loadContent];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)loadContent {
    SHMIDMediaItem *item = [SHMIDCastController sharedInstance].contextItem;
    NSString *dummyItemTitle =
    @"Krysten Ritter Gets Conan A Surprise Holiday Present";
    NSString *dummyItemPosterUrlString
    = @"https://storage.googleapis.com/shodogg/mid/sample-videos/conan/images/Krysten%20Ritter%20Gets%20Conan%20A%20Surprise%20Holiday%20Present/image569x320.png";
    
    _playlist = @[@{kItemHeader : NilToEmptyString(item.show.uppercaseString),
                    kItemTitle  : NilToEmptyString(item.title),
                    kItemUrl    : NilToEmptyString(item.posterURL)},
                  @{kItemHeader : @"CONAN",
                    kItemTitle  : dummyItemTitle,
                    kItemUrl    : dummyItemPosterUrlString}];
    [_playlistCollectionView reloadData];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _playlist.count;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SHMIDPlaylistItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *item = _playlist[indexPath.row];
    cell.headerLabel.text = item[kItemHeader];
    cell.detailLabel.text = item[kItemTitle];
    UIImage *placeholderImage = [SHMIDUtilities imageNamed:@"media_video_placeholder"];
    NSURL *posterImageURL = [NSURL URLWithString:item[kItemUrl]];
    [cell.artworkView sd_setImageWithURL:posterImageURL placeholderImage:placeholderImage];
    if (indexPath.row == 0) {
        cell.artworkView.alpha = 0.4;
        cell.addToPlaylistButton.hidden = NO;
        [cell.addToPlaylistButton addTarget:self action:@selector(addToPlaylistButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)addToPlaylistButtonTapped:(id)sender {
#warning TODO: to be implemented
    NSLog(@"addToPlaylistButtonTapped:");
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat padding = (width-(width*0.80))/2.0;
    return UIEdgeInsetsMake(0.0, padding, 0.0, padding);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    CGFloat height = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    if (height<500.0) {
        height *= 0.50;
    } else {
        height *= 0.45;
    }
    return CGSizeMake(width*0.80, height);
}
@end