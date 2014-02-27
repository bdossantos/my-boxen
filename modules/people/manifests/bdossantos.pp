class people::bdossantos {
  $home     = "/Users/${::luser}"
  $my       = "${home}/Code"
  $dotfiles = "${home}/.dotfiles"

  # browsers
  include chrome
  include chrome::canary
  include firefox
  include opera
  include opera::mobile

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
    ensure => 'origin/master',
    source => 'robbyrussell/oh-my-zsh',
    path   => "${home}/.oh-my-zsh",
  } ->

  repository { 'pure':
    ensure => 'origin/master',
    source => 'sindresorhus/pure',
    path   => "${home}/.oh-my-zsh/custom/pure",
  }

  repository { 'dracula-theme':
    ensure => 'origin/master',
    source => 'zenorocha/dracula-theme',
    path   => "${home}/.dracula-theme",
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

  ## python
  include python

  ## ruby
  package { ['chruby', 'ruby-install', ]:
    ensure => latest,
  }

  file { "${home}/.rubies":
    ensure => directory,
  }

  # yes, this define is not inside autoload module layout and a class
  define ruby_install($ensure = 'present') {
    $ruby = $name
    $prefix = "${people::bdossantos::home}/.rubies"

    exec { "ruby-install ${ruby}":
      command   => "ruby-install -i ${prefix}/ruby-${ruby} ruby ${ruby}",
      timeout   => 0,
      creates   => "${prefix}/ruby-${ruby}",
      user      => $::luser,
      logoutput => 'on_failure',
      cwd       => $prefix,
      require   => File["${prefix}"],
    }
  }

  ruby_install { ['2.1.1', '2.0.0-p247', '2.0.0-p353', '1.9.3-p484', ]:
    ensure => present,
  }

  package { ['bundler', 'tmuxinator', 'fpm', 'pomo', 'veewee', ]:
    ensure   => present,
    provider => 'gem',
  }

  file { "${home}/.pomo":
    ensure  => link,
    target  => "${home}/Dropbox/.pomo",
    require => [
      Class['dropbox'],
      Package['pomo'],
    ],
  }

  ## node.js
  package { 'nodejs':
    ensure => latest,
  }

  ## go
  file { "${::BOXEN_ENV_DIR}/goenv.sh":
    ensure => absent,
  } ->

  package { 'go':
    ensure => installed,
  }

  ## phantomJS
  package { 'phantomjs':
    ensure => latest,
  }

  # virtualisation
  include virtualbox
  include vagrant

  homebrew::tap { 'homebrew/binary': } ->

  package { ['packer', 'docker', 'boot2docker', ]:
    ensure => latest,
  }

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
  include spectacle
  include keepassx
  include hipchat
  include flux
  include xz

  $useful = [
    'wget', 'coreutils', 'htop-osx', 'curl', 'ssh-copy-id', 'pwgen', 'gsl',
    'zsh-syntax-highlighting', 'watch', 'stow', 'closure-compiler', 'pv',
    'htmlcompressor', 'moreutils', 'netcat', 'nmap', 'colordiff', 'jq',
    'ncftp', 'spark', 'battery', 'tcpdump', 'cmake', 'readline', 'gnu-sed',
    'tree', 'pigz', 'reattach-to-user-namespace', 'tmux-mem-cpu-load',
    'zopfli', 'tig', 'the_silver_searcher', 'autojump',
  ]

  homebrew::tap { 'Goles/battery': } ->

  package { $useful:
    ensure => latest,
  }

  file { "${home}/tmp":
    ensure => directory,
    owner  => $::luser,
    mode   => '1700',
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
