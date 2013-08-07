class people::bdossantos {
  include iterm2::stable
  include macvim
  include vundle
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
  include xz
  include imagemagick
  include phantomjs
  include phantomjs::1_9_0
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

  class { 'phantomjs::global':
    version => '1.9.0',
  }

  $useful = [
    'wget', 'ruby-build', 'htop-osx', 'curl', 'ssh-copy-id', 'pwgen', 'gsl',
  ]

  package { $useful:
    ensure => latest,
  }
}
