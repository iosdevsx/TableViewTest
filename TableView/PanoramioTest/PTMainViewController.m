//
//  ViewController.m
//  PanoramioTest
//
//  Created by Dev on 08.02.16.
//  Copyright © 2016 Dev. All rights reserved.
//

#import "PTMainViewController.h"
#import "PTServerManager.h"
#import "PTPhotosTableViewCell.h"
#import "PTPhoto.h"
#import "UIImageView+AFNetworking.h"

@interface PTMainViewController ()

@property (strong, nonatomic) NSMutableArray* photosArray;
@property (assign, nonatomic) NSInteger index;

@end

@implementation PTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.index = 0;
    self.photosArray = [NSMutableArray array];
    [self getPhotosFromServer];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -Private Methods

- (void) getPhotosFromServer
{
    [[PTServerManager sharedManager] getPhotosWithCount:100 andOffset:[self.photosArray count] onSuccess:^(NSArray *photos) {
        [self.photosArray addObjectsFromArray:photos];
        [self.tableView reloadData];
    } onFailure:^(NSError *error) {
        [self showAlertWithTitle:@"Error" andMessage:@"Couldn't load photos"];
    }];
}

- (void) showAlertWithTitle: (NSString*) title
                 andMessage: (NSString*) message
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIImage*) scaleImage: (UIImage*) image toWidth: (NSInteger) width andHeight: (NSInteger) height
{
    CGSize sizeForImg = CGSizeMake(width, height);
    UIGraphicsBeginImageContextWithOptions(sizeForImg, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sizeForImg.width, sizeForImg.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) setImageOnView: (UIImageView*) view
               atIndex: (NSInteger) index
{
    PTPhoto* photo = [self.photosArray objectAtIndex:index];
    NSURLRequest* request = [NSURLRequest requestWithURL:photo.photoFileUrl];
    __weak UIImageView* weakView = view;
    [view setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"placeholder.png"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        weakView.image = [self scaleImage:image toWidth:298 andHeight:200];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        [self showAlertWithTitle:@"error" andMessage:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
    }];
}


#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.photosArray count] % 2 == 0)
    {
        return [self.photosArray count] / 2;
    }
    return ([self.photosArray count] - 1) / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"PTPhotosTableViewCell";
    PTPhotosTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[PTPhotosTableViewCell alloc] init];
    }
    if ([self.photosArray count] > 1)
    {
        NSInteger index = indexPath.row * 2;
        [self setImageOnView:cell.imageViewLeft atIndex:index];
        [self setImageOnView:cell.imageViewRight atIndex:index + 1];
    }
    
    if (indexPath.row == ([self.photosArray count] / 2) - 5)
    {
        [self getPhotosFromServer];
    }
    return cell;
}

#pragma mark -UITableViewDelegate

@end
