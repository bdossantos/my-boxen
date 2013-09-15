class people::bdossantos {
  $home     = "/Users/${::luser}"
  $my       = "${home}/Code"
  $dotfiles = "${home}/.dotfiles"

  # browsers
  include chrome
  include chrome::canary
  include firefox
  include opera

  # terminal
  include iterm2::stable
  include zsh
  include tmux

  repository { 'dotfiles':
    ensure  => 'origin/master',
    source  => 'bdossantos/dotfiles',
    path    => $dotfiles,
    notify  => Exec['Install dotfiles'],
    require => Package['stow'],
  }

  repository { 'oh-my-zsh':
    source => 'robbyrussell/oh-my-zsh',
    path   => "${home}/.oh-my-zsh",
  } ->

  repository { 'pure':
    ensure => 'origin/master',
    source => 'sindresorhus/pure',
    path   => "${home}/.oh-my-zsh/custom/pure",
  }

  exec { 'Install dotfiles':
    command     => 'sh install.sh',
    cwd         => $dotfiles,
    path        => $::path,
    require     => Repository[$dotfiles],
    refreshonly => true,
  }

  # editor
  include macvim
  include vundle

  # programming
  include python
  include phantomjs
  include phantomjs::1_9_0

  class { 'ruby':
    chruby_rubies => "${home}/.rubies",
  }

  class { 'ruby::global':
    version => '2.0.0',
  }

  ruby::gem { 'gem install tmuxinator':
    gem   => 'tmuxinator',
    ruby  => '2.0.0',
    #version => '~> 1.2.0'
  }

  class { 'nodejs::global':
    version => 'v0.10.18',
  }

  file { "${::BOXEN_ENV_DIR}/goenv.sh":
    ensure => absent,
  } ->

  package { 'go':
    ensure => installed,
  }

  class { 'phantomjs::global':
    version => '1.9.0',
  }

  # virtualisation
  include virtualbox
  include vagrant
  include packer

  # image/video
  include vlc
  include gimp
  include imageoptim
  include imagemagick

  package { 'ffmpeg':
    ensure => latest,
  }

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

  $useful = [
    'wget', 'ruby-build', 'htop-osx', 'curl', 'ssh-copy-id', 'pwgen', 'gsl',
    'zsh-syntax-highlighting', 'watch', 'stow', 'closure-compiler',
    'htmlcompressor', 'moreutils',
  ]

  package { $useful:
    ensure => latest,
  }

  # osx
  include osx::finder::empty_trash_securely
  include osx::global::key_repeat_delay
  include osx::global::key_repeat_rate
  include osx::dock::icon_size

  class { 'osx::global::natural_mouse_scrolling':
    enabled => false,
  }
}
