# How to enable Elastic Network Adapter (ENA) on existing instances

First than all, ENA is great,

> **Elastic Network Adapter**
> I hope that you have configured your AMIs and your current-generation EC2 instances
> to use the Elastic Network Adapter (ENA) that I told you about back in mid-2016.
> The ENA gives you high throughput and low latency, while minimizing the load on
> the host processor. It is designed to work well in the presence of multiple vCPUs,
> with intelligent packet routing backed up by multiple transmit and receive queues.
[The Floodgates Are Open – Increased Network Bandwidth for EC2 Instances](https://aws.amazon.com/blogs/aws/the-floodgates-are-open-increased-network-bandwidth-for-ec2-instances/)


# Steps
1. Install ENA on your instance
1. Verify ENA is set and enabled
1. Create a new AMI image out of instance
1. Update the newly created image to support ENA

# Install ENA on your instance

```bash
sudo apt-get update
sudo apt-get upgrade -y linux-aws
```


# Verify ENA is enabled

Run modinfo ena:

```bash
$ modinfo ena
filename:       /lib/modules/4.4.0-1067-aws/kernel/drivers/net/ethernet/amazon/ena/ena.ko
version:        1.5.0K
license:        GPL
description:    Elastic Network Adapter (ENA)
author:         Amazon.com, Inc. or its affiliates
srcversion:     6E5FBB020357E652D938AD9
alias:          pci:v00001D0Fd0000EC21sv*sd*bc*sc*i*
alias:          pci:v00001D0Fd0000EC20sv*sd*bc*sc*i*
alias:          pci:v00001D0Fd00001EC2sv*sd*bc*sc*i*
alias:          pci:v00001D0Fd00000EC2sv*sd*bc*sc*i*
depends:
retpoline:      Y
intree:         Y
vermagic:       4.4.0-1067-aws SMP mod_unload modversions retpoline
parm:           debug:Debug level (0=none,...,16=all) (int)
```

IF ENA is not  installed, you will see something like:
```bash
$ modinfo ena
ERROR: modinfo: could not find module ena
```

## Create a new AMI image out of instance

This one using AWS CLI:
```bash
aws ec2 create-image \
  --description "my description here" \
  --name "my ami image name" \
  --instance-id INSTANCE_ID_HERE \
  --reboot
```

## Update the newly created image to support ENA
Once the image is created you need to update the image attribute for ENA support:

```bash
aws ec2 modify-instance-attribute \
   --instance-id AMI_IMAGE_ID_FROM_PREVIOUS_STEP \
   --ena-support
```

**DONE!**