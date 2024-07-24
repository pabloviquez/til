# Jmeter Master Slave Configuration in AWS

## Context & Setup
 |
This "how to" is based on the [Jmeter Master Slave Configuration](jmeter-master-slave-configs.md) with a few differences:

* 1x Server as Master
* 3x Servers as Slaves

All servers running Amazon Linux (Debian), on t3.xlarge machines with the  following specs:
* Enabled Public IP
* JMeter traffic permitted for all four machines.


## AWS AMI
At the moment of writting this doc, the latest AWS AMI available was ``Amazon Linux 2023 AMI 2023.5.20240708.0 x86_64 HVM kernel-6.1``

The AMI ID used is: ``ami-0649bea3443ede307``

For more information on AWS AMIs, go to: https://docs.aws.amazon.com/linux/

## AWS Cloud Formation Script

### Parameters To Replace
Param Name | Description
--- | ---
ParamVPCID | VPC ID to use.
ParamSubNetID1 | Subnet ID, will be assigned to master and slave 1.
ParamSubNetID2 | Subnet ID, will be assigned to slave 2.
ParamSubNetID3 | Subnet ID, will be assigned to slave 3
ParamAmiID | AMI Image ID
ParamInstanceType | Type of instance, this example has t3.xlarge
ParamEC2KeyName | PEM Name. Should be created before this Cloud Formation is executed.
ParamCreationDate | Date, normally with the format YYYYMMDD, for tagging pourpurses.
ParamEC2UserData | Script to execute when instances are created.

### Cloud Formation File

