class people::bdossantos {
  include iterm2::stable
  include macvim
  include virtualbox
  include vagrant
  include chrome
  include sequel_pro
  include vlc
  include openoffice
  include keepassx
  include go
  include flux
  include dropbox
  include imageoptim
  include googledrive

  $home     = "/Users/${::luser}"
  $my       = "${home}/Code"
  $dotfiles = "${my}/dotfiles"

  repository { $dotfiles:
    source  => 'bdossantos/dotfiles',
  }

  class { 'nodejs::global': 
    version => 'v0.10.5',
  }

  package { ['wget', 'ruby-build', ]:
    ensure => latest,
  }
}
