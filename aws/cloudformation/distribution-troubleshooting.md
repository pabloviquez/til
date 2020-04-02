# Cloudformation Distribuition Troubleshooting

## The parameter CNAME contains one or more parameters that are not valid

This refers to ```Properties.DistributionConfig.Aliases```. The alias must be a valid *lowercase* domain.

## Exactly one of [AcmCertificateArn,CloudFrontDefaultCertificate,IamCertificateId] needs to be specified

WTF?! basically ony one in the section ```Properties.ViewerCertificate```

### INVALID
```
ViewerCertificate:
  CloudFrontDefaultCertificate: false
  AcmCertificateArn: !Ref SSLDomainARN
  MinimumProtocolVersion: TLSv1.2_2018
  SslSupportMethod: sni-only
```

**Remove** ```"CloudFrontDefaultCertificate```

### Example
```
ViewerCertificate:
  AcmCertificateArn: !Ref SSLDomainARN
  MinimumProtocolVersion: TLSv1.2_2018
  SslSupportMethod: sni-only
```

## Property validation failure: [Value of property {/DistributionConfig/Origins} does not match type {Array}, The property {/DistributionConfig/DefaultCacheBehavior/TargetOriginId} is required]

This one was hard to understand, but basically you need to create an ```AWS::CloudFront::CloudFrontOriginAccessIdentity```, so I created an origin identity and used it on my distribuition template:
```
# -- Identity resource
CloudFrontOAI:
  Type: AWS::CloudFront::CloudFrontOriginAccessIdentity
  Properties:
    CloudFrontOriginAccessIdentityConfig:
      Comment: DistributionConfig for CloudFront
```

Then referenced:
```
CloudFrontDistribuition:
  Type: AWS::CloudFront::Distribution
  Properties:
    DistributionConfig:
      Origins:
        - DomainName: !GetAtt S3Bucket.DomainName
          Id: !Ref S3Bucket
          S3OriginConfig:
            OriginAccessIdentity: !Sub "origin-access-identity/cloudfront/${CloudFrontOAI}"

...

```

# Example. CloudFront distribuition with S3 as source and modified Route53 entries

```
AWSTemplateFormatVersion: '2010-09-09'
Description: "PabloViquez - CloudFront distribution, S3 as source"

Parameters:
  HostedZoneId:
    Description: The ID of the hosted zone that you want to create the record in.
    Type: 'AWS::Route53::HostedZone::Id'
  SSLDomainARN:
    Type: String
    Description: AWS Certificate Manager domain ARN
  SubDomainName:
    Description: Alphanumeric, lowercase and hyphen only. Prepended to the domain, as follow SubDomainName.domain.com
    Type: String
    Default: web
    MinLength: 2
    MaxLength: 10
    AllowedPattern: "[a-z0-9-]*"
  BucketName:
    Description: S3 unique bucket name
    Type: String
    MinLength: 2
    MaxLength: 32
    AllowedPattern: "[a-zA-Z_0-9-]*"

Metadata:
  AWS::CloudFormation::Interface:
    ParameterGroups:
      - Label:
          default: "S3 Bucket Settings"
        Parameters:
          - BucketName

      - Label:
          default: "Network Settings"
        Parameters:
          - HostedZoneId
          - SubDomainName
          - SSLDomainARN

    ParameterLabels:
      BucketName:
        default: "S3 Bucket Name"
      HostedZoneId:
        default: Public Host Zone ID
      SubDomainName:
        default: Private Sub-Domain
      SSLDomainARN:
        default: Private Sub-Domain SSL ARN

Resources:
# -----
# -- S3 Bucket
# -----
  S3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      AccessControl: PublicRead
      BucketEncryption: 
        ServerSideEncryptionConfiguration:
          - ServerSideEncryptionByDefault:
              SSEAlgorithm: AES256
      BucketName: !Ref BucketName
      PublicAccessBlockConfiguration:
        BlockPublicAcls: false
        BlockPublicPolicy: false
        IgnorePublicAcls: false
        RestrictPublicBuckets: false

# -----
# -- CloudFront Distribuition
# -----
  CloudFrontOAI:
    Type: AWS::CloudFront::CloudFrontOriginAccessIdentity
    Properties:
      CloudFrontOriginAccessIdentityConfig:
        Comment: !Sub "${AWS::StackName}"

# -----
# -- CloudFront Distribuition
# -----
  CloudFrontDistribuition:
    Type: AWS::CloudFront::Distribution
    Properties:
      DistributionConfig:
        Origins:
          - DomainName: !GetAtt S3Bucket.DomainName
            Id: !Ref S3Bucket
            S3OriginConfig:
              OriginAccessIdentity: !Sub "origin-access-identity/cloudfront/${CloudFrontOAI}"
        Enabled: True
        HttpVersion: http1.1
        IPV6Enabled: False
        Comment: !Sub "${AWS::StackName} Cloudformation setup"
        DefaultRootObject: index.html
        Aliases:
          - !Sub "${SubDomainName}.mydomain.com"
        DefaultCacheBehavior:
          TargetOriginId: !Ref S3Bucket
          Compress: false
          DefaultTTL: 86400
          MinTTL: 0
          MaxTTL: 31536000
          AllowedMethods:
            - GET
            - HEAD
          CachedMethods: 
            - GET
            - HEAD
          ForwardedValues:
            QueryString: true
            Cookies:
              Forward: none
          ViewerProtocolPolicy: redirect-to-https
        PriceClass: PriceClass_All
        ViewerCertificate:
          AcmCertificateArn: !Ref SSLDomainARN
          MinimumProtocolVersion: TLSv1.2_2018
          SslSupportMethod: sni-only
      Tags:
        - Key: Name
          Value: !Sub "${AWS::StackName}"
        - Key: CloudFormationStack
          Value: !Sub "${AWS::StackName}"
        - Key: Domain
          Value: !Sub "${SubDomainName}.mydomain.com"

# -----
# -- DNS Record
# -----
  PublicDNSRecord:
    Type: AWS::Route53::RecordSetGroup
    Properties:
      HostedZoneId: !Ref HostedZoneId
      Comment: !Sub "DNS entry for ${AWS::StackName}"
      RecordSets:
        - Name: !Sub "${SubDomainName}.mydomain.com"
          ResourceRecords:
            - !Sub "${SubDomainName}.mydomain.com."
          Type: CNAME
          TTL: '60'

Outputs:
  OutputWebAppS3Bucket:
    Description: S3 Web App Bucket
    Value: !Ref S3Bucket
  OutputS3BucketRegionalDomainName:
    Description: Returns the regional domain name of the specified bucket.
    Value: !GetAtt S3Bucket.RegionalDomainName
  OutputS3BucketDomainName:
    Description: Returns the IPv4 DNS name of the specified bucket.
    Value: !GetAtt S3Bucket.DomainName
  OutputS3BucketWebsiteURL:
    Description: Returns the Amazon S3 website endpoint for the specified bucket.
    Value: !GetAtt S3Bucket.WebsiteURL
  OutputCloudFrontDistribution:
    Description: Cloudfront distribution
    Value: !Sub "${SubDomainName}.mydomain.com"
  OutputCloudFrontOAI:
    Description: CloudFront OAI
    Value: !Ref CloudFrontOAI
  OutputCloudFrontDistribuitionRef:
    Description: CloudFrontDistribuition
    Value: !Ref CloudFrontDistribuition
```
