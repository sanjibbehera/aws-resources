# aws-resources
Create AWS Resource via Terraform.

    This is simple repo containing Terraform code used to spinup AWS Resources.
    The below tasks are ongoing tasks and hence the repo will regularly updated.
    
    Task No. 1  :-  Create baseline infrastructure i.e. VPC resources.                              [DONE]
    Task No. 2a :-  Create EC2 resources, ssh key and userdata to install APACHE base software.     [DONE]
    Task No. 2b :-  Create EC2 Bastion resource and move apache instances to private subnets.       [DONE]
    Task No. 2c :-  Create EC2 resource & install software & then create AMI from that EC2.         [DONE]
    Task No. 2d :-  Create EC2 ASG resource for the APACHE EC2 Instance in the Private Subnet.      [WIP]
    Task No. 2e :-  Create EC2 Instance in Private Subnet, attach VPC endpoint to connect DynamoDB. [WIP]
    Task No. 3  :-  Create ELB and attach ELB IP to the security group of EC2 Apache instances.     [DONE]
    Task No. 4  :-  Create S3 Bucket to store the remote state.                                     [DONE]
    Task No. 5  :-  Create IAM resources for SSM.                                                   [DONE]
    Task No. 6a :-  Create MYSQL RDS DB Instance and host them in Private Subnet of the VPC.        [DONE]
    Task No. 6b :-  Enable skip Snapshot creation upon deletion of the RDS DB Instance.             [DONE]
    Task No. 7  :-  Create ECS Cluster and Install Docker Images.                                   [WIP]
    Task No. 8  :-  Create DynamoDB Table such that EC2 instance in private subnet connects to it.  [DONE]
    Task No. 9  :-  More task coming up.
    
Usage
===================
    Use the below commands to setup the resources in this repo.
    terraform init
    terraform validate
    terraform plan -out=tf.plan
    terraform apply -auto-approve tf.plan [You can setup terraform.tfvars in the root dir according to your needs].
    *** Snapshot of the 'terraform.tfvars' file has been attached in the Snapshot Folder for reference for this project.
    <Don't forget to destroy your resources using the below command to avoid incurring bills from AWS.>
    terraform destroy -auto-approve
    ** Please Note that you would require AWS Access KEYS & AWS SECRET ACCESS KEYS to 
    ** access AWS resources & also create AWS resources. 
    ** Hence create a AWS admin user using AWS IAM, it is reqd for the above tasks and configure these keys  
    ** or pass them as environment variables with the command <terraform apply> if you do not wish to store them.
