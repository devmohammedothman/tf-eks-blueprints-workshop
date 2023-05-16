locals {

  name     = "eks-blp-ws"
  vpc_cidr = "182.31.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)


  cluster_version = "1.23"
  node_group_name = "eks-ws-grp1"
  env = "dev"

  #---------------------------------------------------------------
  # ARGOCD ADD-ON APPLICATION
  #---------------------------------------------------------------

  addon_application = {
    path               = "chart"
    repo_url           = "https://github.com/aws-samples/eks-blueprints-add-ons.git"
    add_on_application = true
  }

  tags = {
    Blueprint = "EKS Blueprint Workshop"
  }

  #---------------------------------------------------------------
  # ARGOCD WORKLOAD APPLICATION
  #---------------------------------------------------------------
  workload_repo = "https://github.com/devmohammedothman/argocd-workloads.git"

  workload_application = {
    path               = "envs/dev"
    repo_url           = local.workload_repo
    add_on_application = false
    values = {
      labels = {
        env   = local.env
        myapp = "SkiApp"
      }
      spec = {
        source = {
          repoURL        = local.workload_repo
        }
        blueprint                = "terraform"
        clusterName              = local.name
        #karpenterInstanceProfile = "${local.name}-${local.node_group_name}" # Activate to enable Karpenter manifests (only when Karpenter add-on will be enabled in the Karpenter module)
        env                      = local.env
      }
    }    
  }
}