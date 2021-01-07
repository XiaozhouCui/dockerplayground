## Prepare for deployment
- Create repo on docker hub `xiaozhoucui/kub-dep-users`, `xiaozhoucui/kub-dep-auth`
- Goto users-api/ folder, build image `xiaozhoucui/kub-dep-users` and push to docker hub
- Goto auth-api/ folder, build image `xiaozhoucui/kub-dep-auth` and push to docker hub

## Create a Role for EKS cluster on AWS
- To give EKS permissons, go to AWS **IAM**, click **Roles** on side bar, then click **Create role** button
- Select **AWS service -> EKS -> EKS-Cluster**, then click *Next* 3 times
- Enter **Role name** `eksClusterRole`, click **Create role**, then the new role will be created
- Close IAM tab

## AWS CloudFormation: create VPC for EKS cluster
- Go to AWS CloudFormation to configure VPC network for EKS
- `https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml`
- On CloudFormation homepage, Click *Create Stack*, paste above link to **Amazon S3 URL**, click *Next*
- Enter Stack name `eksVpc`, click *Next* 2 time and click *Create stack*
- Close CloudFormation tab

## Create an EKS cluster
- Go to AWS EKS home page, under **Create EKS cluster** enter `kub-dep-demo` and click "Next step"
- Select latest k8s version (`1.18`), under **Cluster Service Role** select `eksClusterRole`, click *Next*
- On Network page, under **VPC** select newly created `eksVpc`, under **Cluster endpoint access**, choose `Public and private`, click *Next*
- On Logging page, no need to add anything, click *Next*, then click *Create*

## Talk to EKS from local machine
- Goto file *user/.kube/config*, make a copy *config.minikube*
- 