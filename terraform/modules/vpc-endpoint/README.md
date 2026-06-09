# VPC Endpoints Terraform Module

This module creates VPC Endpoints used by private workloads inside the VPC to access selected AWS services without routing traffic through the public internet.

In this project, the module is used mainly to allow EKS worker nodes in private subnets to pull container images from Amazon ECR privately.

## Resources Created

* `aws_vpc_endpoint` for S3 Gateway Endpoint
* `aws_vpc_endpoint` for ECR API Interface Endpoint
* `aws_vpc_endpoint` for ECR Docker Interface Endpoint

## Current Use Case

The Uptime Kuma application will run on EKS worker nodes located in private application subnets.

When Kubernetes pulls container images from Amazon ECR, the nodes need access to:

* ECR API
* ECR Docker Registry
* S3, which is used behind the scenes for ECR image layers

This module provides private connectivity to those services.

## Endpoints

### S3 Gateway Endpoint

The S3 Gateway Endpoint allows private subnets to access Amazon S3 without using the NAT Gateway.

In this project, it is associated with the private route tables:

* Private application route table
* Private data route table

The S3 Gateway Endpoint is also important for ECR image pulls because ECR stores image layers in S3 behind the scenes.

### ECR API Interface Endpoint

The ECR API endpoint is used for ECR API operations such as authentication and image metadata access.

Service name format:

```text
com.amazonaws.<region>.ecr.api
```

### ECR Docker Interface Endpoint

The ECR Docker endpoint is used by the container runtime to pull Docker images from Amazon ECR.

Service name format:

```text
com.amazonaws.<region>.ecr.dkr
```

## Networking Flow

Without VPC Endpoints, private EKS nodes access ECR through the NAT Gateway:

```text
EKS private node
  ↓
NAT Gateway
  ↓
Public AWS service endpoint
  ↓
Amazon ECR / S3
```

With VPC Endpoints, EKS nodes access ECR and S3 privately:

```text
EKS private node
  ↓
VPC Interface Endpoint: ECR API
  ↓
Amazon ECR

EKS private node
  ↓
VPC Interface Endpoint: ECR Docker
  ↓
Amazon ECR

EKS private node
  ↓
S3 Gateway Endpoint
  ↓
Amazon S3
```

## Security

The ECR interface endpoints are attached to a dedicated VPC Endpoints Security Group.

The Security Group allows inbound HTTPS traffic only from the actual EKS node security group.

Required inbound rule:

```text
TCP 443 from EKS node security group
```

This keeps the endpoints private and limits access to workloads running on EKS nodes.

## Private DNS

Interface endpoints use private DNS.

When private DNS is enabled, requests to public AWS service names such as:

```text
api.ecr.us-east-1.amazonaws.com
dkr.ecr.us-east-1.amazonaws.com
```

resolve to private IP addresses inside the VPC.

This allows workloads to use the standard AWS service DNS names while traffic stays inside the AWS private network.

## Cost Notes

S3 Gateway Endpoints do not have an hourly endpoint charge.

ECR API and ECR Docker are Interface Endpoints. Interface Endpoints create ENIs in the selected subnets and have hourly and data processing costs.

For this reason, this project creates only the endpoints that are currently useful:

* S3 Gateway Endpoint
* ECR API Interface Endpoint
* ECR Docker Interface Endpoint

Additional endpoints, such as Secrets Manager or STS, can be added later when they are required by workloads such as External Secrets Operator.

## Inputs

| Name                         | Description                                           | Type           | Default |
| ---------------------------- | ----------------------------------------------------- | -------------- | ------- |
| `project_name`               | Project name                                          | `string`       | n/a     |
| `environment`                | Environment name                                      | `string`       | n/a     |
| `vpc_id`                     | VPC ID                                                | `string`       | n/a     |
| `private_subnet_ids`         | Private subnet IDs for Interface Endpoints            | `list(string)` | n/a     |
| `route_table_ids`            | Route table IDs for Gateway Endpoints                 | `list(string)` | n/a     |
| `security_group_ids`         | Security group IDs for Interface Endpoints            | `list(string)` | n/a     |
| `enable_s3_gateway_endpoint` | Whether to create the S3 Gateway Endpoint             | `bool`         | `true`  |
| `enable_ecr_api_endpoint`    | Whether to create the ECR API Interface Endpoint      | `bool`         | `true`  |
| `enable_ecr_dkr_endpoint`    | Whether to create the ECR Docker Interface Endpoint   | `bool`         | `true`  |
| `private_dns_enabled`        | Whether to enable private DNS for Interface Endpoints | `bool`         | `true`  |
| `tags`                       | Tags to apply to resources                            | `map(string)`  | `{}`    |

## Outputs

| Name                     | Description                          |
| ------------------------ | ------------------------------------ |
| `s3_gateway_endpoint_id` | S3 Gateway VPC Endpoint ID           |
| `ecr_api_endpoint_id`    | ECR API Interface VPC Endpoint ID    |
| `ecr_dkr_endpoint_id`    | ECR Docker Interface VPC Endpoint ID |

## Verification

To verify that ECR traffic resolves through the VPC Endpoints, run a temporary pod:

```bash
kubectl run netshoot \
  --rm -it \
  --restart=Never \
  --image=nicolaka/netshoot \
  -- bash
```

Inside the pod:

```bash
dig +short api.ecr.us-east-1.amazonaws.com
dig +short dkr.ecr.us-east-1.amazonaws.com
```

The returned IP addresses should be private IPs from the VPC.

You can compare them with the ENI private IPs of the ECR VPC Endpoints:

```bash
aws ec2 describe-vpc-endpoints \
  --region us-east-1 \
  --filters "Name=service-name,Values=com.amazonaws.us-east-1.ecr.api,com.amazonaws.us-east-1.ecr.dkr" \
  --query "VpcEndpoints[*].[ServiceName,VpcEndpointId,PrivateDnsEnabled,NetworkInterfaceIds]" \
  --output table
```

## Git Safety

This module does not contain secrets.

Safe to commit:

* `main.tf`
* `variables.tf`
* `outputs.tf`
* `README.md`

Do not commit:

* Terraform state files
* real `terraform.tfvars`
* real `backend.tf`
* AWS credentials
