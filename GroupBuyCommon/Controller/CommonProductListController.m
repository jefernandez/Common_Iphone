//
//  CommonProductListController.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommonProductListController.h"
#import "PPTableViewController.h"
#import "GroupBuyNetworkRequest.h"
#import "GroupBuyNetworkConstants.h"
#import "PPNetworkRequest.h"
#import "LocationService.h"
#import "MoreTableViewCell.h"
#import "ProductTextCell.h"
#import "ProductManager.h"
#import "Product.h"

@implementation CommonProductListController

@synthesize superController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [superController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// to be override
- (NSArray*)requestProductListFromDB
{
    return [ProductManager getAllProductsByUseFor:USE_FOR_PRICE sortByKey:@"price"];
}

// to be override
- (void)requestProductListFromServer:(BOOL)isRequestLastest
{
//    double longitude;
//    double latitude;
//    
//    LocationService* locationService = GlobalGetLocationService();
//    longitude = locationService.currentLocation.coordinate.longitude;
//    latitude = locationService.currentLocation.coordinate.latitude;
//    
//    LocalDataService* localService = GlobalGetLocalDataService();
//    
//    // tag_more_rows
//    if (!isRequestLastest){
//        NSString* lastPostId = [PostControllerUtils getLastPostId:dataList];        
//        [localService requestUserAtMePostData:self beforeTimeStamp:lastPostId cleanData:NO];
//    }
//    else{
//        [localService requestUserAtMePostData:self beforeTimeStamp:nil cleanData:YES];
//    }    
}

- (void)productDataRefresh:(int)result
{    
    if (result == ERROR_SUCCESS){
        self.dataList = [self requestProductListFromDB];        
        [self.dataTableView reloadData];
    }
    
    if ([self isReloading]){
        [self dataSourceDidFinishLoadingNewData];
    }
}

- (void)initDataList
{
    self.dataList = [self requestProductListFromDB];
    [self requestProductListFromServer:YES];            
}

#pragma Pull Refresh Delegate
- (void) reloadTableViewDataSource
{
    [self requestProductListFromServer:YES];
}


- (void)viewDidLoad
{    
    supportRefreshHeader = YES;
    
    [self initDataList];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.dataList = [self requestProductListFromDB]; 
    [super viewDidAppear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark Table View Delegate

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView 
//{
//	NSMutableArray* array = [NSMutableArray arrayWithArray:[ArrayOfCharacters getArray]];
//	[array addObject:kSectionNull];
//	return array;
//	
////		NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
////		return nil;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//	return [groupData sectionForLetter:title];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = [groupData titleForSection:section];	
	
	//	switch (section) {
	//		case <#constant#>:
	//			<#statements#>
	//			break;
	//		default:
	//			break;
	//	}
	
	return sectionHeader;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//	return [self getSectionView:tableView section:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return sectionImageHeight;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//	return [self getFooterView:tableView section:section];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//	return footerImageHeight;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// return [self getRowHeight:indexPath.row totalRow:[dataList count]];
	// return cellImageHeight;
    if ([self isMoreRow:indexPath.row]){
        return [MoreTableViewCell getRowHeight];
    }
    
	return [ProductTextCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;		// default implementation
	
	// return [groupData totalSectionCount];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataListCountWithMore];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // tag_more_rows
    if ([self isMoreRow:indexPath.row]){
        // check if it's last row - to load more
        MoreTableViewCell* moreCell = [MoreTableViewCell createCell:theTableView];
        self.moreLoadingView = moreCell.loadingView;
        return moreCell;
    }
    
    
    NSString *CellIdentifier = [ProductTextCell getCellIdentifier];
	ProductTextCell *cell = (ProductTextCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
        cell = [ProductTextCell createCell:self];
	}
	
	// set text label
	int row = [indexPath row];	
	int count = [dataList count];
	if (row >= count){
		NSLog(@"[WARN] cellForRowAtIndexPath, row(%d) > data list total number(%d)", row, count);
		return cell;
	}
	
    //	[self setCellBackground:cell row:row count:count];        
	
//	Product* product = [dataList objectAtIndex:row];
//    [cell setCellInfoWithProduct:post indexPath:indexPath];    
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
    // tag_more_rows
    if ([self isMoreRow:indexPath.row]){
        [self.moreLoadingView startAnimating];
        [self requestProductListFromServer:NO];
        return;
    }
    
	if (indexPath.row > [dataList count] - 1)
		return;
	
	// do select row action
//    [PostControllerUtils gotoPostController:self.superController 
//                                       post:[dataList objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		if (indexPath.row > [dataList count] - 1)
			return;
		
		// take delete action below, update data list
		// NSObject* dataObject = [dataList objectAtIndex:indexPath.row];		
		
		// update table view
		
	}
	
}

- (void)clickPlaceNameButton:(id)sender atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [dataList count])
        return;
    
//    Post* post = [dataList objectAtIndex:indexPath.row];
//    [PostControllerUtils askFollowPlace:post.placeId placeName:post.placeName  viewController:self];
    
    
    
}

- (void)clickUserAvatarButton:(id)sender atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [dataList count])
        return;
    
//    Post* post = [dataList objectAtIndex:indexPath.row];    
//    [PrivateMessageControllerUtils showPrivateMessageController:post.userId 
//                                                   userNickName:post.userNickName
//                                                     userAvatar:post.userAvatar
//                                                 viewController:self.superController];      
}



@end