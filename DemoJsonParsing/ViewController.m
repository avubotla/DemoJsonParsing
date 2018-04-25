//
//  ViewController.m
//  DemoJsonParsing
//
//  Created by VIPadm on 25/04/18.
//  Copyright © 2018 botla. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSMutableDictionary *countriesDic;
}

@end

@implementation ViewController
@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    countriesDic = [[NSMutableDictionary alloc] init];
    
    NSString *url = @"http://services.groupkt.com/country/get/all";
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]){
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSLog(@"json: %@", json);
            
            if (jsonError != nil) {
                NSLog(@"JsonError: %@", jsonError.localizedDescription);
            } else {
                countriesDic = [[json objectForKey:@"RestResponse"] objectForKey:@"result"];
                NSLog(@"Countries Dic: %@", countriesDic);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
            });
        }
        
    }] resume];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return countriesDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
   
    cell.textLabel.text = [[countriesDic valueForKey:@"name"] objectAtIndex:indexPath.row];
    
    return cell;
}


@end
