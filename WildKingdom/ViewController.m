//
//  ViewController.m
//  WildKingdom
//
//  Created by Fletcher Rhoads on 1/23/14.
//  Copyright (c) 2014 Fletcher Rhoads. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate>
{
    __weak IBOutlet UICollectionView *collectionView;
    
    NSString *urlString;
    NSArray *pictures;
    NSMutableArray *pictureURLs;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self pullDataFromJSON:@"Lions"];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)pullDataFromJSON:(NSString*)searchString
{
    NSURL *flickrURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&text=%@&sort=relevance&safe_search=2&api_key=645eea2a5e67ccc928a9c8fe11f7c51b&format=json&nojsoncallback=1", searchString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:flickrURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        pictures = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"photos"][@"photo"];
        pictureURLs = [NSMutableArray arrayWithCapacity:pictures.count];
        
        for (NSDictionary *picture in pictures)
        {
            NSNumber *farm = picture[@"farm"];
            NSString *eyedee = picture[@"id"];
            NSString *secret = picture[@"secret"];
            NSString *server = picture[@"server"];
            NSString *pictureURL = [NSString stringWithFormat: @"http://farm%@.staticflickr.com/%@/%@_%@.jpg", farm, server, eyedee, secret];
            [pictureURLs addObject:pictureURL];
        }
        [collectionView reloadData];
    }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)myCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCollectionViewCell *cell = [myCollectionView dequeueReusableCellWithReuseIdentifier:@"pictureID" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[pictureURLs objectAtIndex:indexPath.row]]]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (pictureURLs.count > 10)
    {
        return 10;
    }else{
        return pictureURLs.count;
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (fromInterfaceOrientation == UIDeviceOrientationLandscapeLeft || fromInterfaceOrientation == UIDeviceOrientationLandscapeRight)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.itemSize = CGSizeMake(154, 153);

        
        [collectionView setCollectionViewLayout:flowLayout animated:YES];
    }else{
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(180, 180);
        
        [collectionView setCollectionViewLayout:flowLayout animated:YES];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"Lions"])
    {
        [self pullDataFromJSON:@"Lions"];
        self.navigationItem.title = item.title;
    }
    if ([item.title isEqualToString:@"Tigers"])
    {
        [self pullDataFromJSON:@"tigers"];
        self.navigationItem.title = item.title;
    }
    if ([item.title isEqualToString:@"Bears"])
    {
        [self pullDataFromJSON:@"bears"];
        self.navigationItem.title = item.title;
    }
}

@end
