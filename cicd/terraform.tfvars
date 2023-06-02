#####################################################################################################
##############################    VPC     ###########################################################
#####################################################################################################
project_name           = "EV"
env_name               = "CICD"
vpc_name               = "EV-CICD-VPC"
vpc_cidr_block         = "172.12.11.0/24"
avaliable_zones        = ["ap-northeast-2a", "ap-northeast-2c"]
public_network_address = ["172.12.11.0/26", "172.12.11.64/26"]
public_network_logic   = ["PUB", "PUB"]


private_network_address = ["172.12.11.128/26", "172.12.11.192/26"]
private_network_logic   = ["PRI", "PRI"]


using_nat         = true
nat_gateway_count = 2
nat_gateway_cidr  = "0.0.0.0/0"

using_transit = true
###########################################################################
/* 
prd_cicd_env_name               = "CICD"
prd_cicd_vpc_name               = "EV-CICD-VPC"
prd_cicd_vpc_cidr_block         = "172.12.11.0/24"
avaliable_zones        = ["ap-northeast-2a", "ap-northeast-2c"]
public_network_address = ["172.12.11.0/26", "172.12.11.64/26"]
public_network_logic   = ["PUB", "PUB"]


private_network_address = ["172.12.11.128/26", "172.12.11.192/26"]
private_network_logic   = ["PRI", "PRI"]


using_nat         = true
nat_gateway_count = 2
nat_gateway_cidr  = "0.0.0.0/0"

using_transit = true */


###################################################################################################################
#bastion
###################################################################################################################


create_key              = true
key_name                = "EV-CICD-BASTION-KEY"
create_instance_profile = true
instance_profile_name   = "EV-CICD-BASTION-PROFILE"

attach_policy_arn     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
specific_instance_ami = false


instance_name = "EV-CICD-BASTION"
instance_type = "t3.small"
subnet_logic  = "PUB"
using_eip     = true
root_block_device = [
  {
    encrypted   = false
    volume_type = "gp3"
    throughput  = 200
  volume_size = 100 }
]
instance_add_tags = {
  "AutoSchedule" = "Y",
  "AutoBackup"   = "Y"
}



###################################################################################################################
#jenkins
###################################################################################################################


jenkins_create_key              = true
jenkins_key_name                = "EV-CICD-DEV-JENKINS-KEY"
jenkins_create_instance_profile = true
jenkins_instance_profile_name   = "EV-CICD--DEV-JENKINS-PROFILE"

jenkins_attach_policy_arn     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
jenkins_specific_instance_ami = true


jenkins_instance_name = "EV-CICD-DEV-JENKINS"
jenkins_instance_type = "r6i.large"
jenkins_subnet_logic  = "PRI"
jenkins_root_block_device = [
  {
    encrypted   = false
    volume_type = "gp3"
    throughput  = 200
  volume_size = 100 }
]
jenkins_instance_add_tags = {
  "AutoSchedule" = "Y",
  "AutoBackup"   = "Y"
}

stg_jenkins_create_key              = true
stg_jenkins_key_name                = "EV-CICD-STG-JENKINS-KEY"
stg_jenkins_create_instance_profile = true
stg_jenkins_instance_profile_name   = "EV-CICD-STG-JENKINS-PROFILE"
stg_jenkins_attach_policy_arn       = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
stg_jenkins_specific_instance_ami   = true

stg_jenkins_instance_name = "EV-CICD-STG-JENKINS"
stg_jenkins_instance_type = "r6i.large"
stg_jenkins_subnet_logic  = "PRI"
stg_jenkins_root_block_device = [
  {
    encrypted   = false
    volume_type = "gp3"
    throughput  = 200
  volume_size = 100 }
]

stg_jenkins_instance_add_tags = {
  "AutoSchedule" = "Y",
  "AutoBackup"   = "Y"
}

prd_jenkins_create_key              = true
prd_jenkins_key_name                = "EV-CICD-PRD-JENKINS-KEY"
prd_jenkins_create_instance_profile = true
prd_jenkins_instance_profile_name   = "EV-CICD-PRD-JENKINS-PROFILE"
prd_jenkins_attach_policy_arn       = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
prd_jenkins_specific_instance_ami   = true
prd_jenkins_instance_name           = "EV-CICD-PRD-JENKINS"
prd_jenkins_instance_type           = "r6i.large"
prd_jenkins_subnet_logic            = "PRI"
prd_jenkins_root_block_device = [
  {
    encrypted   = false
    volume_type = "gp3"
    throughput  = 200
  volume_size = 100 }
]

prd_jenkins_instance_add_tags = {
  "AutoSchedule" = "Y",
  "AutoBackup"   = "Y"
}

###################################################################################################################
#jenkins alb
###################################################################################################################
elb_logic = "JENKINS"
elb_name  = "EV-CICD-JENKINS-ALB"
elb_type  = "application"
internal  = false
http_tcp_listeners = [{
  port        = 80
  protocol    = "HTTP"
  action_type = "redirect"
  redirect = {
    port        = "443"
    protocol    = "HTTPS"
    status_code = "HTTP_301"
  }
}]

