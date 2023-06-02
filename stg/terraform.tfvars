#####################################################################################################
##############################    VPC     ###########################################################
#####################################################################################################
project_name           = "EV"
env_name               = "STG"
vpc_name               = "EV-STG-VPC"
vpc_cidr_block         = "172.12.40.0/21"
avaliable_zones        = ["ap-northeast-2a", "ap-northeast-2c"]
public_network_address = ["172.12.40.0/26", "172.12.40.64/26"]
public_network_logic   = ["PUB", "PUB"]

eks_public_network_address = ["172.12.42.0/24", "172.12.43.0/24"]
eks_public_network_logic   = ["PUB-EKS", "PUB-EKS"]

private_network_address = ["172.12.41.0/25", "172.12.41.128/25"]
private_network_logic   = ["PRI", "PRI"]

eks_private_network_address = ["172.12.44.0/23", "172.12.46.0/23"]
eks_private_network_logic   = ["PRI-EKS", "PRI-EKS"]

db_network_address   = ["172.12.40.128/26", "172.12.40.192/26"]
db_network_logic     = ["DB", "DB"]
db_subnet_group_name = "stg-pri-db-subnet-group"

using_nat         = true
nat_gateway_count = 2
nat_gateway_cidr  = "0.0.0.0/0"

using_transit = true


###################################################################################################################
#bastion
###################################################################################################################


create_key              = true
key_name                = "EV-STG-BASTION-KEY"
create_instance_profile = true
instance_profile_name   = "EV-STG-BASTION-PROFILE"

specific_instance_ami = false

instance_name = "EV-STG-BASTION"
instance_type = "t3.small"
#subnet_logic  = "PUB"
using_eip = true
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

##################################################################################################################
#private bastion
###################################################################################################################
pri_bastion_create_key              = true
pri_bastion_key_name                = "EV-STG-PRI-BASTION-KEY"
pri_bastion_create_instance_profile = true
pri_bastion_instance_profile_name   = "EV-STG-PRI-BASTION-PROFILE"
pri_bastion_using_eip               = false
pri_bastion_specific_instance_ami   = true
pri_bastion_instance_type           = "t3.small"
pri_bastion_instance_name           = "EV-STG-PRI-BASTION"

pri_bastion_root_block_device = [
  {
    encrypted   = false
    volume_type = "gp3"
    throughput  = 200
  volume_size = 100 }
]
pri_bastion_instance_add_tags = {
  "AutoSchedule" = "Y",
  "AutoBackup"   = "Y"
}



###################################################################################################################
#DB
###################################################################################################################
rds_type        = "aurora"
db_cluster_name = "EV-STG-DB"
engine          = "aurora-postgresql"
engine_version  = "15.2"
instance_class  = "db.r6i.large"
db_name         = "ev_stg_database"
db_instances = {
  0 = {},
  1 = {}
}
iam_database_authentication_enabled = true
skip_final_snapshot                 = true
username                            = "postgres"
backup_retention_period             = 7
backup_window                       = "02:00-03:00"
enabled_cloudwatch_logs_exports     = ["postgresql"]
port                                = 5432
db_add_tags = {
  "AutoSchedule" = "Y"
}

create_db_cluster_parameter_group      = true
db_cluster_parameter_group_name        = "ev-stg-db-cluster-parameter-group"
db_cluster_parameter_group_family      = "aurora-postgresql15"
db_cluster_parameter_group_description = "DB CLUSTER PARAMETER GROUP FOR EV-STG"
db_cluster_parameter_group_parameters = [{
  name         = "log_statement"
  value        = "all"
  apply_method = "immediate"
  }, {
  name  = "rds.log_retention_period"
  value = "10080"
  }
]
create_db_parameter_group      = true
db_parameter_group_name        = "ev-stg-db-instance-parameter-group"
db_parameter_group_family      = "aurora-postgresql15"
db_parameter_group_description = "DB INSTANCE PARAMETER GROUP FOR EV-STG"
db_parameter_group_parameters = [{
  name         = "log_statement"
  value        = "all"
  apply_method = "immediate"
  }, {
  name  = "rds.log_retention_period"
  value = "10080"
  }
]
