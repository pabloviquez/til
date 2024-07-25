# Jmeter Master Slave Configuration in AWS

## Summary
This is a CloudFormation Recipe to setup a JMeter load test environment. It's based on the configuration described here: [Jmeter Master Slave Configuration](jmeter-master-slave-configs.md) with a few differences.

The Cloud Formation script creates the following resorces:

* 1x VPC
* 4x EC2 Instances
* 1x Internet Gateway
* 1x Route table
* 2x Security Groups (Default VPC and EC2 security group).
* Traffic restrictions for the EC2 instances to communicate with each other.

## VPC & Subnets
The reason why I'm using a custom VPC is because the AWS default  is too big, each subnet supports `4091` hosts, and when I run a host scanner takes too much time.

The Load Test VPC created has the following specs:
* **IPv4 CIDR** `192.168.0.0/26`
* **Public IP** `Enabled`
* **Zone** `us-east-2`
* **Subnets** `3`
* **DNS hostname resolution** `Enabled`
* **DNS resolution** `Enabled`

### Subnets
The subnet information goes as follow:

Subnet name | IPv4CIDR | Max Hosts | Availability Zone | Start IP | End IP |
--- | --- | --- | --- | --- | ---
`Zone2A-LT-1` | `192.168.0.0/28` | `11` | `us-east-2a` | `192.168.0.1` | `192.168.0.15`
`Zone2B-LT-2` | `192.168.0.16/28` | `11` | `us-east-2a` | `192.168.0.17` | `192.168.0.31`
`Zone2C-LT-3` | `192.168.0.32/28` | `11` | `us-east-2a` | `192.168.0.33` | `192.168.0.47`


## Security Group Configuration
The following rules are created:

Rule Name | Port | Protocol | Source | Destination | Action
--- | --- | --- | --- | --- | ---
IngressRuleJmeter | `1099` | `tcp` | *SecurityGroup* | *SecurityGroup* | `Allow`
IngressRuleJmeterStop | `4445` | `tcp` | *SecurityGroup* | *SecurityGroup* | `Allow`
IngressNmapScan80 | `80` | `tcp` | *SuSecurityGroupbNet* | *SecurityGroup* | `Allow`
IngressNmapScan443 | `443` | `tcp` | *SecurityGroup* | *SecurityGroup* | `Allow`
IngressNmapScanIcmp | `all` | `ICMP` | *SecurityGroup* | *SecurityGroup* | `Allow`
IngressSSHInternal | `22` | `tcp` | *SecurityGroup* | *SecurityGroup* | `Allow`
IngressSSHExternal | `22` | `tcp` | `ParamExternalIP` | *SecurityGroup* | `Allow`
OutTraffic (Default) | `1024-65536` | `tcp` | *SecurityGroup* | *SecurityGroup* | `Allow`

### Note - NMap
To discover the host in the subnet, `nmap` no port scan is used `nmap -sn`.
This command discovers hosts by sending an ICMP echo request, TCP SYN to port 443, TCP ACK to port 80, and an ICMP timestamp request by default.

For the sake of simplicity, all ICMP traffic is allowed.

### Note - IngressSSHInternal
The rule uses a parameter that needs to be replace by the external IP allowed to access the servers.


## AWS AMI

At the moment of writting this doc (2024-07-25), the latest AWS AMI available was ``Amazon Linux 2023 AMI 2023.5.20240708.0 x86_64 HVM kernel-6.1``

The AMI ID used is: ``ami-0649bea3443ede307``

For more information on AWS AMIs, go to: https://docs.aws.amazon.com/linux/

## AWS Cloud Formation Script

### Parameters To Replace
Param Name | Description | Default Value
--- | --- | ---
ParamExternalIP | External public IP address use to connect to the servers. | `8.8.8.8/32`
ParamAmiID | AMI Image ID | `ami-0649bea3443ede307`
ParamInstanceType | Type of instance | `t3.xlarge`
ParamEC2KeyName | PEM Name. Should be created before this Cloud Formation is executed. | `No value provided`
ParamCreationDate | Date, normally with the format YYYYMMDD, for tagging pourpurses. | `20240525`
ParamEC2UserData | Script to execute when instances are created. | `Steps to download and install Jmeter in each machine`

### Cloud Formation File

