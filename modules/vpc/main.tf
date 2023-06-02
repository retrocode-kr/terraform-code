

locals {
  # 프로젝트 이름과 환경 이름을 조합하여 VPC내 리소스 이름을 생성합니다.(프로젝트 이름 없을시 환경만 표시)
  project_name_and_env_name = var.project_name != null ? "${var.project_name}-${var.env_name}" : "${var.env_name}"
  # private 서브넷에 붙일 transit gatewway를 정의합니다.
  private_transit_gateways = [
    for tgw in var.private_transit_gateways : tgw
    if var.using_transit && tgw.cidr != null && tgw.transit_gateway_id != null
  ]
  #public 서브넷에 붙일 transit gatewway를 정의합니다.
  public_transit_gateways = [
    for tgw in var.public_transit_gateways : tgw
    if var.using_public_transit && tgw.cidr != null && tgw.transit_gateway_id != null
  ]
}


#VPC 생성 및 태그
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = merge({
    Name = var.vpc_name,
    },
    var.vpc_tags,
    var.common_tags
  )
}

# 일반 public subnet 생성
resource "aws_subnet" "public" {
  count = try(length(var.public_network_address), 0)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_network_address[count.index]
  availability_zone = length(var.avaliable_zones) > 0 ? element(var.avaliable_zones, count.index) : null
  tags = merge({

    "Name"  = upper("${local.project_name_and_env_name}-${element(var.public_network_logic, count.index)}-SUB-${substr(element(var.avaliable_zones, count.index), -1, -1)}")
    "Logic" = element(var.public_network_logic, count.index)
    },
    var.common_tags,
    var.add_public_subnet_tags,

  )
}

# EKS용 public subnet 생성
resource "aws_subnet" "eks_public" {
  count                   = try(length(var.eks_public_network_address), 0)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.eks_public_network_address[count.index]
  availability_zone       = length(var.avaliable_zones) > 0 ? element(var.avaliable_zones, count.index) : null
  map_public_ip_on_launch = true
  tags = merge({
    "Name"  = upper("${local.project_name_and_env_name}-${element(var.eks_public_network_logic, count.index)}-SUB-${substr(element(var.avaliable_zones, count.index), -1, -1)}")
    "Logic" = element(var.eks_public_network_logic, count.index)
    },
    var.common_tags,
    { "kubernetes.io/role/elb" = 1 },
    var.add_eks_public_subnet_tags
  )
}

# 일반 private subnet 생성
resource "aws_subnet" "private" {
  count = try(length(var.private_network_address), 0)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_network_address[count.index]
  availability_zone = length(var.avaliable_zones) > 0 ? element(var.avaliable_zones, count.index) : null
  tags = merge({

    "Name"  = upper("${local.project_name_and_env_name}-${element(var.private_network_logic, count.index)}-SUB-${substr(element(var.avaliable_zones, count.index), -1, -1)}"),
    "Logic" = element(var.private_network_logic, count.index)
    },
    var.common_tags,
    var.add_private_subnet_tags,
  )
}

# EKS용 private subnet 생성
resource "aws_subnet" "eks_private" {
  count = try(length(var.eks_private_network_address), 0)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.eks_private_network_address[count.index]
  availability_zone = length(var.avaliable_zones) > 0 ? element(var.avaliable_zones, count.index) : null
  tags = merge({

    "Name"  = upper("${local.project_name_and_env_name}-${element(var.eks_private_network_logic, count.index)}-SUB-${substr(element(var.avaliable_zones, count.index), -1, -1)}"),
    "Logic" = element(var.eks_private_network_logic, count.index)
    },
    var.common_tags,
    { "kubernetes.io/role/internal-elb" = 1 },
    var.add_eks_private_subnet_tags
  )
}

# RDS용 private subnet 생성 (인터넷 게이트웨이가 없는 private subnet)
resource "aws_subnet" "database" {
  count = try(length(var.db_network_address), 0)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_network_address[count.index]
  availability_zone = length(var.avaliable_zones) > 0 ? element(var.avaliable_zones, count.index) : null
  tags = merge({
    "Name"  = upper("${local.project_name_and_env_name}-PRI-${element(var.db_network_logic, count.index)}-SUB-${substr(element(var.avaliable_zones, count.index), -1, -1)}"),
    "Logic" = element(var.db_network_logic, count.index)
    },
    var.common_tags
  )
}

