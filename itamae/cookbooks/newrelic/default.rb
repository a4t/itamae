node.validate! do
  {
    newrelic: {
      license_key: string,
    }
  }
end

execute 'install newrelic' do
  cwd node[:common][:config][:file_cache_path]

  command "
  echo deb http://apt.newrelic.com/debian/ newrelic non-free > /etc/apt/sources.list.d/newrelic.list && \
  wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -  && \
  apt-get update
  "
  not_if "test -e /etc/apt/sources.list.d/newrelic.list"
end

package 'newrelic-sysmond'

template '/etc/newrelic/nrsysmond.cfg' do
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :restart, 'service[newrelic-sysmond]'
end

service 'newrelic-sysmond' do
  action :enable
end