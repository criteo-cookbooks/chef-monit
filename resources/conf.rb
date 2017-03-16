actions :create, :delete

default_action :create

attribute :cookbook, :kind_of => String, :default => "monit"
attribute :depends, :kind_of => [String, Array]
attribute :group, :kind_of => [String, Array]
attribute :name, :name_attribute => true, :kind_of => String
attribute :path, :kind_of => String
attribute :pid, :kind_of => String
attribute :regexp, :kind_of => String
attribute :reload, :default => :delayed
attribute :alert, :kind_of => String
attribute :rule, :kind_of => [String, Array] #TODO: regex check for if then
attribute :start, :kind_of => String
attribute :start_as, :kind_of => String
attribute :start_timeout, :kind_of => String
attribute :stop, :kind_of => String
attribute :stop_as, :kind_of => String
attribute :template, :kind_of => String, :default => "conf.erb"
attribute :timeout,:kind_of => String, :default => '300 seconds'
attribute :type, :equal_to => [:file, :process, :program, :filesystem, :host], :default => :process
attribute :mode, :equal_to => [:active, :passive, :manual]

def initialize(*args)
  super
  @action = :create
end