# RDS 생성시 사용하는 subnet group 생성
resource "aws_db_subnet_group" "database" {
  count      = length(var.db_network_address) > 0 ? 1 : 0
  name       = lower(coalesce("${var.db_subnet_group_name}", "${local.project_name_and_env_name}-PRI-DB-SUBNET-GROUP"))
  subnet_ids = aws_subnet.database[*].id
  tags = merge({
    "Name" = coalesce("${var.db_subnet_group_name}", "${local.project_name_and_env_name}-PRI-DB-SUBNET-GROUP")
    },
    var.common_tags
  )
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge({
    "Name" = "${local.project_name_and_env_name}-IGW" },
    var.common_tags
  )
}

/*
# 만약 여러 public subnet(여러 가용 영역)에서 하나의 라우팅 테이블을 사용할 경우 해당 라우팅 테이블을 생성한다.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge({
    "Name" = "${local.project_name_and_env_name}-${var.public_network_logic[0]}-TABLE"
    },
    var.common_tags
  )
}
*/

#일반 public subnet에 대한 라우팅 테이블 생성, 하나의 서브넷에 하나의 라우팅 테이블이 생성된다.
resource "aws_route_table" "public" {
  count  = try(length(var.public_network_address), 0)
  vpc_id = aws_vpc.main.id
  tags = merge({
    "Name" = "${local.project_name_and_env_name}-${element(var.public_network_logic, count.index)}-TABLE-${upper(substr(element(var.avaliable_zones, count.index), -1, -1))}"
    },
    var.common_tags
  )
}

#EKS용 public subnet에 대한 라우팅 테이블 생성, 하나의 서브넷에 하나의 라우팅 테이블이 생성된다.
resource "aws_route_table" "eks_public" {
  #count  = length(var.eks_public_network_logic) > 0 ? try(var.using_nat ? var.nat_gateway_count : length(var.avaliable_zones)) : 0
  count  = try(length(var.eks_public_network_address), 0)
  vpc_id = aws_vpc.main.id
  tags = merge({
    "Name" = "${local.project_name_and_env_name}-${element(var.eks_public_network_logic, count.index)}-TABLE-${upper(substr(element(var.avaliable_zones, count.index), -1, -1))}"
    },
    var.common_tags
  )

}

