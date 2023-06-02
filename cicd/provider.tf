provider "aws" {
  region  = "ap-northeast-2"
  profile = "GS_CALTEX"

  default_tags {
    tags = {
      Environment = "CICD"
      Owner       = "GS-Caltex"
      Project     = "EV-SYSTEM"
    }
  }
}
