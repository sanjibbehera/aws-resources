# aws-resources
Create AWS Resource via Terraform.

    This is simple repo containing Terraform code used to spinup AWS Resources.
    The below tasks are ongoing tasks and hence the repo will regularly updated.
    
    First Task:-  Create baseline infrastructure i.e. VPC resources. [DONE]
    Second Task:- Create EC2 resources, ssh key and userdata to install APACHE base software. [DONE]
    Third Task:-  Create IAM resources for SSM.
    Fourth Task:- Create ELB and attach ELB IP to the security group of EC2 instances.
    Fifth Task:-  Create MYSQL RDS DB Instance and host them in Private Subnet of the VPC.
    Sixth Task:-  More task coming up.
    
Usage
===================
    Use the below commands to setup the resources in this repo.
    terraform init
    terraform validate
    terraform plan -out=tf.plan
    terraform apply -auto-approve tf.plan [You can setup terraform.tfvars in the root dir according to your needs].
    <Don't forget to destroy your resources using the below command to avoid incurring bills from AWS.>
    terraform destroy -auto-approve
