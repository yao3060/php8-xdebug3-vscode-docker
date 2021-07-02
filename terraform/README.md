# Create AliCloud K8s Cluster


## Workspaces

The project is set-up to use workspaces, you can see these as environments that can then be used to set your customizations through vars files and secrets.

## Variables

Create a `vars-{ENV}.tfvars` file with overrides for the specific environment.

## Secrets

Create a `secrets-{ENV}.tfvars` file containing the required secrets to be used.

```
access_key          = "ALIYUN ACCESS KEY"
secret_key          = "ALIYUN SECRET KEY"
db_password         = "DB PASSWORD"
```

## How to run

1. Select your workspace
```
terraform workspace select {ENV}
```
2. Plan a terraform run using:
```
terraform plan -var-file secrets-{ENV}.tfvars -var-file vars-{ENV}.tfvars
```
3. Apply a terraform run using:
```
terraform apply -var-file secrets-{ENV}.tfvars -var-file vars-{ENV}.tfvars
```

## Preparation

The Aliyun account will require enabling the different services before the terraform script will be able to create instances on them.

Navigate to the following locations and enable the different services:

- [https://cr.console.aliyun.com/cn-shanghai/instance/credentials](Container Registry) - Set a password
- [https://cs.console.aliyun.com/](Container service) - Create the default RAM role
- [https://nasnext.console.aliyun.com/](NAS) - Enable the service
- [https://ram.console.aliyun.com/role/authorization?request=%7B%22Services%22%3A%5B%7B%22Service%22%3A%22CS%22%2C%22Roles%22%3A%5B%7B%22RoleName%22%3A%22AliyunCSManagedAutoScalerRole%22%2C%22TemplateId%22%3A%22AliyunCSManagedAutoScalerRole%22%7D%5D%7D%5D%2C%22ReturnUrl%22%3A%22https%3A%2F%2Fcs.console.aliyun.com%2F%22%7D](Allow CS to create instances) - Enable to allow autoscaling

## Caveats

- *N.B. These operations, as well as the terraform script running will send a very large multitude of text messages to the owner of the aliyun account*
- If resource groups are created and then deleted, they take 1 week to be removed so `terraform delete` will create inconsistency when we try to run again the `terraform apply` if this is enabled. (Is commented out by default)
