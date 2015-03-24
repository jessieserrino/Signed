//
//  SignatureViewController.m
//  Signed
//
//  Created by Jessie Serrino on 3/19/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

#import "SignatureViewController.h"
#import "AddSignatureViewController.h"
#import "SignatureProcessManager.h"

static NSString * const SegueToAddSignature = @"SegueToAddSignature";

@interface SignatureViewController ()
@property (strong, nonatomic) IBOutlet UIView *drawableView;
@property (strong, nonatomic) SignatureMaker *signatureMaker;
@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self initializeSignatureMaker];
}

- (void) initializeSignatureMaker
{
    self.signatureMaker = [[SignatureMaker alloc] initWithFrame:self.drawableView.bounds];
    [SignatureProcessManager sharedManager].signatureMaker = self.signatureMaker;
    [self.drawableView.layer addSublayer:self.signatureMaker];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)drawSignatureMotion:(UIPanGestureRecognizer *)sender {
    CGPoint touch = [sender locationInView:self.drawableView];
    CGPoint velocity = [sender velocityInView:self.drawableView];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        [self.signatureMaker startLineWithPoint:touch];
    } else if(sender.state == UIGestureRecognizerStateChanged){
        [self.signatureMaker continueLineWithPoint:touch andVelocity:velocity];
    } else if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        [self.signatureMaker endLineWithPoint:touch andVelocity:velocity];
    }
}


- (IBAction)acceptSignature:(UIBarButtonItem *)sender {
    
    
    [self performSegueWithIdentifier:SegueToAddSignature sender:self];
}
- (IBAction)cancelSignature:(UIBarButtonItem *)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)feltTipButtonTouched:(UIButton *)sender {
}

- (IBAction)fountainTipButtonTouched:(id)sender {
}

- (IBAction)undoButton:(UIButton *)sender {
    [self.signatureMaker undoLine];
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Create signature image");
}



@end
