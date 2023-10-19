Welcome to the documentation for the Bands API. This repository contains Terraform code for infrastructure, Kotlin for the back-end API, a postman folder with a collection to communicate with the deployed API and last but not least, an OpenAPI 3.0 specification. Please follow the instructions below to get started with this project.

### Getting Started

Follow these steps to provision the infrastructure at AWS:

1. Let's configure the AWS CLI
   1. Download the AWS CLI
   2. Run ```aws configure``` configuring the access key, secret access key, region and default output
   3. Run ```aws s3 ls``` to run a quick little smoke test. No errors, success
2. Now, We're gonna start bringing up the Infrastructure. To bring it all up we need the Terraform binary installed
3. Having installed it, follow through the next steps:
4. Provisioning the common/base resources (ECR, IAM etc):
   1. ```cd ./infrastructure/bootstrap```
   2. ```terraform init```
   3. ```terraform -var-file ../variables.tfvars apply -auto-approve```
5. Building the image and pushing to ECR:

```
docker build -t bands-api .

docker tag bands-api ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/repository:latest

aws ecr get-login-password --region REGION | docker login --username AWS --password-stdin ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/repository

docker push ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/repository:latest
```

6. Provisioning the RDS Postgres database:
   1. ```cd ./infrastructure/db```
   2. ```terraform init```
   3. ```terraform -var-file ../variables.tfvars apply -auto-approve```

7. Provisioning the NLB and the ECS cluster:
   1. ```cd ./infrastructure/app```
   2. ```terraform init```
   3. ```terraform apply -auto-approve```

8. Provisioning the API Gateway:
   1. ```cd ./infrastructure/gateway```
   2. ```terraform init```
   3. ```terraform -var-file ../variables.tfvars apply -auto-approve```
9. Testing it out
   1. Import the Postman collection
   2. Open AWS Console -> go to API Gateway, copy the API Gateway ID
   3. Go back to the collection, open the Band Env environment and set the APIGW ID to the *api_gw_id* variable