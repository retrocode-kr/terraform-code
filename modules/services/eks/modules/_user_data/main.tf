locals {
  int_linux_default_user_data = var.create && var.platform == "linux" && (var.enable_bootstrap_user_data || var.user_data_template_path != "") ? base64encode(templatefile(
    coalesce(var.user_data_template_path, "${path.module}/../../templates/linux_user_data.tpl"),
    {
      # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami

      enable_bootstrap_user_data = var.enable_bootstrap_user_data
      # Required to bootstrap node
      cluster_name        = var.cluster_name
      cluster_endpoint    = var.cluster_endpoint
      cluater_auth_base64 = var.cluster_auth_base64
      #Optional
      cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr != null ? var.cluster_service_ipv4_cidr : ""
      bootstrap_extra_args      = var.bootstrap_extra_args
      pre_bootstrap_user_data   = var.pre_bootstrap_user_data
      post_bootstrap_user_data  = var.post_bootstrap_user_data
    }
  )) : ""
  platform = {
    bottlerocket = {
      user_data = var.create && var.platform == "bottlerocket" && (var.enable_bootstrap_user_data || var.user_data_template_path != "" || var.bootstrap_extra_args != "") ? base64encode(templatefile(
        coalesce(var.user_data_template_path, "${path.module}/../../templates/bottelrocket_user_data.tpl"),
        {
          # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
          enable_bootstrap_user_data = var.enable_bootstrap_user_data
          # Required to bootstrap node
          cluster_name        = var.cluster_name
          cluster_endpoint    = var.cluster_endpoint
          cluater_auth_base64 = var.cluster_auth_base64
          # Optional - is appended if using EKS managed node group without custom AMI
          # cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr # Bottlerocket pulls this automatically https://github.com/bottlerocket-os/bottlerocket/issues/1866
          bootstrap_extra_args = var.bootstrap_extra_args
        }
      )) : ""
    }
    linux = {
      user_data = try(data.cloudinit_config.linux_eks_managed_node_group[0].rendered, local.int_linux_default_user_data)
    }
  }
}

data "cloudinit_config" "linux_eks_managed_node_group" {
  count = var.create && var.platform == "linux" && var.is_eks_managed_node_group && !var.enable_bootstrap_user_data && var.pre_bootstrap_user_data != "" && var.user_data_template_path == "" ? 1 : 0

  base64_encode = true
  gzip          = false
  boundary      = "//"

  # Prepend to existing user data supplied by AWS EKS
  part {
    content_type = "text/x-shellscript"
    content      = var.pre_bootstrap_user_data
  }
}