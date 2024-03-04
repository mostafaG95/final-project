# Project to deploy python/redis app on eks using jenkins

![221380248-7da699ae-5ffd-4fc5-98dd-00e067781cde](https://user-images.githubusercontent.com/116643188/227719104-36b1c5a9-e523-4cf7-8e05-394bd9f464bb.png)


python app here : https://github.com/mostafaG95/python

Tools Used:
1- Terraform infrastructure as a code to build the infrastructure, Terraform code includes:

(VPC - 2 public subnets - 2 private subnets - EKS cluster with workernode and roles - internet gateway - nat gateway - route tables).

2- AWS EKS:

Used to deploy Application

3- Docker:

Used to build dockerfiles for jenkins and the application

4- jenkins:

Used to make the CI CD part and make a complete pipeline