```
# Cloud Formation File
# Last update: 2024-07-24
#
# Update the parameters acordingly.

AWSTemplateFormatVersion: '2010-09-09'
Description: 'AWS CloudFormation load testing configuration.'

Parameters:
  ParamVPCID:
    Description: VPC ID to use.
    Type: String
    Default: <VPC ID HERE>
  ParamSubNetID1:
    Description: Subnet ID 1 to use.
    Type: String
    Default: <SUB NET 1 ID here, like subnet-1234567897123>
  ParamSubNetID2:
    Description: Subnet ID 2 to use.
    Type: String
    Default: <SUB NET 2 ID here, like subnet-1234567897123>
  ParamSubNetID3:
    Description: Subnet ID 3 to use.
    Type: String
    Default: <SUB NET 3 ID here, like subnet-1234567897123>
  ParamAmiID:
    Description: AMI ID to use.
    Type: String
    Default: ami-0649bea3443ede307
  ParamInstanceType:
    Description: Instance type to use.
    Type: String
    Default: t3.xlarge
  ParamEC2KeyName:
    Description: SSH PEM Keyname.
    Type: String
    Default: <PEM key name here>
  ParamCreationDate:
    Description: Creation date of the stack.
    Type: String
    Default: 20230724
  ParamEC2UserData:
    Description: EC2 user data.
    Type: String
    Default: |
          #!/bin/bash
          echo "Setting up the JMeter Node" > /var/log/lt-log.txt
          date >> /var/log/lt-log.txt
          sudo yum update
          sudo yum install nmap -y
          sudo yum install git -y
          sudo yum install java -y
          echo "" >> /var/log/lt-log.txt
          echo "Packages installed." >> /var/log/lt-log.txt
          cd /home/ec2-user
          echo "Downloading JMeter" >> /var/log/lt-log.txt
          echo "Location: $(pwd)"  >> /var/log/lt-log.txt
          wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.6.3.tgz
          echo "Download complete: $(ls -l)"  >> /var/log/lt-log.txt
          tar -xzvf apache-jmeter-5.6.3.tgz
          echo "Decompressing complete: $(ls -l)"  >> /var/log/lt-log.txt
          chown -R ec2-user:ec2-user apache-jmeter-5.6.3
          echo "Ownership changed: $(ls -l)"  >> /var/log/lt-log.txt
          rm apache-jmeter-5.6.3.tgz
          ln -s apache-jmeter-5.6.3 jmeter
          ls -l >> /var/log/lt-log.txt
          echo "Setting up bash profile" >> /var/log/lt-log.txt
          echo "#!/bin/bash" > /home/ec2-user/.bash_profile
          echo "" >> /home/ec2-user/.bash_profile
          echo "# LT Generated" >> /home/ec2-user/.bash_profile
          echo "if [ -f ~/.bashrc ]; then" >> /home/ec2-user/.bash_profile
          echo " . ~/.bashrc" >> /home/ec2-user/.bash_profile
          echo "fi" >> /home/ec2-user/.bash_profile
          echo "" >> /home/ec2-user/.bash_profile
          cd jmeter
          echo "export JMETER_HOME=\"$(pwd)\"" >> /home/ec2-user/.bash_profile
          echo "export PATH=\"${PATH}:${JMETER_HOME}/bin\"" >> ~/.bash_profile
          echo "alias INIT_SERVER=\"clear && cd ~/loadtest/ && bash ${JMETER_HOME}/bin/jmeter-server\"" >> ~/.bash_profile
Resources:
  LoadTestSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupName: LoadTestSecurityGroup
      GroupDescription: Security Group for load testing using JMeter.
      VpcId: !Ref ParamVPCID
      Tags:
        - Key: Name
          Value: SG-LoadTest-JMeter
        - Key: CREATED
          Value: !Ref ParamCreationDate

  IngressRuleJmeter:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      Description: Allow inbound traffic from the load test security group.
      GroupId: !GetAtt LoadTestSecurityGroup.GroupId
      IpProtocol: tcp
      FromPort: 1099
      ToPort: 1099
      SourceSecurityGroupId: !GetAtt LoadTestSecurityGroup.GroupId
  IngressRuleSSHHome:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      Description: Allow SSH inbound traffic for specific IP.
      GroupId: !GetAtt LoadTestSecurityGroup.GroupId
      IpProtocol: tcp
      FromPort: 22
      ToPort: 22
      CidrIp: MY PUBLIC IP ADDRESS/32

  LTMaster:
    Type: 'AWS::EC2::Instance'
    Properties:
      InstanceType: !Ref ParamInstanceType
      ImageId: !Ref ParamAmiID
      SubnetId: !Ref ParamSubNetID1
      KeyName: !Ref ParamEC2KeyName
      SecurityGroupIds:
        - !GetAtt LoadTestSecurityGroup.GroupId
      Tags:
        - Key: Name
          Value: LT-Master
        - Key: CREATED
          Value: !Ref ParamCreationDate
      UserData:
        Fn::Base64: !Ref ParamEC2UserData

  LTSlave1:
    Type: 'AWS::EC2::Instance'
    Properties:
      InstanceType: !Ref ParamInstanceType
      ImageId: !Ref ParamAmiID
      SubnetId: !Ref ParamSubNetID1
      KeyName: !Ref ParamEC2KeyName
      SecurityGroupIds:
        - !GetAtt LoadTestSecurityGroup.GroupId
      Tags:
        - Key: Name
          Value: LT-Slave1
        - Key: CREATED
          Value: !Ref ParamCreationDate
      UserData:
        Fn::Base64: !Ref ParamEC2UserData

  LTSlave2:
    Type: 'AWS::EC2::Instance'
    Properties:
      InstanceType: !Ref ParamInstanceType
      ImageId: !Ref ParamAmiID
      SubnetId: !Ref ParamSubNetID2
      KeyName: !Ref ParamEC2KeyName
      SecurityGroupIds:
        - !GetAtt LoadTestSecurityGroup.GroupId
      Tags:
        - Key: Name
          Value: LT-Slave2
        - Key: CREATED
          Value: !Ref ParamCreationDate
      UserData:
        Fn::Base64: !Ref ParamEC2UserData

  LTSlave3:
    Type: 'AWS::EC2::Instance'
    Properties:
      InstanceType: !Ref ParamInstanceType
      ImageId: !Ref ParamAmiID
      SubnetId: !Ref ParamSubNetID3
      KeyName: !Ref ParamEC2KeyName
      SecurityGroupIds:
        - !GetAtt LoadTestSecurityGroup.GroupId
      Tags:
        - Key: Name
          Value: LT-Slave3
        - Key: CREATED
          Value: !Ref ParamCreationDate
      UserData:
        Fn::Base64: !Ref ParamEC2UserData

```

