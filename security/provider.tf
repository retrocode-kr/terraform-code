provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Environment = "SECURITY"
      Owner       = "GS-Caltex"
      Project     = "EV-SYSTEM"
    }
  }
}
