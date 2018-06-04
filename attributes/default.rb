default[:monit][:config_file] = '/etc/monitrc'

default[:monit][:email_alerts?]  = true
default[:monit][:notify_email]   = 'root@localhost'
default[:monit][:notify_keyword] = 'NOT ON'
default[:monit][:notify_event]   = %w(action instance pid ppid)

default[:monit][:poll_period]           = 60
default[:monit][:poll_start_delay]      = 120

default[:monit][:mail_format][:subject] = '$SERVICE $EVENT'
default[:monit][:mail_format][:from]    = "monit@#{node['fqdn']}"
default[:monit][:mail_format][:message] = <<-EOS
Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
Yours sincerely,
monit
EOS

default[:monit][:mailserver][:host] = 'localhost'
default[:monit][:mailserver][:port] = nil
default[:monit][:mailserver][:username] = nil
default[:monit][:mailserver][:password] = nil
default[:monit][:mailserver][:password_suffix] = nil
default[:monit][:mailserver][:using] = nil
default[:monit][:mailserver][:with] = nil

default[:monit][:port] = 3737
default[:monit][:address] = 'localhost'
default[:monit][:ssl] = false
default[:monit][:cert] = '/etc/monit/monit.pem'
default[:monit][:allow] = ['localhost']

default[:monit][:include] = []

default[:monit][:log_file] = nil
