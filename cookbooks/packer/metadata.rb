name 'packer'
maintainer 'The Authors'
maintainer_email 'ben.lucato@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures packer'
long_description 'Installs/Configures packer'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/packer/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/packer'

depends 'powershell', '~> 6.1.0'