# 인터넷 라우팅 (일반 퍼블릭 라우팅 테이블)
resource "aws_route" "public_internet_gateway" {
  count = length(aws_subnet.public)
  #라우팅 테일블 1개 쓸 경우 아래와 같이 사용한다.(아래 주석처리된 라인)
  #route_table_id         = aws_route_table.public.id

  # 가용영역별로 라우팅 테이블을 생성할 경우 아래와 같이 사용한다.
  route_table_id         = element(aws_route_table.public[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

}

# 인터넷 라우팅 (EKS 퍼블릭 라우팅 테이블)
resource "aws_route" "eks_public_internet_gateway" {
  count                  = length(aws_subnet.eks_public)
  route_table_id         = element(aws_route_table.eks_public[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

}

# 서브넷과 라우팅 테이블 연결(일반 퍼블릭 라우팅 테이블)
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = element(aws_route_table.public[*].id, count.index)
}

# 서브넷과 라우팅 테이블 연결(EKS 퍼블릭 라우팅 테이블)
resource "aws_route_table_association" "eks_public" {
  count          = length(aws_subnet.eks_public)
  subnet_id      = element(aws_subnet.eks_public[*].id, count.index)
  route_table_id = element(aws_route_table.eks_public[*].id, count.index)
}

# 퍼블릭 서브넷에서 transit gateway 연결 
resource "aws_route" "public_transit_gateway" {
  count = length(local.public_transit_gateways) * length(var.avaliable_zones)

  route_table_id         = aws_route_table.public[count.index % length(var.avaliable_zones)].id
  destination_cidr_block = local.public_transit_gateways[floor(count.index / length(var.avaliable_zones))].cidr
  transit_gateway_id     = local.public_transit_gateways[floor(count.index / length(var.avaliable_zones))].transit_gateway_id
}

# Nat Gateway 생성
resource "aws_nat_gateway" "this" {
  count = var.using_nat ? var.nat_gateway_count : 0

  allocation_id = element(aws_eip.nat[*].id, count.index)
  subnet_id = element(
    aws_subnet.public[*].id, count.index
  )
  tags = merge(
    {
      "Name" = upper(format(
        "${local.project_name_and_env_name}-NAT-%s",
        substr(element(var.avaliable_zones, count.index), -1, -1))

      )
    },
    var.common_tags,
  )
}

# Natgateway에 EIP 할당
resource "aws_eip" "nat" {
  count = var.using_nat ? var.nat_gateway_count : 0
  vpc   = true
  tags = merge({
    "Name" = "${local.project_name_and_env_name}-EIP"
    },
    var.common_tags
  )
}

# 일반 private subnet의 라우팅 테이블 생성
resource "aws_route_table" "private" {
  # 단일 nat gateway를 사용하면서 단일 라우팅테이블에 여러 private subenet을 연결할 경우 아래와 같이 사용한다.
  #count  = var.using_nat ? var.nat_gateway_count : length(var.avaliable_zones)

  count  = try(length(var.private_network_address), 0)
  vpc_id = aws_vpc.main.id
  tags = merge({
    "Name" = "${local.project_name_and_env_name}-${var.private_network_logic[0]}-TABLE-${upper(substr(element(var.avaliable_zones, count.index), -1, -1))}"
    },
    var.common_tags
  )
}

# EKS용 private subnet의 라우팅 테이블 생성
resource "aws_route_table" "eks_private" {
  # 단일 nat gateway를 사용하면서 단일 라우팅테이블에 여러 private subenet을 연결할 경우 아래와 같이 사용한다.
  #count  = length(var.eks_private_network_logic) > 0 ? try(var.using_nat ? var.nat_gateway_count : length(var.avaliable_zones)) : 0
  count  = try(length(var.eks_private_network_address), 0)
  vpc_id = aws_vpc.main.id
  tags = merge({
    "Name" = "${local.project_name_and_env_name}-${var.eks_private_network_logic[0]}-TABLE-${upper(substr(element(var.avaliable_zones, count.index), -1, -1))}"
    },
    var.common_tags
  )

}

# private subnet의 라우팅 테이블에 nat gateway 연결
resource "aws_route" "private_nat_gateway" {
  #count                  = var.using_nat ? var.nat_gateway_count : 0
  count                  = var.using_nat ? length(aws_subnet.private) : 0
  destination_cidr_block = var.nat_gateway_cidr
  route_table_id         = element(aws_route_table.private[*].id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)
}

# EKS용 private subnet의 라우팅 테이블에 nat gateway 연결
resource "aws_route" "eks_private_nat_gateway" {
  #count = var.using_nat && length(aws_subnet.eks_private) > 0 ? var.nat_gateway_count : 0
  #destination_cidr_block = "0.0.0.0/0"
  count                  = var.using_nat ? length(aws_subnet.eks_private) : 0
  destination_cidr_block = var.nat_gateway_cidr
  route_table_id         = element(aws_route_table.eks_private[*].id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)
}


# private subnet의 라우팅 테이블에 transit gateway 연결
resource "aws_route" "private_transit_gateway" {
  count = length(local.private_transit_gateways) * length(var.avaliable_zones)

  route_table_id         = aws_route_table.private[count.index % length(var.avaliable_zones)].id
  destination_cidr_block = local.private_transit_gateways[floor(count.index / length(var.avaliable_zones))].cidr
  transit_gateway_id     = local.private_transit_gateways[floor(count.index / length(var.avaliable_zones))].transit_gateway_id
}

# EKS용 private subnet의 라우팅 테이블에 transit gateway 연결
resource "aws_route" "eks_private_transit_gateway" {
  count = length(local.private_transit_gateways) * length(aws_subnet.eks_private)

  route_table_id         = aws_route_table.eks_private[count.index % length(aws_subnet.eks_private)].id
  destination_cidr_block = local.private_transit_gateways[floor(count.index / length(aws_subnet.eks_private))].cidr
  transit_gateway_id     = local.private_transit_gateways[floor(count.index / length(aws_subnet.eks_private))].transit_gateway_id
}

# private route table과 private subnet 연결
resource "aws_route_table_association" "private" {
  count = try(length(var.private_network_address), 0)
  #count          = length(var.private_network_logic)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

# EKS용 private route table과 EKS private subnet 연결
resource "aws_route_table_association" "eks_private" {
  count = try(length(var.eks_private_network_address), 0)
  #count          = length(var.eks_private_network_address)
  subnet_id      = element(aws_subnet.eks_private[*].id, count.index)
  route_table_id = element(aws_route_table.eks_private[*].id, count.index)
}


# Data Base Route table 생성
resource "aws_route_table" "database" {
  #count  = try(length(var.db_network_address), 0) > 0 ? length(var.db_network_address) : 0
  count  = try(length(var.db_network_address), 0)
  vpc_id = aws_vpc.main.id
  tags = merge({
    "Name" = "${local.project_name_and_env_name}-DB-TABLE-${upper(substr(element(var.avaliable_zones, count.index), -1, -1))}"
    },
    var.common_tags
  )
}

# Data Base Route table에 Database subnet 연결
resource "aws_route_table_association" "database" {
  count          = try(length(var.db_network_address), 0) > 0 ? length(var.db_network_address) : 0
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = element(aws_route_table.database[*].id, count.index)
}


