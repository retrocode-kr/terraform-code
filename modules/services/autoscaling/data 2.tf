

data "aws_subnets" "adopt_instance" {

  filter {
    name = "availability-zone"
    #values = ["${element(var.avaliable_zones[*], count.index)}"]
    values = var.avaliable_zones
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    "Logic" = var.instance_logic
  }
}

