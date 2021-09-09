
# Step-6 Elastic IP

EC2 VMs are by default assigned a *Public IP* address - see here for more details: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-instance-addressing.html#concepts-public-addresses

However in some circumstances that *Public IP* is released, e.g. if the instance is *stopped* or *hibernated* or of course *terminated*.
See the above link for more details.

If you want a *Public IP* which persists you can use an *Elastic IP*

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html

In this step we will create an *Elastic IP* and associate it with our EC2 VM instance by specifying our ```EC2 instance id```

```
resource "aws_eip" "eip" {
  instance = aws_instance.webserver.id
  vpc = true
}
```
