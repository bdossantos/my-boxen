class people::bdossantos {
  $home     = "/Users/${::luser}"
  $my       = "${home}/Code"
  $dotfiles = "${my}/dotfiles"

  # browsers
  include chrome
  include chrome::canary
  include firefox

  # terminal
  include iterm2::stable
  include zsh

  repository { $dotfiles:
    source  => 'bdossantos/dotfiles',
  }

  repository { 'oh-my-zsh':
    source => 'robbyrussell/oh-my-zsh',
    path   => "${home}/.oh-my-zsh",
  } ->

  repository { 'pure':
    source => 'sindresorhus/pure',
    path   => "${home}/.oh-my-zsh/custom/pure",
  }

  # editor
  include macvim
  include vundle

  # programming
  include python
  include go
  include go::1_1_1
  include phantomjs
  include phantomjs::1_9_0

  # virtualisation
  include virtualbox
  include vagrant
  include packer

  # image/video
  include vlc
  include gimp
  include imageoptim
  include imagemagick

  # office
  include openoffice

  # cloud drive
  include dropbox
  include googledrive

  # misc
  include nike_plus_connect
  include sequel_pro
  include keepassx
  include flux
  include xz

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
    'zsh-syntax-highlighting',
  ]

  package { $useful:
    ensure => latest,
  }

  include osx::finder::empty_trash_securely

  class { 'osx::global::natural_mouse_scrolling':
    enabled => false,
  }
}
