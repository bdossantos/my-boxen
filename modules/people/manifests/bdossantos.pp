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

  repository { 'base16-iterm2':
    ensure => 'origin/master',
    source => 'chriskempson/base16-iterm2',
    path   => "${home}/.base16-iterm2",
  }

  exec { 'Install dotfiles':
    command     => 'sh install.sh',
    cwd         => $dotfiles,
    path        => $::path,
    require     => Repository[$dotfiles],
    refreshonly => true,
  }

  # editor
  include vundle

  package { 'macvim':
    ensure          => latest,
    require         => Package['python3'],
    install_options => [
      '--with-cscope', '--override-system-vim', '--custom-icons',
      '--with-python3',
    ],
  }


  # programming

  ## python
  package { ['python', 'python3', ]:
    ensure          => latest,
    install_options => ['--with-brewed-openssl', ],
  } ->

  package { ['virtualenv', 'fabric', 'pylint', 'flake8', 'howdoi', ]:
    ensure   => present,
    provider => 'pip',
  }

  ## ruby
  package { ['chruby', 'ruby-install', ]:
    ensure => latest,
  }

  file { "${home}/.rubies":
    ensure => directory,
  }

  file { "${home}/.ruby-version":
    ensure  => file,
    content => 'ruby-2.1.1',
    require => Ruby_install['2.1.1'],
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
      require   => [
        File["${prefix}"],
        Package['zsh'],
        Repository['dotfiles'],
      ],
    }
  }

  ruby_install { ['2.1.1', '2.0.0-p353', '2.0.0-p451', '1.9.3-p484', ]:
    ensure => present,
  }

  define gem_install {
    exec { "gem install ${name}":
      command   => "chruby-exec ruby -- gem install ${name}",
      unless    => "chruby-exec ruby -- gem list ${name} -i",
      timeout   => 0,
      user      => $::luser,
      logoutput => 'on_failure',
      require   => Ruby_install['2.1.1'],
    }
  }

  $gems = [
    'bundler', 'tmuxinator', 'fpm', 'pomo', 'rubocop', 'puppet-lint',
    'shell_explain',
  ]

  gem_install { $gems: }

  file { "${home}/.pomo":
    ensure  => link,
    target  => "${home}/Dropbox/.pomo",
    require => [
      Class['dropbox'],
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
    'zopfli', 'tig', 'the_silver_searcher', 'autojump', 'cloc', 'ipcalc',
    'awscli',
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
