name             'nagios-herald'
maintainer       'ShowMobile, LLC'
maintainer_email 'jake.plimack@gmail.com'
license          'All rights reserved'
description      'Installs/Configures nagios-herald'
long_description 'Installs/Configures nagios-herald'
version          '0.1.0'

%w{ nagios python git }.each do |dep|
  depends dep
end

%w{ debian }.each do |os|
  supports os
end


