class people::bdossantos {
  include iterm2::stable
  include macvim
  include virtualbox
  include vagrant
  include packer
  include chrome
  include chrome::canary
  include firefox
  include python
  include go
  include sequel_pro
  include vlc
  include openoffice
  include gimp
  include keepassx
  include flux
  include dropbox
  include imageoptim
  include imagemagick
  include googledrive
  include nike_plus_connect

  $home     = "/Users/${::luser}"
  $my       = "${home}/Code"
  $dotfiles = "${my}/dotfiles"

  repository { $dotfiles:
    source  => 'bdossantos/dotfiles',
  }

  class { 'nodejs::global': 
    version => 'v0.10.5',
  }

  $useful = [
    'wget', 'ruby-build', 'htop-osx', 'curl', 'ssh-copy-id', 'pwgen', 'gsl',
  ]

  package { $useful:
    ensure => latest,
  }
}
