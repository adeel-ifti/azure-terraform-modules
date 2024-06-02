# Example InSpec Profile For GCP

This example shows the implementation of an InSpec profile for GCP that depends on the [InSpec GCP Resource Pack](https://github.com/inspec/inspec-gcp).  See the [README](https://github.com/inspec/inspec-gcp) for instructions on setting up appropriate GCP credentials.


## Update `inputs.yml` 

Update inputs.yaml to add following properties

```
gcp_project_id: 'my-gcp-project'
region: "us-west1"
redis_instance_name: "redis-instance-1"
```

## Run the tests

```
$ cd inspec/gcp
$ inspec exec . -t gcp:// --input-file=inputs.yml

PProfile: GCP InSpec Profile (gcp)
Version: 0.1.0
Target:  gcp://764086051850-6qr4p6gpi6hn506pt8ejuq83di341hur.apps.googleusercontent.com

  ✔  redis-property-test: Ensure redis has desired properties
     ✔  Instance redis-instance-1 is expected to exist
     ✔  Instance redis-instance-1 tier is expected to cmp == "STANDARD_HA"
     ✔  Instance redis-instance-1 memory_size_gb is expected to cmp == "1"
     ✔  Instance redis-instance-1 redis_version is expected to cmp == "REDIS_4_0"
     ✔  Instance redis-instance-1 labels is expected to include {"env" => "dev"}


Profile: Google Cloud Platform Resource Pack (inspec-gcp)
Version: 1.10.0
Target:  gcp://764086051850-6qr4p6gpi6hn506pt8ejuq83di341hur.apps.googleusercontent.com

     No tests executed.

Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 5 successful, 0 failures, 0 skipped

```
