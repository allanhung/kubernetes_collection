## Allow ssh
### query security group id from instance
export INSTID=i-0xi2zirv9d1j14vxek0f
aliyun ecs DescribeInstances --InstanceIds \[\"${INSTID}\"\] | jq -r '.Instances.Instance[].SecurityGroupIds.SecurityGroupId[]'

### query security group context
export SGID=sg-0xie283qzyoduvloq4m2
aliyun ecs DescribeSecurityGroupAttribute --SecurityGroupId ${SGID}

### allow ssh from specify ip
export CIDR=10.0.0.0/8
aliyun ecs AuthorizeSecurityGroup --SecurityGroupId ${SGID} --IpProtocol tcp --PortRange 22/22 --NicType intranet --Policy accept --Priority 1 --Description bouncer  --SourceCidrIp ${CIDR}

##

* [Collect the logs of control plane components](https://www.alibabacloud.com/help/doc-detail/198268.htm)
