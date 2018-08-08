This module was created by executing
```apacheconfig
kops create cluster \
--state=s3://jpuellma-net-general/kops-state \
--out=./modules/kubernetes/ \
--target=terraform \
--cloud aws \
--zones "us-east-1d,us-east-1b,us-east-1c" \
--name test.jpuellma.net
```