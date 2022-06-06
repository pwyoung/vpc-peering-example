# This is based on
https://github.com/terraform-aws-modules/terraform-aws-alb/blob/master/examples/complete-nlb/main.tf

# Keeping the NLB as its own module
Elastic IPs are not supported for load balancers with type 'application'

Per: https://stackoverflow.com/questions/55236806/how-to-assign-elastic-ip-to-application-load-balancer-in-aws

"An Application Load Balancer cannot be assigned an Elastic IP address (static IP address).

However, a Network Load Balancer can be assigned one Elastic IP address for each Availability Zone it uses.

If you do not wish to use a Network Load Balancer, you can combine the two by putting the Network Load Balancer in front of the Application Load Balancer:
"

CHA-CHING!
