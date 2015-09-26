package 'redis-server' do
  action :install
end

service 'redis-server' do
  action :enable
end