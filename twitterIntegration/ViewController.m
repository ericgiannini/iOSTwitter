//
//  ViewController.m
//  twitterIntegration
//
//  Created by Eric Giannini on 11/15/15.
//  Copyright © 2015 UnicornMobile. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

- (void)configureTweetTextView ;
- (void)showAlertMessage:(NSString *)warningMessage ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureTweetTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showAlertMessage:(NSString *)warningMessage {
    
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Warning!" message:warningMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (IBAction)showShareAction:(id)sender {
    
    if ([self.tweetTextView isFirstResponder]) {
        [[self tweetTextView] resignFirstResponder];
    }

    UIAlertController *actionController = [UIAlertController alertControllerWithTitle:@"" message:@"Your Tweet" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *tweetAction = [UIAlertAction actionWithTitle:@"Tweet" style:UIAlertActionStyleDefault handler:
                                  ^(UIAlertAction *action){
                                      
                                      if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                                          
                                          SLComposeViewController *tweetVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                                          
                                          if ([self.tweetTextView.text length] < 140) {
                                              
                                              [tweetVC setInitialText:self.tweetTextView.text];
                                              
                                          } else {
                                              NSString *shortText = [self.tweetTextView.text substringFromIndex:140];
                                              [tweetVC setInitialText:shortText];
                                          }
                                          
                                          [self presentViewController:tweetVC animated:YES completion:nil];
                                        
                                          
                                      } else {
                                          
                                          [self showAlertMessage:@"Please sign into Twitter before tweeting. Go to Settings > Twitter > User Name:"];
                                          
                                      }
                                
                                  
                                  }];
    
    UIAlertAction *facebookAction = [UIAlertAction actionWithTitle:@"Post to Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            
            SLComposeViewController *facebookVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookVC setInitialText:self.tweetTextView.text];
            [self presentViewController:facebookVC animated:YES completion:nil];
            
        } else {
        
            [self showAlertMessage:@"Please sign in to Facebook."];
        }
        
    
    }];
    
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"More" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIActivityViewController *moreVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.tweetTextView.text] applicationActivities:nil];
        [self presentViewController:moreVC animated:YES completion:nil];
        
    }];

    
    [actionController addAction:cancel];
    [actionController addAction:tweetAction];
    [actionController addAction:facebookAction];
    [actionController addAction:moreAction];
    
    [self presentViewController:actionController animated:YES completion:nil];
    
}

- (void)configureTweetTextView {
    
    self.tweetTextView.layer.backgroundColor = [UIColor colorWithRed:1.0 green: 1.0 blue:0.9 alpha:1.0].CGColor;
    
    self.tweetTextView.layer.cornerRadius = 10.0;
    
    self.tweetTextView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    
    self.tweetTextView.layer.borderWidth = 2.0;
    
}

@end
