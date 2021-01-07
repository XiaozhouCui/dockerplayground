## Prepare for deployment
- Create repo on docker hub `xiaozhoucui/kub-dep-users`, `xiaozhoucui/kub-dep-auth`
- Goto users-api/ folder, build image `xiaozhoucui/kub-dep-users` and push to docker hub
- Goto auth-api/ folder, build image `xiaozhoucui/kub-dep-auth` and push to docker hub

## Create a Role for EKS cluster on AWS
- To give EKS permissons, go to AWS **IAM**, click **Roles** on side bar, then click **Create role** button
- Select **AWS service -> EKS -> EKS-Cluster**, then click **Next** 3 times
- Enter **Role name** `eksClusterRole`, click **Create role**, then the new role will be created

## Create an EKS cluster
- Go to AWS EKS home page, under **Create EKS cluster** enter `kub-dep-demo` and click "Next step"
- Select latest k8s version (`1.18`), under **Cluster Service Role** select `eksClusterRole`, click **Next**
- 