//
//  ViewController.m
//  FaceBookLogin
//
//  Created by satheesh on 6/25/15.
//  Copyright (c) 2015 Satish. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <DropboxSDK/DropboxSDK.h>


@interface ViewController ()<DBRestClientDelegate>
{
    UIActivityIndicatorView *indicator;

}
@property (nonatomic, strong) DBRestClient *restClient;
@property (strong , nonatomic) NSMutableArray * mArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
  /*  FBSDKLoginButton * btn = [[FBSDKLoginButton alloc]init];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    
    btn.readPermissions = @[@"public_profile", @"email", @"user_friends"];*/
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    self.mArray = [[NSMutableArray alloc]init];
    
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
  
    // Write a file to the local documents directory
    NSString *text = @"Hello world.";
    NSString *filename = @"workingDemoHelloSatish.txt";
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [text writeToFile:localPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Upload file to Dropbox
    NSString *destDir = @"/";
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
 
    [self.restClient loadMetadata:@""];
     [indicator startAnimating];
  //  [self.restClient loadFile:@"/workingDemoHelloSatish.txt" intoPath:localPath];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
 /*   if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
             }
         }];
    }*/
}
- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath metadata:(DBMetadata *)metadata {
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
    NSLog(@"File upload failed with error: %@", error);
}
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        

      
       
        
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"the files are 	%@", file.filename);
            
            [self.mArray addObject:file.filename];
            [self.mTableView reloadData];
            [indicator stopAnimating];
        }
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}
- (IBAction)didPressLink {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
}
- (IBAction)logOut:(id)sender {
     [[DBSession sharedSession] unlinkAll];
    [self.mArray removeAllObjects];
    [self.mTableView reloadData];
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellID = @"CellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    
    cell.textLabel.text = [self.mArray objectAtIndex:indexPath.row];
    
    return cell;
    
    
    
}
@end
