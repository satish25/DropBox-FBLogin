//
//  ViewController.h
//  FaceBookLogin
//
//  Created by satheesh on 6/25/15.
//  Copyright (c) 2015 Satish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
- (IBAction)didPressLink;

@end

