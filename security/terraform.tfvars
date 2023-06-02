#####################################################################################################
##############################    VPC     ###########################################################
#####################################################################################################
project_name            = "EV"
env_name                = "SEC"
vpc_name                = "EV-SEC-VPC"
vpc_cidr_block          = "172.12.10.0/24"
avaliable_zones         = ["ap-northeast-2a", "ap-northeast-2c"]
public_network_address  = ["172.12.10.0/26", "172.12.10.64/26"]
public_network_logic    = ["PUB", "PUB"]
private_network_address = ["172.12.10.128/26", "172.12.10.192/26"]
private_network_logic   = ["PRI", "PRI"]
using_nat               = true
nat_gateway_count       = 2
nat_gateway_cidr        = "0.0.0.0/0"
using_public_transit    = true
using_transit           = true



###################################################################################################################
#bastion
###################################################################################################################


create_key              = true
key_name                = "EV-SEC-BASTION-KEY"
create_instance_profile = true
instance_profile_name   = "EV-SEC-BASTION-PROFILE"

attach_policy_arn     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
specific_instance_ami = false


instance_name = "EV-SEC-BASTION"
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
  "AutoSchedule" = "Y"
}




###################################################################################################################
# cpp server -amazon linux2
###################################################################################################################


cpp_create_key              = true
cpp_key_name                = "EV-SEC-CPP-KEY"
cpp_create_instance_profile = true
cpp_instance_profile_name   = "EV-SEC-CPP-PROFILE"

cpp_attach_policy_arn     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
cpp_specific_instance_ami = true
cpp_instance_ami          = "ami-03db74b70e1da9c56"

cpp_instance_name = "EV-SEC-CPP"
cpp_instance_type = "t3.large"
cpp_subnet_logic  = "PUB"
cpp_using_eip     = true
cpp_root_block_device = [
  {
    encrypted   = false
    volume_type = "gp3"
    throughput  = 200
  volume_size = 100 }
]
cpp_instance_add_tags = {
  "AutoSchedule" = "Y"
}

###################################################################################################################
# agent server - window os
###################################################################################################################


window_create_key              = true
window_key_name                = "EV-AGENT-SEVER-KEY"
window_create_instance_profile = true
window_instance_profile_name   = "EV-SEC-WINDOW-PROFILE"

window_attach_policy_arn     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
window_specific_instance_ami = true
window_instance_ami          = "ami-08faf5d73df49da41"
window_instance_name         = "EV-SEC-AGENT-WINDOW"
window_instance_type         = "t3.medium"
window_subnet_logic          = "PRI"
window_using_eip             = false
window_root_block_device = [
  {
    encrypted   = false
    volume_type = "gp3"
    throughput  = 200
  volume_size = 100 }
]
window_instance_add_tags = {
  "AutoSchedule" = "Y"
}


###################################################################################################################
# agent server - amazon linux2
###################################################################################################################


alinux_create_key              = true
alinux_key_name                = "EV-AGENT-SEVER-KEY"
alinux_create_instance_profile = true
alinux_instance_profile_name   = "EV-SEC-LINUX-PROFILE"
alinux_attach_policy_arn       = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
alinux_specific_instance_ami   = true
alinux_instance_ami            = "ami-03db74b70e1da9c56"
alinux_instance_name           = "EV-SEC-AGENT-LINUX"
alinux_instance_type           = "t3.medium"
alinux_subnet_logic            = "PRI"
alinux_using_eip               = false
alinux_root_block_device = [
  {
    encrypted   = false
    volume_type = "gp3"
    throughput  = 200
  volume_size = 100 }
]
alinux_instance_add_tags = {
  "AutoSchedule" = "Y"
}
