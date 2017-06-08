use_inline_resources

action :create do
  run_context.include_recipe "monit"
  # If the monit recipe has already been included outside the LWRP,
  # it won't be reincluded here, yet use_inline_resources's isolation
  # will cause service[monit] not to be defined here. So we make sure
  # that the template below will always see service[monit] as defined
  # in order to notify it.
  service "monit"

  if new_resource.type == :file && !new_resource.path
    Chef::Log.fatal("Type: #{new_resource.type.to_s} requires a path attribute.")
  end
  if new_resource.type == :process && !(new_resource.pid || new_resource.regexp)
    Chef::Log.fatal("Type: #{new_resource.type.to_s} requires a pid attribute or a regexp expression.")
  end
  if new_resource.type == :program && !new_resource.path || !new_resource.timeout
    Chef::Log.fatal("Type: #{new_resource.type.to_s} requires a path and a timeout attribute.")
  end

  withs = case new_resource.type
          when :program
            "with path #{new_resource.path} with timeout #{new_resource.timeout}"
          when :process
            new_resource.pid ? "with pidfile #{new_resource.pid}" : "with matching '#{new_resource.regexp}'"
          when :host
            "with address #{node['ipaddress']}"
          else
            "with path #{new_resource.path}"
          end


  template "/etc/monit/conf.d/#{new_resource.name}.conf" do
    owner "root"
    group "root"
    mode 0644
    source new_resource.template
    cookbook new_resource.cookbook
    variables(
      :depends => new_resource.depends,
      :group => new_resource.group,
      :name => new_resource.name,
      :rule => new_resource.rule,
      :start => new_resource.start,
      :start_as => new_resource.start_as,
      :start_timeout => new_resource.start_timeout,
      :stop => new_resource.stop,
      :stop_as => new_resource.stop_as,
      :type => new_resource.type,
      :mode => new_resource.mode,
      :withs => withs
    )
    if new_resource.reload
      notifies :restart, "service[monit]", new_resource.reload 
    end
  end
end

action :delete do
  run_context.include_recipe "monit"
  service "monit" # See comment above

  template "/etc/monit/conf.d/#{new_resource.name}.conf" do
    action :delete
    source new_resource.template
    cookbook new_resource.cookbook
    if new_resource.reload
      notifies :restart, "service[monit]", new_resource.reload
    end
  end
end
