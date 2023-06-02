provider "aws" {
  region  = "ap-northeast-2"
  profile = "GS_CALTEX"

  default_tags {
    tags = {
      Environment = "DEV"
      Owner       = "GS-Caltex"
      Project     = "EV-SYSTEM"
    }
  }
}
