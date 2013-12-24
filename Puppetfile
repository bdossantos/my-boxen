# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.3.4"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",    "1.0.1"
github "foreman",    "1.0.0"
github "gcc",        "2.0.100"
github "git",        "1.3.7"
github "homebrew",   "1.6.0"
github "hub",        "1.1.0"
github "inifile",    "1.0.0", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",      "1.4.2"
github "nodejs",     "3.2.10"
github "openssl",    "1.0.0"
github "pkgconfig",  "1.0.0"
github "repository", "2.2.0"
github "stdlib",     "4.1.0", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",       "1.0.0"
github "xquartz",    "1.1.1"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

github "osx",               "2.2.1"
github "property_list_key", "0.1.0", :repo => "glarizza/puppet-property_list_key"
github "iterm2",            "1.0.6"
github "macvim",            "1.0.0"
github "vundle",            "0.0.1", :repo => "bdossantos/puppet-vundle"
github "virtualbox",        "1.0.6"
github "vagrant",           "3.0.1"
github "packer",            "1.1.0"
github "chrome",            "1.1.2"
github "firefox",           "1.1.3"
github "opera",             "0.2.1"
github "sequel_pro",        "1.0.0"
github "vlc",               "1.0.3"
github "openoffice",        "1.2.0"
github "keepassx",          "1.0.0"
github "go",                "1.0.0"
github "flux",              "1.0.0"
github "dropbox",           "1.1.2"
github "imageoptim",        "0.0.2"
github "googledrive",       "1.0.2"
github "nike_plus_connect", "0.0.1", :repo => "bdossantos/puppet-module-nike_plus_connect"
github "python",            "1.3.0"
github "gimp",              "1.0.0"
github "xz",                "1.0.0"
github "imagemagick",       "1.2.0"
github "phantomjs",         "2.0.2"
github "zsh",               "1.0.0"
github "tmux",              "1.0.2"
github "spectacle",         "1.0.0"
