define :opsworks_deploy_dir do

  # before creating a deploy directory ensure
  # bind mounts have been made due to a race condition
  # with the automounter

  if node[:opsworks_initial_setup].attribute?(:bind_mounts)
    node[:opsworks_initial_setup][:bind_mounts][:mounts].each do |dir, source|
      bash "Check for bind mounts before creating the deploy directory" do
        code <<-EOH
          retries=3
          until grep -q #{dir} /proc/mounts; do
            if [[ $(( retries-- )) -lt 1 ]]; then
              echo "Bind mount check failed for #{dir}"
              exit 1
            fi
            sleep 2
          done
        EOH
        ignore_failure true
      end
    end
  end
end
