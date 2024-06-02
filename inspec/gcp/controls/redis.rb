# copyright: 2018, The Authors

title "Redis memroy state config test"

gcp_project_id = input("gcp_project_id")
redis_instance_name = input("redis-instance-name")
region              = input("region")
# you add controls here
control "redis-property-test" do                                                      # A unique ID for this control
  impact 1.0                                                                          # The criticality, if this control fails.
  title "Ensure redis has desired properties"                            # A human-readable title
  desc "To make sure redis has all properties that are defined in terraform"
  describe google_redis_instance(project: gcp_project_id, region: region, name: redis_instance_name) do
    it { should exist }
    its('tier') { should cmp 'STANDARD_HA' }
    its('memory_size_gb') { should cmp '1' }
    its('redis_version') { should cmp 'REDIS_4_0' }
    its('labels') { should include('env' => 'dev') }
  end
end


