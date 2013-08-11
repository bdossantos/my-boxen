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
  include go::1_1_1
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

  class { 'ruby':
    chruby_rubies => "${home}/.rubies",
  }

  class { 'ruby::global':
    version => '2.0.0',
  }

  class { 'nodejs::global':
    version => 'v0.10.5',
  }

  class { 'go::global':
    version => '1.1.1'
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

  include osx::finder::empty_trash_securely

  class { 'osx::global::natural_mouse_scrolling':
    enabled => false,
  }
}
