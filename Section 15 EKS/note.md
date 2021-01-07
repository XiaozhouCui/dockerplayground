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

## Connect to EKS from local machine using AWS CLI
- Goto file *user/.kube/config*, make a backup copy *config.minikube* and delete the *config* file
- Download and install AWS CLI on local machine
- Goto AWS consoles, click **My Account** then select **My Security Credentials**
- Under **Access Keys**, click **Create New Access Key** button and download **rootkey.csv** file
- In CMD, enter `aws configure`, then enter the credentials from CSV file, and `ap-southeast-2` as region
- Once logged in, enter command `aws eks --region ap-southeast-2 update-kubeconfig --name kub-dep-demo`, this will create the file *user/.kube/config* to connect to EKS
- Now running `kubectl get pod` will connect to the EKS on the cloud, minikube can be deleted `minikube delete`

## Create a new role for EKS Worker Nodes
- Worker Nodes are EC2 instances, need to create another role in **IAM**
- Go to **IAM** again, click **Roles** on side bar, then click **Create role** button
- Select **AWS service -> EC2**, then click *Next: Permission* go to permission page
- Search `eksworker` and then select `AmazonEKSWorkerNodePolicy` in result
- Search `cni` and then select `AmazonEKS_CNI_Policy` in result
- Search `ec2containerreg` and then select `AmazonEC2ContainerRegistryReadOnly` in result
- Click *Next* 2 times, enter **Role Name** `eksNodeGroup` make sure 3 policies are added, then click *Create*

## Add Worker Nodes (EC2 instances)
- In EKS, goto cluster `kub-dep-demo`, under **Compute** section, click *Add Node Group*
- Under **Name** enter `demo-dep-nodes`
- Under **Node IAM Role** select the newly created `eksNodeGroup`, click *Next*
- In **Compute and Scaling** page, under **Instance types** select at least `t3.small` or bigger
- Under **Node Group scaling configuration**, select `2` nodes, **Nodes** are physical machines, click *Next*
- In **Networking** page, disable **Allow remote access to nodes** (disable SSH) then click *Next* then *Create*
- This will start 2 EC2 instances and add them to this k8s cluster, no Load Balancer for now
- Run `kubectl get node` can see the created nodes on EKS cloud

## Apply yaml files on EKS
- Make sure image path in yaml files are updated, and images are pushed to docker hub
- Go to kubernetes folder, run `kubectl apply -f auth.yaml -f users.yaml`, this will also create EC2 LoadBalancer
- Run `kubectl get service` to get the services list, copy the **EXTERNAL-IP** of LoadBalancer, this is the URL to send HTTP requests.
- In Postman, send a POST request `{ "email":"test@test.com", "password": "testers" }` to the URL `...ap-southeast-2.elb.amazonaws.com/signup`, response should be "User created.", and in MongoDB a new user `test@test.com` should be created as well.

## Deploy the Amazon EFS CSI Driver to Amazon EKS cluster
- Install the CSI driver on EKS, run the command shown below
- `kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.0"`
- Now the EFS is supported as a volume type
- Go to VPC on AWS, go to **VPCs -> eksVpc**, copy the IP address of **IPv4 CIDR** `192.168.0.0/16`
- Go to EC2 on AWS, click *Security Groups* on the side bar, click *Create security group*
- Name the security group `eks-efs`, enter `Security group for EFS` as **Description**, under **VPC** select `eksVpc`, under **Inbound rules** click *Add rule*, the select `NFS`, paste IPv4 CIDR `192.168.0.0/16` as `Custom` **Source**, then click *Create*
- Go to EFS on AWS, click *Create file system*
- In popup modal, name the EFS `eks-efs`, select `eksVpc`, click *Customize*
- Click *Next* go to **Network access**, then remove the default security groups and add the newly added `eks-efs` for both zones, click *Next* then click *Create*
- This EFS can now be used as a volume, copy the File system ID `fs-4ae75172`


