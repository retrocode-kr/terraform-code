#####################################################################################################
##############################    VPC     ###########################################################
#####################################################################################################
project_name           = "EV"
env_name               = "DEV"
vpc_name               = "EV-DEV-VPC"
vpc_cidr_block         = "172.12.32.0/21"
avaliable_zones        = ["ap-northeast-2a", "ap-northeast-2c"]
public_network_address = ["172.12.32.0/26", "172.12.32.64/26"]
public_network_logic   = ["PUB", "PUB"]

eks_public_network_address = ["172.12.34.0/24", "172.12.35.0/24"]
eks_public_network_logic   = ["PUB-EKS", "PUB-EKS"]

private_network_address = ["172.12.33.0/25", "172.12.33.128/25"]
private_network_logic   = ["PRI", "PRI"]

eks_private_network_address = ["172.12.36.0/23", "172.12.38.0/23"]
eks_private_network_logic   = ["PRI-EKS", "PRI-EKS"]

db_network_address   = ["172.12.32.128/26", "172.12.32.192/26"]
db_network_logic     = ["DB", "DB"]
db_subnet_group_name = "dev-pri-db-subnet-group"

using_nat         = true
nat_gateway_count = 2
nat_gateway_cidr  = "0.0.0.0/0"

using_transit = true

###################################################################################################################
#bastion
###################################################################################################################

ecr_endpoint_sg_name = "EV-DEV-ECR-ENDPOINT-SG"


###################################################################################################################
#bastion
###################################################################################################################


create_key              = true
key_name                = "EV-DEV-BASTION-KEY"
create_instance_profile = true
instance_profile_name   = "EV-DEV-BASTION-PROFILE"

specific_instance_ami = false

instance_name = "EV-DEV-BASTION"
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
#DB
###################################################################################################################
rds_type        = "aurora"
db_cluster_name = "EV-DEV-DB"
engine          = "aurora-postgresql"
engine_version  = "15.2"
instance_class  = "db.r6i.large"
db_name         = "ev_dev_database"
db_instances = {
  0 = {}
  }
iam_database_authentication_enabled = true
skip_final_snapshot                 = true
username                            = "postgres"
password                            = "!3202vesg!"
backup_retention_period             = 7
backup_window                       = "02:00-03:00"
enabled_cloudwatch_logs_exports     = ["postgresql"]
port                                = 5432
db_add_tags = {
  "AutoSchedule" = "Y"
}

create_db_cluster_parameter_group      = true
db_cluster_parameter_group_name        = "ev-dev-db-cluster-parameter-group"
db_cluster_parameter_group_family      = "aurora-postgresql15"
db_cluster_parameter_group_description = "DB CLUSTER PARAMETER GROUP FOR EV-DEV"
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
db_parameter_group_name        = "ev-dev-db-instance-parameter-group"
db_parameter_group_family      = "aurora-postgresql15"
db_parameter_group_description = "DB INSTANCE PARAMETER GROUP FOR EV-DEV"
db_parameter_group_parameters = [{
  name         = "log_statement"
  value        = "all"
  apply_method = "immediate"
  }, {
  name  = "rds.log_retention_period"
  value = "10080"
  }
]


###################################################################################################################
# DEV EKS
###################################################################################################################

cluster_name    = "EV-DEV-EKS-v1-26"
cluster_version = "1.26"
cluster_tags = {
  "AutoSchedule" = "Y"
}

