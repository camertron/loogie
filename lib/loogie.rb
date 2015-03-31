require 'loogie/version'

module Loogie
  autoload :BundleHash,       'loogie/bundle_hash'
  autoload :Installer,        'loogie/installer'
  autoload :GitInstaller,     'loogie/git_installer'
  autoload :RubygemInstaller, 'loogie/rubygem_installer'
  autoload :Packager,         'loogie/packager'
  autoload :Server,           'loogie/server'
end
