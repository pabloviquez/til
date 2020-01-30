# CloudFormation - Latest available AMI, keys and type

This template will display a list of instance types, available server keys and use the last available Amazon Linux AMI.


{code}
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Latest AMI for region'

Parameters:
  LatestAmiId:
    Description: Latest Amazon Linux Image
    Type: 'AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>'
    Default: '/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2'
  InstanceType:
    Description: t3.nano
    Type: String
    Default: t3.nano
    AllowedValues:
      - t3a.nano
      - t3a.micro
      - t3a.small
      - t3a.medium
      - t3a.large
      - t3a.xlarge
      - t3a.2xlarge
      - t3.nano
      - t3.micro
      - t3.small
      - t3.medium
      - t3.large
      - t3.xlarge
      - t3.2xlarge
      - t2.nano
      - t2.micro
      - t2.small
      - t2.medium
      - t2.large
      - t2.xlarge
      - t2.2xlarge
  KeyName:
    Description: Name of an existing EC2 KeyPair
    Type: 'AWS::EC2::KeyPair::KeyName'
    ConstraintDescription: Must be the name of an existing EC2 KeyPair.
  
Metadata:
  AWS::CloudFormation::Interface:
    ParameterGroups:
      - Label:
          default: "Server Settings"
        Parameters:
            - LatestAmiId
            - InstanceType
            - KeyName
    ParameterLabels:
      LatestAmiId:
        default: Latest Amazon Linux Image
      InstanceType:
        default: Type of instance to launch
      KeyName:
        default: Server PEM key

Resources:
  Server:
    Type: 'AWS::EC2::Instance'
    Properties:
      ImageId: !Ref LatestAmiId
      InstanceType: !Ref InstanceType
      KeyName:
        Ref: KeyName

      ...
{code}