```
# Cloud Formation File
# Last update: 2024-07-25
#
# Update the parameters acordingly.

AWSTemplateFormatVersion: '2010-09-09'
Description: 'AWS CloudFormation load testing configuration.'

Parameters:
  ParamExternalIP:
    Description: External public IP address use to connect to the servers.
    Type: String
    Default: 8.8.8.8/32
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
    Default: 20230725
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
  LoadTestVPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 192.168.0.0/26
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
      - Key: Name
        Value: VPC-LoadTest
      - Key: CREATED
        Value: !Ref ParamCreationDate

  LoadTestSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref LoadTestVPC
      CidrBlock: 192.168.0.0/28
      AvailabilityZone: "us-east-2a"
      MapPublicIpOnLaunch: true
      PrivateDnsNameOptionsOnLaunch:
        EnableResourceNameDnsAAAARecord: false
        EnableResourceNameDnsARecord: false
        HostnameType: ip-name
      Tags:
      - Key: Name
        Value: Zone2A-LT-1
      - Key: CREATED
        Value: !Ref ParamCreationDate
  LoadTestSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref LoadTestVPC
      CidrBlock: 192.168.0.16/28
      AvailabilityZone: "us-east-2b"
      MapPublicIpOnLaunch: true
      PrivateDnsNameOptionsOnLaunch:
        EnableResourceNameDnsAAAARecord: false
        EnableResourceNameDnsARecord: false
        HostnameType: ip-name
      Tags:
      - Key: Name
        Value: Zone2B-LT-2
      - Key: CREATED
        Value: !Ref ParamCreationDate
  LoadTestSubnet3:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref LoadTestVPC
      CidrBlock: 192.168.0.32/28
      AvailabilityZone: "us-east-2c"
      MapPublicIpOnLaunch: true
      PrivateDnsNameOptionsOnLaunch:
        EnableResourceNameDnsAAAARecord: false
        EnableResourceNameDnsARecord: false
        HostnameType: ip-name
      Tags:
      - Key: Name
        Value: Zone2C-LT-3
      - Key: CREATED
        Value: !Ref ParamCreationDate

  LTRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref LoadTestVPC
      Tags:
      - Key: Name
        Value: LT-JMeter-RouteTable
      - Key: CREATED
        Value: !Ref ParamCreationDate
  RouteSubnetA:
      Type: AWS::EC2::SubnetRouteTableAssociation
      Properties:
        SubnetId: !Ref LoadTestSubnet1
        RouteTableId: !Ref LTRouteTable
  RouteSubnetB:
      Type: AWS::EC2::SubnetRouteTableAssociation
      Properties:
        SubnetId: !Ref LoadTestSubnet2
        RouteTableId: !Ref LTRouteTable
  RouteSubnetC:
      Type: AWS::EC2::SubnetRouteTableAssociation
      Properties:
        SubnetId: !Ref LoadTestSubnet3
        RouteTableId: !Ref LTRouteTable

  LoadTestInternetGateway:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
      - Key: Name
        Value: LoadTest-IG
      - Key: CREATED
        Value: !Ref ParamCreationDate
  LoadTestVPCGatewayAttachment:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref LoadTestVPC
      InternetGatewayId: !Ref LoadTestInternetGateway
  LTInternetRoute:
    Type: AWS::EC2::Route
    Properties:
      RouteTableId: !Ref LTRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref LoadTestInternetGateway


  LoadTestSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupName: LoadTestSecurityGroup
      GroupDescription: Security Group for load testing using JMeter.
      VpcId: !Ref LoadTestVPC
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
  IngressRuleJmeterStop:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      Description: Allow inbound traffic from the load test security group.
      GroupId: !GetAtt LoadTestSecurityGroup.GroupId
      IpProtocol: tcp
      FromPort: 4445
      ToPort: 4445
      SourceSecurityGroupId: !GetAtt LoadTestSecurityGroup.GroupId
  IngressNmapScan80:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      Description: Nmap no port scan sends TCP ACK to port 80
      GroupId: !GetAtt LoadTestSecurityGroup.GroupId
      IpProtocol: tcp
      FromPort: 80
      ToPort: 80
      SourceSecurityGroupId: !GetAtt LoadTestSecurityGroup.GroupId
  IngressNmapScan443:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      Description: Nmap no port scan sends TCP SYN to port 443
      GroupId: !GetAtt LoadTestSecurityGroup.GroupId
      IpProtocol: tcp
      FromPort: 443
      ToPort: 443
      SourceSecurityGroupId: !GetAtt LoadTestSecurityGroup.GroupId
  IngressNmapScanIcmp:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      Description: Nmap no port scan sends ICMP echo request and timestamp request. Allowing all for simplicity.
      GroupId: !GetAtt LoadTestSecurityGroup.GroupId
      IpProtocol: icmp
      FromPort: -1
      ToPort: -1
      SourceSecurityGroupId: !GetAtt LoadTestSecurityGroup.GroupId
  IngressSSHInternal:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      Description: SSH protocol between hosts.
      GroupId: !GetAtt LoadTestSecurityGroup.GroupId
      IpProtocol: tpc
      FromPort: 22
      ToPort: 22
      SourceSecurityGroupId: !GetAtt LoadTestSecurityGroup.GroupId
  IngressSSHExternal:
    Type: 'AWS::EC2::SecurityGroupIngress'
    Properties:
      Description: Allow SSH inbound traffic for an outside IP.
      GroupId: !GetAtt LoadTestSecurityGroup.GroupId
      IpProtocol: tpc
      FromPort: 22
      ToPort: 22
      CidrIp: !Ref ParamExternalIP

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

