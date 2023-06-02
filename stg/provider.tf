provider "aws" {
  region = "ap-northeast-2"
  profile = "GS_CALTEX"

  default_tags {
    tags = {
      Environment = "STG"
      Owner       = "GS-Caltex"
      Project     = "EV-SYSTEM"
    }
  }
}
