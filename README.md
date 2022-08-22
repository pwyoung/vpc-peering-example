# Goal
This will:
- create two VPCs
- peer them
- add public and private EC2 instances
- add a Network-Load-Balancer to one VPC and attach the public instances in that VPC to it

# Notes

This demonstrates a traditional file layout where the physical resources being
deployed are mirrored in the folder structure in this code.
This is not DRY.
BUT, it is VERY flexible.
And, it allows you to see almost everything with just a 'tree' command.

